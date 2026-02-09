import 'package:freezed_annotation/freezed_annotation.dart';
import 'position.dart';

part 'mind_map.freezed.dart';
part 'mind_map.g.dart';

/// A mind map node in a radial/hierarchical graph structure.
@freezed
class MindMapNode with _$MindMapNode {
  const MindMapNode._();

  const factory MindMapNode({
    /// Unique identifier for this node
    required String id,

    /// Parent node ID (null for root node)
    String? parentId,

    /// Node text content
    required String text,

    /// Position in the mind map canvas
    @Default(Position()) Position position,

    /// Visual styling
    @Default(MindMapNodeStyle()) MindMapNodeStyle style,

    /// Child node IDs
    @Default([]) List<String> childIds,

    /// Whether this node is collapsed (children hidden)
    @Default(false) bool collapsed,

    /// Priority level: 'none', 'low', 'high', 'urgent'
    @Default('none') String priority,

    /// Timestamp when created
    required DateTime createdAt,

    /// Timestamp when last modified
    required DateTime updatedAt,
  }) = _MindMapNode;

  factory MindMapNode.fromJson(Map<String, dynamic> json) =>
      _$MindMapNodeFromJson(json);
}

/// Visual styling for a mind map node.
@freezed
class MindMapNodeStyle with _$MindMapNodeStyle {
  const factory MindMapNodeStyle({
    /// Background color as ARGB int (Everforest light parchment by default)
    @Default(0xFFFDF6E3) int backgroundColor,

    /// Text color as ARGB int
    @Default(0xFF000000) int textColor,

    /// Border color as ARGB int (Everforest primary green)
    @Default(0xFF708238) int borderColor,

    /// Border width
    @Default(2.0) double borderWidth,

    /// Shape: 'rounded', 'rectangle', 'circle', 'diamond'
    @Default('rounded') String shape,

    /// Optional emoji icon for the node (single character)
    @Default('') String emoji,
  }) = _MindMapNodeStyle;

  factory MindMapNodeStyle.fromJson(Map<String, dynamic> json) =>
      _$MindMapNodeStyleFromJson(json);
}

/// A complete mind map graph with metadata.
@freezed
class MindMapGraph with _$MindMapGraph {
  const MindMapGraph._();

  const factory MindMapGraph({
    /// Unique identifier for this mind map
    required String id,

    /// Display name
    required String name,

    /// Workspace this map belongs to
    required String workspaceId,

    /// Template identifier used to create this map
    @Default('blank') String templateId,

    /// Root node ID
    String? rootNodeId,

    /// All nodes in the graph (keyed by node ID)
    @Default({}) Map<String, MindMapNode> nodes,

    /// Timestamp when created
    required DateTime createdAt,

    /// Timestamp when last modified
    required DateTime updatedAt,
  }) = _MindMapGraph;

  factory MindMapGraph.fromJson(Map<String, dynamic> json) =>
      _$MindMapGraphFromJson(json);

  /// Get all top-level nodes (nodes with no parent)
  List<MindMapNode> get rootNodes {
    return nodes.values.where((node) => node.parentId == null).toList();
  }

  /// Get children of a specific node
  List<MindMapNode> getChildren(String nodeId) {
    final node = nodes[nodeId];
    if (node == null) return [];
    return node.childIds
        .map((id) => nodes[id])
        .where((n) => n != null)
        .cast<MindMapNode>()
        .toList();
  }

  /// Get parent of a specific node
  MindMapNode? getParent(String nodeId) {
    final node = nodes[nodeId];
    if (node == null || node.parentId == null) return null;
    return nodes[node.parentId];
  }
}
