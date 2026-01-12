import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_block.freezed.dart';
part 'content_block.g.dart';

/// Sealed class representing different types of content blocks.
/// Currently only TextBlock is implemented (Stage 1).
/// Future stages will add: MathBlock, SketchBlock, AudioBlock, WorkspaceRefBlock, PDFRefBlock
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

  factory ContentBlock.fromJson(Map<String, dynamic> json) =>
      _$ContentBlockFromJson(json);
}
