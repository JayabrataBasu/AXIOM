import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/mind_map.dart';
import '../models/position.dart';
import 'file_service.dart';

/// Service for managing mind map persistence.
class MindMapService {
  MindMapService._();
  static final MindMapService instance = MindMapService._();

  final FileService _fileService = FileService.instance;

  /// Get the directory for mind maps in a workspace
  Future<Directory> _getMindMapsDir(String workspaceId) async {
    final workspaceDir = await _fileService.getSubdirectory(
      'workspaces/$workspaceId',
    );
    final mindMapsDir = Directory(path.join(workspaceDir.path, 'mindmaps'));
    if (!mindMapsDir.existsSync()) {
      mindMapsDir.createSync(recursive: true);
    }
    return mindMapsDir;
  }

  /// Get file path for a specific mind map
  Future<String> _getMindMapFilePath(String workspaceId, String mapId) async {
    final dir = await _getMindMapsDir(workspaceId);
    return path.join(dir.path, '$mapId.json');
  }

  /// Load a mind map by ID
  Future<MindMapGraph?> loadMindMap(String workspaceId, String mapId) async {
    try {
      final filePath = await _getMindMapFilePath(workspaceId, mapId);
      final file = File(filePath);

      if (!file.existsSync()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final map = MindMapGraph.fromJson(json);
      return map;
    } catch (_) {
      return null;
    }
  }

  /// Save a mind map
  Future<void> saveMindMap(MindMapGraph map) async {
    try {
      final filePath = await _getMindMapFilePath(map.workspaceId, map.id);
      final file = File(filePath);

      final json = map.toJson();
      final jsonString = jsonEncode(json);

      await file.writeAsString(jsonString);
    } catch (_) {
      rethrow;
    }
  }

  /// List all mind maps in a workspace
  Future<List<MindMapGraph>> listMindMaps(String workspaceId) async {
    try {
      final dir = await _getMindMapsDir(workspaceId);
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList();

      final maps = <MindMapGraph>[];
      for (final file in files) {
        try {
          final jsonString = await file.readAsString();
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          maps.add(MindMapGraph.fromJson(json));
        } catch (_) {}
      }

      return maps;
    } catch (_) {
      return [];
    }
  }

  /// Delete a mind map
  Future<void> deleteMindMap(String workspaceId, String mapId) async {
    try {
      final filePath = await _getMindMapFilePath(workspaceId, mapId);
      final file = File(filePath);

      if (file.existsSync()) {
        await file.delete();
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Create a new mind map with a root node
  Future<MindMapGraph> createMindMap({
    required String workspaceId,
    required String name,
  }) async {
    final now = DateTime.now();
    final mapId = DateTime.now().millisecondsSinceEpoch.toString();
    final rootNodeId = '${mapId}_root';

    // Position root node at center of the 4000x4000 canvas
    final rootNode = MindMapNode(
      id: rootNodeId,
      text: name,
      position: const Position(x: 2000, y: 2000),
      createdAt: now,
      updatedAt: now,
    );

    final map = MindMapGraph(
      id: mapId,
      name: name,
      workspaceId: workspaceId,
      rootNodeId: rootNodeId,
      nodes: {rootNodeId: rootNode},
      createdAt: now,
      updatedAt: now,
    );

    await saveMindMap(map);
    return map;
  }
}
