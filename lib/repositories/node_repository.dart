import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/file_service.dart';
import '../services/sketch_service.dart';

/// Repository for IdeaNode CRUD operations.
/// Uses FileService for persistence - one JSON file per node.
class NodeRepository {
  NodeRepository({FileService? fileService})
      : _fileService = fileService ?? FileService.instance;

  final FileService _fileService;

  /// In-memory cache of all nodes.
  final Map<String, IdeaNode> _cache = {};

  /// Whether the repository has been initialized.
  bool _initialized = false;

  /// Get all nodes (loads from disk on first call).
  Future<List<IdeaNode>> getAll() async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache.values.toList();
  }

  /// Get a node by ID.
  Future<IdeaNode?> getById(String id) async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache[id];
  }

  /// Create a new node.
  Future<IdeaNode> create(IdeaNode node) async {
    await _save(node);
    _cache[node.id] = node;
    return node;
  }

  /// Update an existing node.
  Future<IdeaNode> update(IdeaNode node) async {
    final updated = node.copyWith(updatedAt: DateTime.now());
    await _save(updated);
    _cache[updated.id] = updated;
    return updated;
  }

  /// Delete a node by ID.
  Future<void> delete(String id) async {
    final node = _cache[id];
    if (node != null) {
      for (final block in node.blocks) {
        // Check if block is SketchBlock by runtimeType
        if (block.runtimeType.toString().contains('SketchBlock')) {
          final sketch = block as dynamic;
          await SketchService.instance.deleteSketchAssets(
            blockId: block.id,
            strokeFile: sketch.strokeFile as String,
            thumbnailFile: (sketch.thumbnailFile as String).isNotEmpty ? sketch.thumbnailFile as String : null,
          );
        }
      }
    }

    final filePath = await _fileService.nodeFilePath(id);
    await _fileService.deleteFile(filePath);
    _cache.remove(id);
  }

  /// Load all nodes from disk into cache.
  Future<void> _loadAll() async {
    final nodesDir = await _fileService.nodesDirectory;
    final files = await _fileService.listJsonFiles(nodesDir);

    for (final file in files) {
      final json = await _fileService.readJson(file.path);
      if (json != null) {
        try {
          final node = IdeaNode.fromJson(json);
          _cache[node.id] = node;
        } catch (e) {
          // Skip corrupted files - corruption isolation (debug-only)
          assert(() {
            debugPrint('Error parsing node from ${file.path}: $e');
            return true;
          }());
        }
      }
    }

    _initialized = true;
  }

  /// Save a node to disk.
  Future<void> _save(IdeaNode node) async {
    final filePath = await _fileService.nodeFilePath(node.id);
    await _fileService.writeJson(filePath, node.toJson());
  }

  /// Force reload from disk (useful after external changes).
  Future<void> reload() async {
    _cache.clear();
    _initialized = false;
    await _loadAll();
  }

  /// Get the count of nodes.
  Future<int> count() async {
    if (!_initialized) {
      await _loadAll();
    }
    return _cache.length;
  }
}
