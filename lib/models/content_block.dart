import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_block.freezed.dart';

/// Sealed class representing different types of content blocks.
/// Stage 3 adds multiple block types for rich content editing.
@Freezed(unionKey: 'type')
sealed class ContentBlock with _$ContentBlock {
  const ContentBlock._();

  /// A text content block for plain text notes.
  @FreezedUnionValue('text')
  const factory ContentBlock.text({
    required String id,
    @Default('') String content,
    required DateTime createdAt,
  }) = TextBlock;

  /// A heading block for section titles.
  /// Level 1-3 supported (1 = largest).
  @FreezedUnionValue('heading')
  const factory ContentBlock.heading({
    required String id,
    @Default('') String content,
    @Default(1) int level,
    required DateTime createdAt,
  }) = HeadingBlock;

  /// A bullet list block for unordered lists.
  /// Each item is a separate line in the content.
  @FreezedUnionValue('bulletList')
  const factory ContentBlock.bulletList({
    required String id,
    @Default([]) List<String> items,
    required DateTime createdAt,
  }) = BulletListBlock;

  /// A code block for code snippets with optional language.
  @FreezedUnionValue('code')
  const factory ContentBlock.code({
    required String id,
    @Default('') String content,
    @Default('') String language,
    required DateTime createdAt,
  }) = CodeBlock;

  /// A quote block for citations and callouts.
  @FreezedUnionValue('quote')
  const factory ContentBlock.quote({
    required String id,
    @Default('') String content,
    @Default('') String attribution,
    required DateTime createdAt,
  }) = QuoteBlock;

  /// A sketch block for freehand drawings.
  @FreezedUnionValue('sketch')
  const factory ContentBlock.sketch({
    required String id,
    required String strokeFile,
    @Default('') String thumbnailFile,
    required DateTime createdAt,
  }) = SketchBlock;

  /// A math block for LaTeX mathematical expressions (Stage 4).
  @FreezedUnionValue('math')
  const factory ContentBlock.math({
    required String id,
    @Default('') String latex,
    required DateTime createdAt,
  }) = MathBlock;

  /// An audio block for voice recordings (Stage 6).
  @FreezedUnionValue('audio')
  const factory ContentBlock.audio({
    required String id,
    required String audioFile,
    @Default(0) int durationMs,
    required DateTime createdAt,
  }) = AudioBlock;

  /// A workspace reference block linking to a session (Stage 7).
  @FreezedUnionValue('workspace_ref')
  const factory ContentBlock.workspaceRef({
    required String id,
    required String sessionId,
    @Default('') String label,
    required DateTime createdAt,
  }) = WorkspaceRefBlock;

  /// A tool block for embedded calculations/utilities (Stage 7+).
  @FreezedUnionValue('tool')
  const factory ContentBlock.tool({
    required String id,
    required String toolType, // 'matrix_calculator', 'pdf_viewer', etc.
    required Map<String, dynamic> inputData, // Tool-specific inputs
    required Map<String, dynamic>
    outputData, // Tool-specific outputs (read-only)
    required DateTime createdAt,
  }) = ToolBlock;

  /// A mind map reference block linking to a mind map.
  @FreezedUnionValue('mind_map_ref')
  const factory ContentBlock.mindMapRef({
    required String id,
    required String mapId,
    @Default('') String label,
    required DateTime createdAt,
  }) = MindMapRefBlock;

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    // Migration: Handle legacy blocks without explicit 'type' field
    if (type == null) {
      return ContentBlock.text(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    }

    return switch (type) {
      'text' => ContentBlock.text(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'heading' => ContentBlock.heading(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        level: (json['level'] as int?) ?? 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'bulletList' => ContentBlock.bulletList(
        id: json['id'] as String,
        items: List<String>.from((json['items'] as List<dynamic>?) ?? []),
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'code' => ContentBlock.code(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        language: (json['language'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'quote' => ContentBlock.quote(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        attribution: (json['attribution'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'sketch' => ContentBlock.sketch(
        id: json['id'] as String,
        strokeFile: json['strokeFile'] as String,
        thumbnailFile: (json['thumbnailFile'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'math' => ContentBlock.math(
        id: json['id'] as String,
        latex: (json['latex'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'audio' => ContentBlock.audio(
        id: json['id'] as String,
        audioFile: json['audioFile'] as String,
        durationMs: (json['durationMs'] as int?) ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'workspace_ref' => ContentBlock.workspaceRef(
        id: json['id'] as String,
        sessionId: json['sessionId'] as String,
        label: (json['label'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      'mind_map_ref' => ContentBlock.mindMapRef(
        id: json['id'] as String,
        mapId: json['mapId'] as String,
        label: (json['label'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      ),
      _ => ContentBlock.text(
        id: json['id'] as String,
        content: '',
        createdAt: DateTime.now(),
      ),
    };
  }
}
