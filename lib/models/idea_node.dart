import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_block.dart';
import 'position.dart';

part 'idea_node.freezed.dart';
part 'idea_node.g.dart';

/// Custom JSON converter for `List&lt;ContentBlock&gt;` to handle the sealed union.
class ContentBlockListConverter
    implements JsonConverter<List<ContentBlock>, List<dynamic>> {
  const ContentBlockListConverter();

  @override
  List<ContentBlock> fromJson(List<dynamic> json) {
    return json
        .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<dynamic> toJson(List<ContentBlock> object) {
    return object
        .map(
          (b) => switch (b) {
            TextBlock(:final id, :final content, :final createdAt) => {
              'type': 'text',
              'id': id,
              'content': content,
              'createdAt': createdAt.toIso8601String(),
            },
            HeadingBlock(
              :final id,
              :final content,
              :final level,
              :final createdAt,
            ) =>
              {
                'type': 'heading',
                'id': id,
                'content': content,
                'level': level,
                'createdAt': createdAt.toIso8601String(),
              },
            BulletListBlock(:final id, :final items, :final createdAt) => {
              'type': 'bulletList',
              'id': id,
              'items': items,
              'createdAt': createdAt.toIso8601String(),
            },
            CodeBlock(
              :final id,
              :final content,
              :final language,
              :final createdAt,
            ) =>
              {
                'type': 'code',
                'id': id,
                'content': content,
                'language': language,
                'createdAt': createdAt.toIso8601String(),
              },
            QuoteBlock(
              :final id,
              :final content,
              :final attribution,
              :final createdAt,
            ) =>
              {
                'type': 'quote',
                'id': id,
                'content': content,
                'attribution': attribution,
                'createdAt': createdAt.toIso8601String(),
              },
            SketchBlock(
              :final id,
              :final strokeFile,
              :final thumbnailFile,
              :final createdAt,
            ) =>
              {
                'type': 'sketch',
                'id': id,
                'strokeFile': strokeFile,
                'thumbnailFile': thumbnailFile,
                'createdAt': createdAt.toIso8601String(),
              },
            MathBlock(:final id, :final latex, :final createdAt) => {
              'type': 'math',
              'id': id,
              'latex': latex,
              'createdAt': createdAt.toIso8601String(),
            },
            AudioBlock(
              :final id,
              :final audioFile,
              :final durationMs,
              :final createdAt,
            ) =>
              {
                'type': 'audio',
                'id': id,
                'audioFile': audioFile,
                'durationMs': durationMs,
                'createdAt': createdAt.toIso8601String(),
              },
            WorkspaceRefBlock(
              :final id,
              :final sessionId,
              :final label,
              :final createdAt,
            ) =>
              {
                'type': 'workspace_ref',
                'id': id,
                'sessionId': sessionId,
                'label': label,
                'createdAt': createdAt.toIso8601String(),
              },
            ToolBlock(
              :final id,
              :final toolType,
              :final inputData,
              :final outputData,
              :final createdAt,
            ) =>
              {
                'type': 'tool',
                'id': id,
                'toolType': toolType,
                'inputData': inputData,
                'outputData': outputData,
                'createdAt': createdAt.toIso8601String(),
              },
          },
        )
        .toList();
  }
}

/// The one primary entity in Axiom.
/// Everything else (text, math, sketches, audio, PDFs, calculations, references)
/// must attach to or reference an IdeaNode.
@freezed
class IdeaNode with _$IdeaNode {
  const IdeaNode._();

  const factory IdeaNode({
    /// Unique identifier for this node
    required String id,

    /// Optional name/title for the node
    @Default('') String name,

    /// Timestamp when this node was created
    required DateTime createdAt,

    /// Timestamp when this node was last modified
    required DateTime updatedAt,

    /// Position on the canvas
    @Default(Position()) Position position,

    /// Ordered list of content blocks
    @ContentBlockListConverter() @Default([]) List<ContentBlock> blocks,

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
        _ when block.runtimeType.toString().contains('SketchBlock') =>
          '[Sketch]',
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
