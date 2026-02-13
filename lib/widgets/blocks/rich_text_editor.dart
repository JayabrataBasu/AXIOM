import 'dart:convert';
import 'package:flutter/material.dart';

/// A formatting span that describes text styling for a range of text
class TextFormat {
  final int start;
  final int end;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
  final double fontSize;
  final String? fontFamily;
  final Color? textColor;
  final Color? backgroundColor;

  TextFormat({
    required this.start,
    required this.end,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikethrough = false,
    this.fontSize = 16.0,
    this.fontFamily,
    this.textColor,
    this.backgroundColor,
  });

  TextFormat copyWith({
    int? start,
    int? end,
    bool? bold,
    bool? italic,
    bool? underline,
    bool? strikethrough,
    double? fontSize,
    String? fontFamily,
    Color? textColor,
    Color? backgroundColor,
    bool clearTextColor = false,
    bool clearBackgroundColor = false,
  }) {
    return TextFormat(
      start: start ?? this.start,
      end: end ?? this.end,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      strikethrough: strikethrough ?? this.strikethrough,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textColor: clearTextColor ? null : (textColor ?? this.textColor),
      backgroundColor: clearBackgroundColor
          ? null
          : (backgroundColor ?? this.backgroundColor),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'bold': bold,
      'italic': italic,
      'underline': underline,
      'strikethrough': strikethrough,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'textColor': textColor?.value,
      'backgroundColor': backgroundColor?.value,
    };
  }

  factory TextFormat.fromJson(Map<String, dynamic> json) {
    return TextFormat(
      start: json['start'] as int,
      end: json['end'] as int,
      bold: json['bold'] as bool? ?? false,
      italic: json['italic'] as bool? ?? false,
      underline: json['underline'] as bool? ?? false,
      strikethrough: json['strikethrough'] as bool? ?? false,
      fontSize: json['fontSize'] as double? ?? 16.0,
      fontFamily: json['fontFamily'] as String?,
      textColor: json['textColor'] != null
          ? Color(json['textColor'] as int)
          : null,
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
    );
  }
}

/// Controller for rich text editing
class RichTextController extends TextEditingController {
  List<TextFormat> formats = [];
  TextAlign textAlign = TextAlign.left;

  RichTextController({super.text, this.formats = const []});

  /// Apply formatting to the current selection
  void applyFormat(TextFormat newFormat) {
    if (selection.start == selection.end) return; // No selection

    final start = selection.start;
    final end = selection.end;

    // Remove overlapping formats and split as needed
    final updatedFormats = <TextFormat>[];

    for (final format in formats) {
      if (format.end <= start || format.start >= end) {
        // No overlap, keep as is
        updatedFormats.add(format);
      } else {
        // There's an overlap, need to split
        if (format.start < start) {
          // Keep the part before selection
          updatedFormats.add(format.copyWith(end: start));
        }
        if (format.end > end) {
          // Keep the part after selection
          updatedFormats.add(format.copyWith(start: end));
        }
      }
    }

    // Add the new format
    updatedFormats.add(newFormat);

    // Merge adjacent formats with identical styling
    formats = _mergeAdjacentFormats(updatedFormats);
    notifyListeners();
  }

  /// Merge adjacent formats that have identical styling
  List<TextFormat> _mergeAdjacentFormats(List<TextFormat> formats) {
    if (formats.isEmpty) return formats;

    // Sort by start position first
    final sorted = List<TextFormat>.from(formats)
      ..sort((a, b) => a.start.compareTo(b.start));

    final merged = <TextFormat>[sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final last = merged.last;

      // Check if adjacent and have same styling
      if (last.end == current.start &&
          last.bold == current.bold &&
          last.italic == current.italic &&
          last.underline == current.underline &&
          last.strikethrough == current.strikethrough &&
          last.fontSize == current.fontSize &&
          last.fontFamily == current.fontFamily &&
          last.textColor == current.textColor &&
          last.backgroundColor == current.backgroundColor) {
        // Merge by extending the last format
        merged[merged.length - 1] = last.copyWith(end: current.end);
      } else {
        merged.add(current);
      }
    }

    return merged;
  }

  /// Clear all formatting from selection
  void clearFormat() {
    if (selection.start == selection.end) return;

    final start = selection.start;
    final end = selection.end;

    formats = formats.where((f) => f.end <= start || f.start >= end).toList();
    notifyListeners();
  }

