import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../services/preferences_service.dart';

/// Provider for the currently active workspace ID
final activeWorkspaceIdProvider =
    StateNotifierProvider<ActiveWorkspaceNotifier, String?>(
      (ref) => ActiveWorkspaceNotifier(),
    );

/// Notifier for managing the currently active workspace
class ActiveWorkspaceNotifier extends StateNotifier<String?> {
  static const String _storageKey = 'activeWorkspaceId';
  final _preferencesService = PreferencesService.instance;

  ActiveWorkspaceNotifier() : super(null) {
    _initializeActiveWorkspace();
  }

  /// Initialize active workspace from persistent storage
  Future<void> _initializeActiveWorkspace() async {
    final savedId = await _preferencesService.getString(_storageKey);
    if (savedId != null) {
      state = savedId;
    }
  }

  /// Set the active workspace and persist
  Future<void> setActiveWorkspace(String workspaceId) async {
    // Debug logging for navigation issues
    // ignore: avoid_print
    print('ACTIVE_WORKSPACE: setting active workspace -> $workspaceId');

    state = workspaceId;
    await _preferencesService.setString(_storageKey, workspaceId);
  }

  /// Create new workspace and make it active
  Future<String> createAndSetActive(String name) async {
    final id = const Uuid().v4();
    state = id;
    await _preferencesService.setString(_storageKey, id);
    return id;
  }

  /// Clear active workspace (e.g., when workspace is deleted)
  Future<void> clearActive() async {
    state = null;
    await _preferencesService.remove(_storageKey);
  }
}

/// Provider to check if we're in onboarding (no active workspace)
final isOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(activeWorkspaceIdProvider) == null;
});
