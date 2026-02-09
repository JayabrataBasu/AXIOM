import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;
import '../models/mind_map.dart';
import '../models/position.dart';
import 'file_service.dart';

/// Service for managing mind map persistence.
class MindMapService {
  MindMapService._();
  static final MindMapService instance = MindMapService._();

  final FileService _fileService = FileService.instance;

  /// Built-in mind map templates
  static const List<MindMapTemplate> templates = [
    MindMapTemplate(
      id: 'blank',
      name: 'Blank',
      description: 'Start from scratch',
    ),
    MindMapTemplate(
      id: 'swot',
      name: 'SWOT Analysis',
      description: 'Strengths, Weaknesses, Opportunities, Threats',
    ),
    MindMapTemplate(
      id: 'project',
      name: 'Project Plan',
      description: 'Goals, Tasks, Risks, Timeline',
    ),
    MindMapTemplate(
      id: 'meeting',
      name: 'Meeting Notes',
      description: 'Agenda, Decisions, Actions, Questions',
    ),
  ];

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
    return createMindMapWithTemplate(
      workspaceId: workspaceId,
      name: name,
      templateId: 'blank',
    );
  }

  /// Create a new mind map with a specific template
  Future<MindMapGraph> createMindMapWithTemplate({
    required String workspaceId,
    required String name,
    required String templateId,
  }) async {
    final now = DateTime.now();
    final mapId = DateTime.now().millisecondsSinceEpoch.toString();
    final rootNodeId = '${mapId}_root';

    final nodes = _buildTemplateNodes(
      templateId: templateId,
      rootNodeId: rootNodeId,
      name: name,
      now: now,
    );

    final map = MindMapGraph(
      id: mapId,
      name: name,
      workspaceId: workspaceId,
      templateId: templateId,
      rootNodeId: rootNodeId,
      nodes: nodes,
      createdAt: now,
      updatedAt: now,
    );

    await saveMindMap(map);
    return map;
  }

  Map<String, MindMapNode> _buildTemplateNodes({
    required String templateId,
    required String rootNodeId,
    required String name,
    required DateTime now,
  }) {
    final center = const Position(x: 2000, y: 2000);

    MindMapNode rootNode(String text) => MindMapNode(
      id: rootNodeId,
      text: text,
      position: center,
      createdAt: now,
      updatedAt: now,
    );

    List<MindMapNode> childrenFromLabels(List<String> labels) {
      final radius = 280.0;
      return List.generate(labels.length, (index) {
        final angle = (index / labels.length) * 6.283185307179586;
        final childId = '${rootNodeId}_$index';
        return MindMapNode(
          id: childId,
          parentId: rootNodeId,
          text: labels[index],
          position: Position(
            x: center.x + radius * math.cos(angle),
            y: center.y + radius * math.sin(angle),
          ),
          createdAt: now,
          updatedAt: now,
        );
      });
    }

    switch (templateId) {
      case 'swot':
        final labels = ['Strengths', 'Weaknesses', 'Opportunities', 'Threats'];
        final root = rootNode(name);
        final children = childrenFromLabels(labels);
        return {
          root.id: root.copyWith(childIds: children.map((c) => c.id).toList()),
          for (final child in children) child.id: child,
        };
      case 'project':
        final labels = ['Goals', 'Tasks', 'Timeline', 'Risks'];
        final root = rootNode(name);
        final children = childrenFromLabels(labels);
        return {
          root.id: root.copyWith(childIds: children.map((c) => c.id).toList()),
          for (final child in children) child.id: child,
        };
      case 'meeting':
        final labels = ['Agenda', 'Decisions', 'Actions', 'Questions'];
        final root = rootNode(name);
        final children = childrenFromLabels(labels);
        return {
          root.id: root.copyWith(childIds: children.map((c) => c.id).toList()),
          for (final child in children) child.id: child,
        };
      case 'blank':
      default:
        final root = rootNode(name);
        return {root.id: root};
    }
  }
}

class MindMapTemplate {
  const MindMapTemplate({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}
