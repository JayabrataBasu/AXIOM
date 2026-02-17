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
  final double? fontSize;
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
    this.fontSize,
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
    bool clearFontSize = false,
  }) {
    return TextFormat(
      start: start ?? this.start,
      end: end ?? this.end,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      strikethrough: strikethrough ?? this.strikethrough,
      fontSize: clearFontSize ? null : (fontSize ?? this.fontSize),
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
      'textColor': textColor?.toARGB32(),
      'backgroundColor': backgroundColor?.toARGB32(),
    };
  }

  factory TextFormat.fromJson(Map<String, dynamic> json) {
    final fontSize = (json['fontSize'] as num?)?.toDouble();

    return TextFormat(
      start: json['start'] as int,
      end: json['end'] as int,
      bold: json['bold'] as bool? ?? false,
      italic: json['italic'] as bool? ?? false,
      underline: json['underline'] as bool? ?? false,
      strikethrough: json['strikethrough'] as bool? ?? false,
      fontSize: fontSize,
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

  /// When non-null, the next typed characters will inherit this format.
  /// This enables Word-like behaviour: user sets bold (or font size, etc.)
  /// with a collapsed cursor, then starts typing — the new text gets
  /// that format applied automatically.
  TextFormat? pendingFormat;

  RichTextController({super.text, this.formats = const []}) {
    // Initialize _previousValue so the first keystroke is tracked
    _previousValue = value;
  }

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

  /// Merge adjacent or overlapping formats that have identical styling,
  /// and remove zero-length format spans.
  List<TextFormat> _mergeAdjacentFormats(List<TextFormat> formats) {
    if (formats.isEmpty) return formats;

    // Remove zero-length formats first
    final nonEmpty = formats.where((f) => f.end > f.start).toList();
    if (nonEmpty.isEmpty) return [];

    // Sort by start position first
    final sorted = List<TextFormat>.from(nonEmpty)
      ..sort((a, b) => a.start.compareTo(b.start));

    final merged = <TextFormat>[sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final last = merged.last;

      // Check if adjacent OR overlapping and have same styling
      if (last.end >= current.start && _hasSameProperties(last, current)) {
        // Merge by extending to the further end
        final newEnd = current.end > last.end ? current.end : last.end;
        merged[merged.length - 1] = last.copyWith(end: newEnd);
      } else {
        merged.add(current);
      }
    }

    return merged;
  }

  /// Check if two formats have identical styling properties (ignoring position).
  static bool _hasSameProperties(TextFormat a, TextFormat b) {
    return a.bold == b.bold &&
        a.italic == b.italic &&
        a.underline == b.underline &&
        a.strikethrough == b.strikethrough &&
        a.fontSize == b.fontSize &&
        a.fontFamily == b.fontFamily &&
        a.textColor == b.textColor &&
        a.backgroundColor == b.backgroundColor;
  }

  /// Clear all formatting from selection
  void clearFormat() {
    if (selection.start == selection.end) return;

    final start = selection.start;
    final end = selection.end;

    formats = formats.where((f) => f.end <= start || f.start >= end).toList();
    notifyListeners();
  }

  /// Get the merged format at cursor position (for toolbar state).
  /// Merges ALL overlapping formats so the toolbar reflects the true
  /// composite style (e.g. bold from one span + fontSize from another).
  TextFormat? getFormatAtCursor() {
    final pos = selection.baseOffset;
    final overlapping = <TextFormat>[];
    for (final format in formats) {
      if (pos >= format.start && pos < format.end) {
        overlapping.add(format);
      }
    }
    if (overlapping.isEmpty) return null;
    if (overlapping.length == 1) return overlapping.first;

    // Merge: OR logic for booleans, first-non-null for optionals
    return TextFormat(
      start: overlapping.map((f) => f.start).reduce((a, b) => a < b ? a : b),
      end: overlapping.map((f) => f.end).reduce((a, b) => a > b ? a : b),
      bold: overlapping.any((f) => f.bold),
      italic: overlapping.any((f) => f.italic),
      underline: overlapping.any((f) => f.underline),
      strikethrough: overlapping.any((f) => f.strikethrough),
      fontSize: overlapping
          .map((f) => f.fontSize)
          .whereType<double>()
          .firstOrNull,
      fontFamily: overlapping
          .map((f) => f.fontFamily)
          .whereType<String>()
          .firstOrNull,
      textColor: overlapping
          .map((f) => f.textColor)
          .whereType<Color>()
          .firstOrNull,
      backgroundColor: overlapping
          .map((f) => f.backgroundColor)
          .whereType<Color>()
          .firstOrNull,
    );
  }

  /// Notify listeners of changes (for use by undo/redo commands)
  void refreshUI() {
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final baseStyle = style ?? const TextStyle();

    // No formats → plain text
    if (formats.isEmpty || text.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    // Build children spans with formatting applied
    final children = <TextSpan>[];
    final sortedFormats = List<TextFormat>.from(formats)
      ..sort((a, b) => a.start.compareTo(b.start));

    int lastEnd = 0;

    for (final format in sortedFormats) {
      final fStart = format.start.clamp(0, text.length);
      final fEnd = format.end.clamp(0, text.length);
      if (fStart >= fEnd) continue;

      // Plain text before this format
      if (lastEnd < fStart) {
        children.add(
          TextSpan(text: text.substring(lastEnd, fStart), style: baseStyle),
        );
      }

      // Build decoration
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

      children.add(
        TextSpan(
          text: text.substring(fStart, fEnd),
          style: baseStyle.copyWith(
            fontWeight: format.bold ? FontWeight.bold : null,
            fontStyle: format.italic ? FontStyle.italic : null,
            decoration: decoration,
            fontSize: format.fontSize,
            fontFamily: format.fontFamily,
            color: format.textColor,
            backgroundColor: format.backgroundColor,
          ),
        ),
      );

      lastEnd = fEnd;
    }

    // Remaining plain text
    if (lastEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }

    return TextSpan(children: children, style: baseStyle);
  }

  /// Update format positions after text changes.
  /// [changeStart] and [changeEnd] define the range in the OLD text that
  /// was replaced.  [delta] is newLen - oldLen.
  void _updateFormatPositions(int changeStart, int changeEnd, int delta) {
    // Guard: clamp inputs to sane ranges to prevent garbage propagation
    final maxOld = (text.length - delta).clamp(0, 1 << 30);
    changeStart = changeStart.clamp(0, maxOld);
    changeEnd = changeEnd.clamp(changeStart, maxOld);

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

  /// When true, the value setter will NOT auto-update format positions.
  /// This prevents double-updates when paragraph_rich_text_field already
  /// called updateFormatsForChange() explicitly before setting value.
  bool _suppressAutoFormatUpdate = false;

  /// Public entry point for external callers (e.g. paragraph editor)
  /// that know exactly what changed and need format positions updated.
  /// Also suppresses the automatic format update in the value setter
  /// so that formats are only updated once.
  void updateFormatsForChange(int changeStart, int changeEnd, int delta) {
    _updateFormatPositions(changeStart, changeEnd, delta);
    _suppressAutoFormatUpdate = true;
  }

  @override
  set value(TextEditingValue newValue) {
    if (_suppressAutoFormatUpdate) {
      // Caller already updated format positions explicitly via
      // updateFormatsForChange() — skip automatic detection.
      _suppressAutoFormatUpdate = false;
    } else if (_previousValue != null &&
        newValue.text != _previousValue!.text) {
      final newText = newValue.text;
      final oldSelection = _previousValue!.selection;
      final newSelection = newValue.selection;

      // Calculate what changed
      final oldLen = _previousValue!.text.length;
      final newLen = newText.length;
      final delta = newLen - oldLen;

      if (delta != 0) {
        // Only run format adjustment when we have valid selection metadata
        // to compute the change position.  If newSelection is invalid
        // (e.g. caller set .text directly), skip — the caller is
        // responsible for updating format positions via
        // updateFormatsForChange().
        if (newSelection.isValid && newSelection.baseOffset >= 0) {
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
              changeStart = (newSelection.baseOffset - delta).clamp(0, oldLen);
              changeEnd = changeStart;
            } else {
              // Deletion
              changeStart = newSelection.baseOffset.clamp(0, newLen);
              changeEnd = (changeStart - delta).clamp(0, oldLen);
            }
          }

          _updateFormatPositions(changeStart, changeEnd, delta);
        }
        // else: caller bypassed selection → they must call
        // updateFormatsForChange() themselves.
      }
    }

    // ── Apply pending format for newly typed characters ──
    if (pendingFormat != null &&
        _previousValue != null &&
        newValue.text.length > _previousValue!.text.length) {
      final delta = newValue.text.length - _previousValue!.text.length;
      final insertEnd = newValue.selection.baseOffset;
      final insertStart = insertEnd - delta;
      if (insertStart >= 0) {
        formats.add(
          pendingFormat!.copyWith(start: insertStart, end: insertEnd),
        );
        formats = _mergeAdjacentFormats(formats);
      }
      // Keep pendingFormat active so consecutive keystrokes inherit it
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
    final rawFormats = (json['formats'] as List)
        .map((f) => TextFormat.fromJson(f as Map<String, dynamic>))
        .toList();

    // Clean up ghost format spans: drop spans with absolutely no
    // formatting properties set (all defaults, null fontSize, etc.).
    final cleanFormats = rawFormats.where((f) {
      return f.bold ||
          f.italic ||
          f.underline ||
          f.strikethrough ||
          f.fontSize != null ||
          f.fontFamily != null ||
          f.textColor != null ||
          f.backgroundColor != null;
    }).toList();

    final controller = RichTextController(
      text: json['text'] as String,
      formats: cleanFormats,
    );
    controller.textAlign = TextAlign.values[json['textAlign'] as int? ?? 0];
    return controller;
  }
}
