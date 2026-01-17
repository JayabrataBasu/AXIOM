import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../models/node_template.dart';
import '../repositories/repositories.dart';

/// Provider for the WorkspaceRepository singleton.
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepository();
});

/// Provider for loading all workspace sessions.
final workspaceSessionsProvider = FutureProvider<List<WorkspaceSession>>((
  ref,
) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.getAll();
});

/// Notifier for managing workspace sessions with CRUD operations.
class WorkspaceSessionsNotifier extends AsyncNotifier<List<WorkspaceSession>> {
  late WorkspaceRepository _repository;
  final _uuid = const Uuid();

  @override
  Future<List<WorkspaceSession>> build() async {
    _repository = ref.watch(workspaceRepositoryProvider);
    return _repository.getAll();
  }

  /// Create a new workspace session.
  Future<WorkspaceSession> createSession({
    required String workspaceType,
    String label = '',
    Map<String, dynamic>? data,
    NodeTemplate? template,
  }) async {
    final now = DateTime.now();
    final sessionData = data ?? {};

    // If template is provided, initialize with template blocks
    if (template != null) {
      sessionData['templateName'] = template.name;
      sessionData['initialBlockCount'] = template.blocks().length;
    }

    final session = WorkspaceSession(
      id: _uuid.v4(),
      workspaceType: workspaceType,
      createdAt: now,
      updatedAt: now,
      data: sessionData,
      label: label,
    );

    await _repository.create(session);

    // Update state
    final currentSessions = state.valueOrNull ?? [];
    state = AsyncData([...currentSessions, session]);

    return session;
  }

  /// Update a workspace session.
  Future<void> updateSession(WorkspaceSession session) async {
    await _repository.update(session);

    // Update state
    final currentSessions = state.valueOrNull ?? [];
    state = AsyncData(
      currentSessions.map((s) => s.id == session.id ? session : s).toList(),
    );
  }

  /// Delete a session by ID.
  Future<void> deleteSession(String id) async {
    await _repository.delete(id);

    // Update state
    final currentSessions = state.valueOrNull ?? [];
    state = AsyncData(currentSessions.where((s) => s.id != id).toList());
  }

  /// Fork a session (create a new session based on an existing one).
  /// Automatically names it "{original name} fork {n}" where n is the next fork number.
  Future<WorkspaceSession> forkSession(String sessionId) async {
    final original = await _repository.getById(sessionId);
    if (original == null) throw Exception('Original session not found');

    // Find the next fork number by checking all sessions with similar names
    final allSessions = state.valueOrNull ?? [];
    final baseName = original.label.isNotEmpty ? original.label : 'Session';
    
    // Count existing forks with pattern "baseName fork n"
    int nextForkNumber = 1;
    for (final session in allSessions) {
      final label = session.label;
      if (label.startsWith('$baseName fork ')) {
        final suffix = label.substring('$baseName fork '.length);
        final num = int.tryParse(suffix);
        if (num != null && num >= nextForkNumber) {
          nextForkNumber = num + 1;
        }
      }
    }

    final forkedId = _uuid.v4();
    var forked = await _repository.fork(sessionId, forkedId);
    
    // Rename to include fork number
    final forkName = '$baseName fork $nextForkNumber';
    forked = forked.copyWith(label: forkName);
    await _repository.update(forked);

    // Update state
    final currentSessions = state.valueOrNull ?? [];
    state = AsyncData([...currentSessions, forked]);

    return forked;
  }

  /// Clone a session with a custom name.
  Future<WorkspaceSession> cloneSession(
    String sessionId, {
    String? newName,
  }) async {
    final forkedId = _uuid.v4();
    final forked = await _repository.fork(sessionId, forkedId);

    // Update name if provided
    final cloned = newName != null && newName.isNotEmpty
        ? forked.copyWith(label: newName)
        : forked;

    // Save with new name if changed
    if (cloned != forked) {
      await _repository.update(cloned);
    }

    // Update state
    final currentSessions = state.valueOrNull ?? [];
    state = AsyncData([...currentSessions, cloned]);

    return cloned;
  }

  /// Reload sessions from disk.
  Future<void> reload() async {
    _repository.clearCache();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll());
  }
}

/// Riverpod notifier provider for workspace sessions.
final workspaceSessionsNotifierProvider =
    AsyncNotifierProvider<WorkspaceSessionsNotifier, List<WorkspaceSession>>(
      WorkspaceSessionsNotifier.new,
    );

/// Get sessions by workspace type.
final workspaceSessionsByTypeProvider =
    FutureProvider.family<List<WorkspaceSession>, String>((
      ref,
      workspaceType,
    ) async {
      final repository = ref.watch(workspaceRepositoryProvider);
      return repository.getAllByType(workspaceType);
    });

/// Get a single session by ID.
final workspaceSessionProvider =
    FutureProvider.family<WorkspaceSession?, String>((ref, sessionId) async {
      final repository = ref.watch(workspaceRepositoryProvider);
      return repository.getById(sessionId);
    });
