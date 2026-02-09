import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mind_map.dart';
import '../models/position.dart';
import '../services/mind_map_service.dart';

const _uuid = Uuid();

/// Provider for a specific mind map
final mindMapProvider = FutureProvider.family<MindMapGraph?, String>((
  ref,
  mapId,
) async {
  final workspaceId = ref.watch(activeMindMapWorkspaceProvider);
  if (workspaceId == null) return null;

  return await MindMapService.instance.loadMindMap(workspaceId, mapId);
});

/// Provider for the active workspace ID for mind maps
final activeMindMapWorkspaceProvider = StateProvider<String?>((ref) => null);

/// State notifier for managing mind map operations
class MindMapNotifier extends StateNotifier<AsyncValue<MindMapGraph>> {
  MindMapNotifier(this.workspaceId, this.mapId)
    : super(const AsyncValue.loading()) {
    _loadMap();
  }

  final String workspaceId;
  final String mapId;
  final MindMapService _service = MindMapService.instance;

  Future<void> _loadMap() async {
    try {
      final map = await _service.loadMindMap(workspaceId, mapId);
      if (map != null) {
        state = AsyncValue.data(map);
      } else {
        state = AsyncValue.error('Mind map not found', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _saveMap(MindMapGraph map) async {
    await _service.saveMindMap(map);
  }

  /// Add a new child node to a parent
  Future<MindMapNode?> addChildNode(
    String parentId,
    String text, {
    Position? position,
  }) async {
    final currentMap = state.valueOrNull;
    if (currentMap == null) return null;

    final parent = currentMap.nodes[parentId];
    if (parent == null) return null;

    final now = DateTime.now();
    final nodeId = _uuid.v4();

    final newNode = MindMapNode(
      id: nodeId,
      parentId: parentId,
      text: text,
      position: position ?? const Position(x: 100, y: 100),
      createdAt: now,
      updatedAt: now,
    );

    final updatedParent = parent.copyWith(
      childIds: [...parent.childIds, nodeId],
      updatedAt: now,
    );

    final updatedNodes = Map<String, MindMapNode>.from(currentMap.nodes);
    updatedNodes[nodeId] = newNode;
    updatedNodes[parentId] = updatedParent;

    final updatedMap = currentMap.copyWith(nodes: updatedNodes, updatedAt: now);

    state = AsyncValue.data(updatedMap);
    await _saveMap(updatedMap);
    return newNode;
  }

  /// Update a node's text
  Future<void> updateNodeText(String nodeId, String text) async {
    state.whenData((map) async {
      final node = map.nodes[nodeId];
      if (node == null) return;

      final now = DateTime.now();
      final updatedNode = node.copyWith(text: text, updatedAt: now);

      final updatedNodes = Map<String, MindMapNode>.from(map.nodes);
      updatedNodes[nodeId] = updatedNode;

      final updatedMap = map.copyWith(nodes: updatedNodes, updatedAt: now);

      state = AsyncValue.data(updatedMap);
      await _saveMap(updatedMap);
    });
  }

  /// Update a node's position
  Future<void> updateNodePosition(String nodeId, Position position) async {
    state.whenData((map) async {
      final node = map.nodes[nodeId];
      if (node == null) return;

      final now = DateTime.now();
      final updatedNode = node.copyWith(position: position, updatedAt: now);

      final updatedNodes = Map<String, MindMapNode>.from(map.nodes);
      updatedNodes[nodeId] = updatedNode;

      final updatedMap = map.copyWith(nodes: updatedNodes, updatedAt: now);

      state = AsyncValue.data(updatedMap);
      await _saveMap(updatedMap);
    });
  }

  /// Toggle a node's collapsed state
  Future<void> toggleNodeCollapsed(String nodeId) async {
    state.whenData((map) async {
      final node = map.nodes[nodeId];
      if (node == null) return;

      final now = DateTime.now();
      final updatedNode = node.copyWith(
        collapsed: !node.collapsed,
        updatedAt: now,
      );

      final updatedNodes = Map<String, MindMapNode>.from(map.nodes);
      updatedNodes[nodeId] = updatedNode;

      final updatedMap = map.copyWith(nodes: updatedNodes, updatedAt: now);

      state = AsyncValue.data(updatedMap);
      await _saveMap(updatedMap);
    });
  }

  /// Delete a node and all its descendants
  Future<void> deleteNode(String nodeId) async {
    state.whenData((map) async {
      final node = map.nodes[nodeId];
      if (node == null || node.parentId == null) return; // Can't delete root

      final now = DateTime.now();
      final updatedNodes = Map<String, MindMapNode>.from(map.nodes);

      // Remove from parent's child list
      final parent = updatedNodes[node.parentId];
      if (parent != null) {
        updatedNodes[node.parentId!] = parent.copyWith(
          childIds: parent.childIds.where((id) => id != nodeId).toList(),
          updatedAt: now,
        );
      }

      // Recursively delete node and descendants
      void deleteNodeAndChildren(String id) {
        final n = updatedNodes[id];
        if (n != null) {
          for (final childId in n.childIds) {
            deleteNodeAndChildren(childId);
          }
          updatedNodes.remove(id);
        }
      }

      deleteNodeAndChildren(nodeId);

      final updatedMap = map.copyWith(nodes: updatedNodes, updatedAt: now);

      state = AsyncValue.data(updatedMap);
      await _saveMap(updatedMap);
    });
  }

  /// Update node style properties (background, border, text color)
  Future<void> updateNodeStyle(
    String nodeId,
    String type,
    int colorValue,
  ) async {
    final currentMap = state.valueOrNull;
    if (currentMap == null) return;

    final node = currentMap.nodes[nodeId];
    if (node == null) return;

    final now = DateTime.now();
    final updatedStyle = switch (type) {
      'background' => node.style.copyWith(backgroundColor: colorValue),
      'border' => node.style.copyWith(borderColor: colorValue),
      'text' => node.style.copyWith(textColor: colorValue),
      _ => node.style,
    };

    final updatedNode = node.copyWith(style: updatedStyle, updatedAt: now);
    final updatedNodes = Map<String, MindMapNode>.from(currentMap.nodes);
    updatedNodes[nodeId] = updatedNode;

    final updatedMap = currentMap.copyWith(nodes: updatedNodes, updatedAt: now);

    state = AsyncValue.data(updatedMap);
    await _saveMap(updatedMap);
  }

  /// Update node shape
  Future<void> updateNodeShape(String nodeId, String shape) async {
    final currentMap = state.valueOrNull;
    if (currentMap == null) return;

    final node = currentMap.nodes[nodeId];
    if (node == null) return;

    final now = DateTime.now();
    final updatedStyle = node.style.copyWith(shape: shape);
    final updatedNode = node.copyWith(style: updatedStyle, updatedAt: now);
    final updatedNodes = Map<String, MindMapNode>.from(currentMap.nodes);
    updatedNodes[nodeId] = updatedNode;

    final updatedMap = currentMap.copyWith(nodes: updatedNodes, updatedAt: now);

    state = AsyncValue.data(updatedMap);
    await _saveMap(updatedMap);
  }

  /// Update node emoji
  Future<void> updateNodeEmoji(String nodeId, String emoji) async {
    final currentMap = state.valueOrNull;
    if (currentMap == null) return;

    final node = currentMap.nodes[nodeId];
    if (node == null) return;

    final now = DateTime.now();
    final updatedStyle = node.style.copyWith(emoji: emoji);
    final updatedNode = node.copyWith(style: updatedStyle, updatedAt: now);
    final updatedNodes = Map<String, MindMapNode>.from(currentMap.nodes);
    updatedNodes[nodeId] = updatedNode;

    final updatedMap = currentMap.copyWith(nodes: updatedNodes, updatedAt: now);

    state = AsyncValue.data(updatedMap);
    await _saveMap(updatedMap);
  }

  /// Update node priority
  Future<void> updateNodePriority(String nodeId, String priority) async {
    final currentMap = state.valueOrNull;
    if (currentMap == null) return;

    final node = currentMap.nodes[nodeId];
    if (node == null) return;

    final now = DateTime.now();
    final updatedNode = node.copyWith(priority: priority, updatedAt: now);
    final updatedNodes = Map<String, MindMapNode>.from(currentMap.nodes);
    updatedNodes[nodeId] = updatedNode;

    final updatedMap = currentMap.copyWith(nodes: updatedNodes, updatedAt: now);

    state = AsyncValue.data(updatedMap);
    await _saveMap(updatedMap);
  }

  /// Reload the map from disk
  Future<void> reload() async {
    await _loadMap();
  }
}

/// Provider for mind map notifier
final mindMapNotifierProvider =
    StateNotifierProvider.family<
      MindMapNotifier,
      AsyncValue<MindMapGraph>,
      ({String workspaceId, String mapId})
    >((ref, params) {
      return MindMapNotifier(params.workspaceId, params.mapId);
    });
