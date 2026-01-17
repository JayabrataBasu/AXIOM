import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/file_service.dart';
import '../services/sketch_service.dart';

/// Repository for IdeaNode CRUD operations.
/// Uses FileService for persistence - one JSON file per node per workspace.
class NodeRepository {
  NodeRepository({FileService? fileService})
    : _fileService = fileService ?? FileService.instance;

  final FileService _fileService;

  /// In-memory cache of all nodes, keyed by workspace ID.
  final Map<String, Map<String, IdeaNode>> _cacheByWorkspace = {};

  /// Whether the repository has been initialized for each workspace.
  final Map<String, bool> _initializedWorkspaces = {};

  /// Fallback: global cache for nodes without workspace ID (legacy).
  final Map<String, IdeaNode> _globalCache = {};

  /// Get all nodes for a specific workspace (loads from disk on first call).
  Future<List<IdeaNode>> getAllForWorkspace(String workspaceId) async {
    if (_initializedWorkspaces[workspaceId] != true) {
      await _loadWorkspace(workspaceId);
    }
    return (_cacheByWorkspace[workspaceId] ?? {}).values.toList();
  }

  /// Get all nodes across all workspaces (legacy support).
  Future<List<IdeaNode>> getAll() async {
    // Load legacy global nodes if not done
    if (_initializedWorkspaces['__global__'] != true) {
      await _loadLegacyGlobalNodes();
    }
    // Return all nodes from all workspaces
    final allNodes = <IdeaNode>[];
    for (final cache in _cacheByWorkspace.values) {
      allNodes.addAll(cache.values);
    }
    allNodes.addAll(_globalCache.values);
    return allNodes;
  }

  /// Get a node by ID (searches all workspaces).
  Future<IdeaNode?> getById(String id) async {
    // Search all workspace caches
    for (final cache in _cacheByWorkspace.values) {
      if (cache.containsKey(id)) return cache[id];
    }
    // Check global cache
    if (_globalCache.containsKey(id)) return _globalCache[id];

    // Not in cache - try to load all workspaces
    await getAll();

    // Search again
    for (final cache in _cacheByWorkspace.values) {
      if (cache.containsKey(id)) return cache[id];
    }
    return _globalCache[id];
  }

  /// Create a new node.
  Future<IdeaNode> create(IdeaNode node) async {
    await _save(node);

    // Cache in workspace-specific cache
    if (node.workspaceId.isNotEmpty) {
      _cacheByWorkspace[node.workspaceId] ??= {};
      _cacheByWorkspace[node.workspaceId]![node.id] = node;
    } else {
      // Fallback to global cache for legacy nodes
      _globalCache[node.id] = node;
    }

    return node;
  }

  /// Update an existing node.
  Future<IdeaNode> update(IdeaNode node) async {
    final updated = node.copyWith(updatedAt: DateTime.now());
    await _save(updated);

    // Update in workspace-specific cache
    if (updated.workspaceId.isNotEmpty) {
      _cacheByWorkspace[updated.workspaceId] ??= {};
      _cacheByWorkspace[updated.workspaceId]![updated.id] = updated;
    } else {
      _globalCache[updated.id] = updated;
    }

    return updated;
  }

  /// Delete a node by ID.
  Future<void> delete(String id) async {
    // Find node in caches
    IdeaNode? node;
    for (final cache in _cacheByWorkspace.values) {
      if (cache.containsKey(id)) {
        node = cache[id];
        break;
      }
    }
    node ??= _globalCache[id];

    if (node != null) {
      // Clean up sketch assets
      for (final block in node.blocks) {
        if (block.runtimeType.toString().contains('SketchBlock')) {
          final sketch = block as dynamic;
          await SketchService.instance.deleteSketchAssets(
            blockId: block.id,
            strokeFile: sketch.strokeFile as String,
            thumbnailFile: (sketch.thumbnailFile as String).isNotEmpty
                ? sketch.thumbnailFile as String
                : null,
          );
        }
      }

      // Delete file from disk
      final filePath = node.workspaceId.isNotEmpty
          ? await _fileService.workspaceNodeFilePath(node.workspaceId, id)
          : await _fileService.nodeFilePath(id);
      await _fileService.deleteFile(filePath);

      // Remove from cache
      if (node.workspaceId.isNotEmpty) {
        _cacheByWorkspace[node.workspaceId]?.remove(id);
      } else {
        _globalCache.remove(id);
      }
    }
  }

