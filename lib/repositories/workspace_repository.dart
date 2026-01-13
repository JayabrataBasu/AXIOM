import 'package:flutter/foundation.dart';
import '../models/workspace_session.dart';
import '../services/file_service.dart';

/// Repository for WorkspaceSession CRUD operations.
/// Uses FileService for persistence - one JSON file per session.
class WorkspaceRepository {
  WorkspaceRepository({FileService? fileService})
      : _fileService = fileService ?? FileService.instance;

  final FileService _fileService;

  /// In-memory cache of all sessions.
  final Map<String, WorkspaceSession> _cache = {};

  /// Whether the repository has been initialized.
  bool _initialized = false;

  /// Get all sessions (loads from disk on first call).
  Future<List<WorkspaceSession>> getAll() async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache.values.toList();
  }

  /// Get all sessions of a specific type.
  Future<List<WorkspaceSession>> getAllByType(String workspaceType) async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache.values
        .where((s) => s.workspaceType == workspaceType)
        .toList();
  }

  /// Get a session by ID.
  Future<WorkspaceSession?> getById(String id) async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache[id];
  }

  /// Create a new session.
  Future<WorkspaceSession> create(WorkspaceSession session) async {
    await _save(session);
    _cache[session.id] = session;
    return session;
  }

  /// Update an existing session.
  Future<WorkspaceSession> update(WorkspaceSession session) async {
    final updated = session.copyWith(updatedAt: DateTime.now());
    await _save(updated);
    _cache[updated.id] = updated;
    return updated;
  }

  /// Delete a session by ID.
  Future<void> delete(String id) async {
    final filePath = await _fileService.sessionFilePath(id);
    await _fileService.deleteFile(filePath);
    _cache.remove(id);
  }

  /// Fork a session (create a new session based on an existing one).
  Future<WorkspaceSession> fork(String sessionId, String newSessionId) async {
    final session = await getById(sessionId);
    if (session == null) throw Exception('Session not found: $sessionId');

    final now = DateTime.now();
    final forked = session.copyWith(
      id: newSessionId,
      createdAt: now,
      updatedAt: now,
      parentSessionId: sessionId,
    );

    return create(forked);
  }

  /// Load all sessions from disk into cache.
  Future<void> _loadAll() async {
    final sessionsDir = await _fileService.sessionsDirectory;
    final files = await _fileService.listJsonFiles(sessionsDir);

    for (final file in files) {
      final json = await _fileService.readJson(file.path);
      if (json != null) {
        try {
          final session = WorkspaceSession.fromJson(json);
          _cache[session.id] = session;
        } catch (e) {
          // Skip corrupted files - corruption isolation
          assert(() {
            debugPrint('Error parsing session from ${file.path}: $e');
            return true;
          }());
        }
      }
    }

    _initialized = true;
  }

  /// Save a session to disk.
  Future<void> _save(WorkspaceSession session) async {
    final filePath = await _fileService.sessionFilePath(session.id);
    await _fileService.writeJson(filePath, session.toJson());
  }

  /// Clear the cache (for testing).
  void clearCache() {
    _cache.clear();
    _initialized = false;
  }
}
