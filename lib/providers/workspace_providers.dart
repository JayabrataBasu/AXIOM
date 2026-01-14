import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
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
    required Map<String, dynamic> data,
    String label = '',
  }) async {
    final now = DateTime.now();
    final session = WorkspaceSession(
      id: _uuid.v4(),
      workspaceType: workspaceType,
      createdAt: now,
      updatedAt: now,
      data: data,
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
  Future<WorkspaceSession> forkSession(String sessionId) async {
    final forkedId = _uuid.v4();
    final forked = await _repository.fork(sessionId, forkedId);

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