  /// Load nodes for a specific workspace from disk into cache.
  Future<void> _loadWorkspace(String workspaceId) async {
    try {
      final workspaceDir = await _fileService.workspaceNodesDirectory(
        workspaceId,
      );
      debugPrint('Loading workspace nodes from: ${workspaceDir.path}');
      final files = await _fileService.listJsonFiles(workspaceDir);
      debugPrint('Found ${files.length} node files');

      _cacheByWorkspace[workspaceId] = {};

      for (final file in files) {
        final json = await _fileService.readJson(file.path);
        if (json != null) {
          try {
            final node = IdeaNode.fromJson(json);
            _cacheByWorkspace[workspaceId]![node.id] = node;
          } catch (e) {
            assert(() {
              debugPrint('Error parsing node from ${file.path}: $e');
              return true;
            }());
          }
        }
      }

      _initializedWorkspaces[workspaceId] = true;
    } catch (e) {
      // Workspace directory might not exist yet - check for legacy nodes to migrate
      debugPrint(
        'Workspace directory does not exist, checking for migration: $e',
      );
      _cacheByWorkspace[workspaceId] = {};
      await _migrateLegacyNodesForWorkspace(workspaceId);
      _initializedWorkspaces[workspaceId] = true;
    }
  }

  /// Migrate legacy global nodes that belong to this workspace.
  Future<void> _migrateLegacyNodesForWorkspace(String workspaceId) async {
    try {
      final nodesDir = await _fileService.nodesDirectory;
      final files = await _fileService.listJsonFiles(nodesDir);

      for (final file in files) {
        final json = await _fileService.readJson(file.path);
        if (json != null) {
          try {
            final node = IdeaNode.fromJson(json);

            // Only migrate nodes that belong to this workspace
            if (node.workspaceId == workspaceId) {
              // Save to workspace-specific location
              final newPath = await _fileService.workspaceNodeFilePath(
                workspaceId,
                node.id,
              );
              await _fileService.writeJson(newPath, node.toJson());

              // Add to cache
              _cacheByWorkspace[workspaceId]![node.id] = node;

              // Delete old file
              await _fileService.deleteFile(file.path);

              debugPrint(
                'Migrated node ${node.id} from global to workspace $workspaceId',
              );
            }
          } catch (e) {
            debugPrint('Error migrating node from ${file.path}: $e');
          }
        }
      }
    } catch (e) {
      // No legacy nodes directory or migration failed - that's okay
      debugPrint('Legacy node migration skipped: $e');
    }
  }

  /// Load legacy global nodes (for backward compatibility).
  Future<void> _loadLegacyGlobalNodes() async {
    try {
      final nodesDir = await _fileService.nodesDirectory;
      final files = await _fileService.listJsonFiles(nodesDir);

      for (final file in files) {
        final json = await _fileService.readJson(file.path);
        if (json != null) {
          try {
            final node = IdeaNode.fromJson(json);
            _globalCache[node.id] = node;
          } catch (e) {
            assert(() {
              debugPrint('Error parsing node from ${file.path}: $e');
              return true;
            }());
          }
        }
      }

      _initializedWorkspaces['__global__'] = true;
    } catch (e) {
      _initializedWorkspaces['__global__'] = true;
    }
  }

  /// Save a node to disk.
  Future<void> _save(IdeaNode node) async {
    // Use workspace-specific path if workspace ID is set
    final filePath = node.workspaceId.isNotEmpty
        ? await _fileService.workspaceNodeFilePath(node.workspaceId, node.id)
        : await _fileService.nodeFilePath(node.id);
    debugPrint('Saving node ${node.id} to: $filePath');
    await _fileService.writeJson(filePath, node.toJson());
    debugPrint('Node saved successfully');
  }

  /// Force reload from disk (useful after external changes).
  Future<void> reload() async {
    _cacheByWorkspace.clear();
    _globalCache.clear();
    _initializedWorkspaces.clear();
  }

  /// Reload a specific workspace.
  Future<void> reloadWorkspace(String workspaceId) async {
    _cacheByWorkspace.remove(workspaceId);
    _initializedWorkspaces.remove(workspaceId);
    await _loadWorkspace(workspaceId);
  }

  /// Get the count of nodes in a workspace.
  Future<int> countForWorkspace(String workspaceId) async {
    if (_initializedWorkspaces[workspaceId] != true) {
      await _loadWorkspace(workspaceId);
    }
    return (_cacheByWorkspace[workspaceId] ?? {}).length;
  }

  /// Get the count of all nodes.
  Future<int> count() async {
    await getAll();
    int total = _globalCache.length;
    for (final cache in _cacheByWorkspace.values) {
      total += cache.length;
    }
    return total;
  }
}
