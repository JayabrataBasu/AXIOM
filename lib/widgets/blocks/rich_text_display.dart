import 'package:flutter/material.dart';
import 'rich_text_editor.dart';

/// Custom painter that renders formatted text
class _RichTextPainter extends CustomPainter {
  final String text;
  final List<TextFormat> formats;
  final TextStyle baseStyle;
  final TextAlign textAlign;
  final double width;

  _RichTextPainter({
    required this.text,
    required this.formats,
    required this.baseStyle,
    required this.textAlign,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    // Build text painter with formatted spans
    final spans = _buildFormattedSpans();

    final textPainter = TextPainter(
      text: TextSpan(children: spans, style: baseStyle),
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: width);
    textPainter.paint(canvas, Offset.zero);
  }

  List<TextSpan> _buildFormattedSpans() {
    if (text.isEmpty || formats.isEmpty) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final spans = <TextSpan>[];
    final sortedFormats = List<TextFormat>.from(formats)
      ..sort((a, b) => a.start.compareTo(b.start));

    int lastEnd = 0;

    for (final format in sortedFormats) {
      // Add plain text before this format
      if (lastEnd < format.start && lastEnd < text.length) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, format.start.clamp(0, text.length)),
            style: baseStyle,
          ),
        );
      }

      // Add formatted text
      if (format.start < text.length && format.end > lastEnd) {
        final start = format.start.clamp(0, text.length);
        final end = format.end.clamp(0, text.length);
        if (start < end) {
          final formattedText = text.substring(start, end);
          spans.add(
            TextSpan(text: formattedText, style: _buildStyleFromFormat(format)),
          );
        }
      }

      lastEnd = format.end;
    }

    // Add remaining plain text
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }

    return spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans;
  }

  TextStyle _buildStyleFromFormat(TextFormat format) {
    TextDecoration? decoration;
    if (format.underline && format.strikethrough) {
      decoration = TextDecoration.combine([
        TextDecoration.underline,
        TextDecoration.lineThrough,
      ]);
    } else if (format.underline) {
      decoration = TextDecoration.underline;
    } else if (format.strikethrough) {
      decoration = TextDecoration.lineThrough;
    }

    return baseStyle.copyWith(
      fontWeight: format.bold ? FontWeight.bold : FontWeight.normal,
      fontStyle: format.italic ? FontStyle.italic : FontStyle.normal,
      decoration: decoration,
      decorationColor: format.textColor,
      fontSize: format.fontSize,
      fontFamily: format.fontFamily ?? baseStyle.fontFamily,
      color: format.textColor ?? baseStyle.color,
      backgroundColor: format.backgroundColor,
      height: baseStyle.height,
    );
  }

  @override
  bool shouldRepaint(_RichTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.formats.length != formats.length ||
        oldDelegate.width != width;
  }
}

/// Custom widget that renders rich text with actual formatting applied
/// Uses CustomPaint to layer formatted text over the invisible text field
class RichTextDisplay extends StatefulWidget {
  final RichTextController controller;
  final FocusNode focusNode;
  final TextStyle baseStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final int minLines;
  final ValueChanged<String>? onChanged;
  final ColorScheme colorScheme;

  const RichTextDisplay({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.baseStyle,
    required this.textAlign,
    required this.colorScheme,
    this.maxLines,
    this.minLines = 10,
    this.onChanged,
  });

  @override
  State<RichTextDisplay> createState() => _RichTextDisplayState();
}

class _RichTextDisplayState extends State<RichTextDisplay> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        return Stack(
          children: [
            // Formatted text display layer (using CustomPaint)
            CustomPaint(
              painter: _RichTextPainter(
                text: widget.controller.text,
                formats: widget.controller.formats,
                baseStyle: widget.baseStyle,
                textAlign: widget.textAlign,
                width: double.infinity,
              ),
              size: Size.infinite,
            ),
            // Invisible text field for input/selection/cursor
            TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              textAlign: widget.textAlign,
              // Make text transparent so we see the formatted layer below
              style: widget.baseStyle.copyWith(
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              cursorColor: widget.colorScheme.primary,
              onChanged: widget.onChanged,
              decoration: InputDecoration.collapsed(
                hintText: 'Start writing... Select text to apply formatting.',
                hintStyle: widget.baseStyle.copyWith(
                  color: widget.colorScheme.onSurfaceVariant.withAlpha(100),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
