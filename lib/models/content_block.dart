import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_block.freezed.dart';
part 'content_block.g.dart';

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

  factory ContentBlock.fromJson(Map<String, dynamic> json) =>
      _$ContentBlockFromJson(json);
}
