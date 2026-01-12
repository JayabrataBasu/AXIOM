import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_block.dart';
import 'position.dart';

part 'idea_node.freezed.dart';
part 'idea_node.g.dart';

/// The one primary entity in Axiom.
/// Everything else (text, math, sketches, audio, PDFs, calculations, references)
/// must attach to or reference an IdeaNode.
@freezed
class IdeaNode with _$IdeaNode {
  const IdeaNode._();

  const factory IdeaNode({
    /// Unique identifier for this node
    required String id,

    /// Timestamp when this node was created
    required DateTime createdAt,

    /// Timestamp when this node was last modified
    required DateTime updatedAt,

    /// Position on the canvas
    @Default(Position()) Position position,

    /// Ordered list of content blocks
    @Default([]) List<ContentBlock> blocks,

    /// Links to other IdeaNodes (Stage 9)
    @Default([]) List<NodeLink> links,
  }) = _IdeaNode;

  factory IdeaNode.fromJson(Map<String, dynamic> json) =>
      _$IdeaNodeFromJson(json);

  /// Returns preview text from the first content block, or empty string.
  String get previewText {
    for (final block in blocks) {
      final text = switch (block) {
        TextBlock(:final content) when content.isNotEmpty => content,
        HeadingBlock(:final content) when content.isNotEmpty => content,
        BulletListBlock(:final items) when items.isNotEmpty => items.first,
        CodeBlock(:final content) when content.isNotEmpty => content,
        QuoteBlock(:final content) when content.isNotEmpty => '"$content"',
        _ => null,
      };
      if (text != null) {
        return text.length > 100 ? '${text.substring(0, 100)}...' : text;
      }
    }
    return '';
  }
}

/// A semantic link to another IdeaNode.
@freezed
class NodeLink with _$NodeLink {
  const factory NodeLink({
    required String targetNodeId,
    @Default('') String label,
    required DateTime createdAt,
  }) = _NodeLink;

  factory NodeLink.fromJson(Map<String, dynamic> json) =>
      _$NodeLinkFromJson(json);
}