  /// Get the format at cursor position (for toolbar state)
  TextFormat? getFormatAtCursor() {
    final pos = selection.baseOffset;
    for (final format in formats) {
      if (pos >= format.start && pos < format.end) {
        return format;
      }
    }
    return null;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (formats.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <TextSpan>[];
    final sortedFormats = List<TextFormat>.from(formats)
      ..sort((a, b) => a.start.compareTo(b.start));

    int currentPos = 0;

    for (final format in sortedFormats) {
      // Add unformatted text before this format
      if (currentPos < format.start) {
        spans.add(
          TextSpan(
            text: text.substring(currentPos, format.start),
            style: style,
          ),
        );
      }

      // Add formatted text
      final formattedText = text.substring(
        format.start,
        format.end.clamp(0, text.length),
      );

      final decorations = <TextDecoration>[];
      if (format.underline) decorations.add(TextDecoration.underline);
      if (format.strikethrough) decorations.add(TextDecoration.lineThrough);

      spans.add(
        TextSpan(
          text: formattedText,
          style: style?.copyWith(
            fontWeight: format.bold ? FontWeight.bold : null,
            fontStyle: format.italic ? FontStyle.italic : null,
            decoration: decorations.isNotEmpty
                ? TextDecoration.combine(decorations)
                : null,
            fontSize: format.fontSize,
            fontFamily: format.fontFamily,
            color: format.textColor,
            backgroundColor: format.backgroundColor,
          ),
        ),
      );

      currentPos = format.end;
    }

    // Add any remaining unformatted text
    if (currentPos < text.length) {
      spans.add(TextSpan(text: text.substring(currentPos), style: style));
    }

    return TextSpan(children: spans, style: style);
  }

  /// Update format positions after text changes
  void _updateFormatPositions(int changeStart, int changeEnd, int delta) {
    final updatedFormats = <TextFormat>[];

    for (final format in formats) {
      // Format entirely before change - no adjustment needed
      if (format.end <= changeStart) {
        updatedFormats.add(format);
        continue;
      }

      // Format entirely after change - shift by delta
      if (format.start >= changeEnd) {
        updatedFormats.add(
          format.copyWith(start: format.start + delta, end: format.end + delta),
        );
        continue;
      }

      // Format overlaps with change - complex adjustment
      int newStart = format.start;
      int newEnd = format.end;

      // Adjust start if affected by deletion
      if (format.start >= changeStart && format.start < changeEnd) {
        // Format starts within deleted range
        newStart = changeStart;
      } else if (format.start >= changeEnd) {
        // Format starts after deleted range
        newStart = format.start + delta;
      }

      // Adjust end
      if (format.end <= changeStart) {
        // Format ends before change
        newEnd = format.end;
      } else if (format.end <= changeEnd) {
        // Format ends within deleted range
        newEnd = changeStart;
      } else {
        // Format extends beyond change
        newEnd = format.end + delta;
      }

      // Only keep format if it has positive length
      if (newEnd > newStart) {
        updatedFormats.add(format.copyWith(start: newStart, end: newEnd));
      }
    }

    formats = updatedFormats;
  }

  TextEditingValue? _previousValue;

  @override
  set value(TextEditingValue newValue) {
    if (_previousValue != null && newValue.text != _previousValue!.text) {
      final oldText = _previousValue!.text;
      final newText = newValue.text;
      final oldSelection = _previousValue!.selection;
      final newSelection = newValue.selection;

      // Calculate what changed
      final oldLen = oldText.length;
      final newLen = newText.length;
      final delta = newLen - oldLen;

      if (delta != 0) {
        int changeStart;
        int changeEnd;

        if (oldSelection.isValid && oldSelection.start != oldSelection.end) {
          // Had a selection - it was replaced
          changeStart = oldSelection.start;
          changeEnd = oldSelection.end;
        } else {
          // Point insertion/deletion
          if (delta > 0) {
            // Insertion
            changeStart = newSelection.baseOffset - delta;
            changeEnd = changeStart;
          } else {
            // Deletion
            changeStart = newSelection.baseOffset;
            changeEnd = changeStart - delta;
          }
        }

        _updateFormatPositions(changeStart, changeEnd, delta);
      }
    }

    _previousValue = newValue;
    super.value = newValue;
  }

  /// Serialize to JSON for storage
  String toJson() {
    return jsonEncode({
      'text': text,
      'formats': formats.map((f) => f.toJson()).toList(),
      'textAlign': textAlign.index,
    });
  }

  /// Deserialize from JSON
  static RichTextController fromJson(String jsonStr) {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final controller = RichTextController(
      text: json['text'] as String,
      formats: (json['formats'] as List)
          .map((f) => TextFormat.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
    controller.textAlign = TextAlign.values[json['textAlign'] as int? ?? 0];
    return controller;
  }
}
