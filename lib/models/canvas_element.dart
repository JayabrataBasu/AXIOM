import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_block.dart';
import 'position.dart';

part 'canvas_element.freezed.dart';
part 'canvas_element.g.dart';

/// JSON converter for ContentBlock
class ContentBlockConverter
    implements JsonConverter<ContentBlock, Map<String, dynamic>> {
  const ContentBlockConverter();

  @override
  ContentBlock fromJson(Map<String, dynamic> json) {
    return ContentBlock.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ContentBlock block) {
    return switch (block) {
      TextBlock(:final id, :final content, :final createdAt) => {
        'type': 'text',
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      },
      HeadingBlock(:final id, :final content, :final level, :final createdAt) =>
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
      CodeBlock(:final id, :final content, :final language, :final createdAt) =>
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
    };
  }
}

/// JSON converter for `List<ContentBlock>`
class ContentBlockListConverter2
    implements JsonConverter<List<ContentBlock>, List<dynamic>> {
  const ContentBlockListConverter2();

  @override
  List<ContentBlock> fromJson(List<dynamic> json) {
    return json
        .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<dynamic> toJson(List<ContentBlock> blocks) {
    return blocks.map((b) => const ContentBlockConverter().toJson(b)).toList();
  }
}

/// A canvas element can be either a standalone block or a container (node)
/// This allows placing blocks directly on canvas or grouping them in nodes
@freezed
class CanvasElement with _$CanvasElement {
  const CanvasElement._();

  /// A standalone block placed directly on the canvas
  const factory CanvasElement.standaloneBlock({
    required String id,
    required Position position,
    @ContentBlockConverter() required ContentBlock block,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<ElementLink> links,
  }) = StandaloneBlock;

  /// A container node (the original IdeaNode concept)
  const factory CanvasElement.container({
    required String id,
    required Position position,
    @Default('') String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @ContentBlockListConverter2() @Default([]) List<ContentBlock> blocks,
    @Default([]) List<ElementLink> links,
  }) = ContainerNode;

  factory CanvasElement.fromJson(Map<String, dynamic> json) =>
      _$CanvasElementFromJson(json);

  /// Get preview text for display on canvas
  String get previewText {
    return when(
      standaloneBlock: (_, __, block, ___, ____, _____) {
        return switch (block) {
          TextBlock(:final content) when content.isNotEmpty => content,
          HeadingBlock(:final content) when content.isNotEmpty => content,
          CodeBlock(:final content) when content.isNotEmpty => content,
          QuoteBlock(:final content) when content.isNotEmpty => '"$content"',
          MathBlock(:final latex) when latex.isNotEmpty => latex,
          _ => '[Block]',
        };
      },
      container: (_, __, name, ___, ____, blocks, ______) {
        if (name.isNotEmpty) return name;
        for (final block in blocks) {
          final text = switch (block) {
            TextBlock(:final content) when content.isNotEmpty => content,
            HeadingBlock(:final content) when content.isNotEmpty => content,
            _ => null,
          };
          if (text != null) {
            return text.length > 100 ? '${text.substring(0, 100)}...' : text;
          }
        }
        return '[Container]';
      },
    );
  }
}

/// A link between canvas elements (nodes or standalone blocks)
@freezed
class ElementLink with _$ElementLink {
  const factory ElementLink({
    required String targetElementId,
    @Default('') String label,
    @Default(LinkType.reference) LinkType type,
    required DateTime createdAt,
  }) = _ElementLink;

  factory ElementLink.fromJson(Map<String, dynamic> json) =>
      _$ElementLinkFromJson(json);
}

/// Types of links between elements
enum LinkType {
  /// A generic reference
  reference,

  /// A dependency (target depends on this)
  dependency,

  /// A derivation (target is derived from this)
  derivation,

  /// A bidirectional association
  association,
}
