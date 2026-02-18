import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rich_text_editor.dart';

// ════════════════════════════════════════════════════════════════════
// PARAGRAPH-BASED RICH TEXT FIELD
//
// This will render a rich text document as a series of per-paragraph TextFields.
// Each paragraph (\n-delimited) gets its own StrutStyle computed from
// the maximum font size present in that paragraph, giving Word-like
// line-height expansion and proper baseline alignment.
//
// The controller (RichTextController) remains the single source of
// truth for the flat text + format-span model.  This widget projects
// that model into per-paragraph editing surfaces and synchronises
// edits back to the controller.
// ════════════════════════════════════════════════════════════════════

/// A rich text editing surface that renders each paragraph separately
/// to achieve Word-like baseline alignment with mixed font sizes. It is
/// mandated that the controller's text is split into paragraphs by \n characters, and
/// and that format spans in the controller are defined with respect to the flat text. The widget
/// handles the projection of the flat text + format model into per-paragraph TextFields, and synchronises edits back to the controller.
class ParagraphRichTextField extends StatefulWidget {
  const ParagraphRichTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.baseStyle,
    required this.hintStyle,
    required this.hintText,
    required this.onChanged,
    this.textAlign = TextAlign.left,
    this.minLines = 10,
  });

  final RichTextController controller;
  final FocusNode focusNode;
  final TextStyle baseStyle;
  final TextStyle hintStyle;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextAlign textAlign;
  final int minLines;

  @override
  State<ParagraphRichTextField> createState() => _ParagraphRichTextFieldState();
}

class _ParagraphRichTextFieldState extends State<ParagraphRichTextField> {
  // Per-paragraph controllers & focus nodes
  final List<_ParagraphController> _paraControllers = [];
  final List<FocusNode> _paraFocusNodes = [];

  // Track which paragraph is currently focused
  int _activeParagraphIndex = 0;

  /// The index of the currently focused paragraph.
  int get activeParagraphIndex => _activeParagraphIndex;

  // Suppress sync loops
  bool _isSyncing = false;

  // Base font size from the style
  double get _baseFontSize => widget.baseStyle.fontSize ?? 14.0;

  @override
  void initState() {
    super.initState();
    _rebuildParagraphs();
    widget.controller.addListener(_onDocumentChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onDocumentChanged);
    _disposeParagraphs();
    super.dispose();
  }

  @override
  void didUpdateWidget(ParagraphRichTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onDocumentChanged);
      widget.controller.addListener(_onDocumentChanged);
      _rebuildParagraphs();
    }
  }

  // ── Document → paragraphs sync ──────────────────────────────────

  void _onDocumentChanged() {
    if (_isSyncing) return;
    // The document model changed externally (undo/redo, programmatic).
    // Re-split into paragraphs.
    _rebuildParagraphs();
  }

  /// Split the flat document text by \n and create a controller per paragraph.
  void _rebuildParagraphs() {
    final text = widget.controller.text;
    final paragraphs = text.split('\n');

    // Dispose excess controllers
    while (_paraControllers.length > paragraphs.length) {
      _paraControllers.removeLast().dispose();
      _paraFocusNodes.removeLast().dispose();
    }

    // Create or update controllers
    int offset = 0;
    for (int i = 0; i < paragraphs.length; i++) {
      final paraText = paragraphs[i];
      final paraStart = offset;
      final paraEnd = offset + paraText.length;

      // Slice format spans for this paragraph, so that it does not awkwardly overlap
      final localFormats = _sliceFormats(
        widget.controller.formats,
        paraStart,
        paraEnd,
      );

      // Compute max font size in this paragraph for StrutStyle
      final maxFontSize = _maxFontSizeInFormats(localFormats, _baseFontSize);

      if (i < _paraControllers.length) {
        // Update existing
        _paraControllers[i].update(
          paraText,
          localFormats,
          paraStart,
          maxFontSize,
        );
      } else {
        // Create new
        final ctrl = _ParagraphController(
          paraText: paraText,
          localFormats: localFormats,
          paragraphOffset: paraStart,
          maxFontSize: maxFontSize,
          baseFontSize: _baseFontSize,
        );
        _paraControllers.add(ctrl);

        // Listen to selection changes and sync to document
        ctrl.addListener(() {
          _updateDocumentSelection(i);
        });

        final fn = FocusNode();
        fn.addListener(() {
          if (fn.hasFocus) {
            final idx = _paraFocusNodes.indexOf(fn);
            if (idx >= 0) _activeParagraphIndex = idx;
          }
        });
        _paraFocusNodes.add(fn);
      }

      offset = paraEnd + 1; // +1 for the \n
    }

    if (mounted) setState(() {});
  }

  /// Extract format spans that overlap [paraStart, paraEnd),
  /// translated to local (0-based) coordinates.
  List<TextFormat> _sliceFormats(
    List<TextFormat> formats,
    int paraStart,
    int paraEnd,
  ) {
    final result = <TextFormat>[];
    for (final f in formats) {
      if (f.end <= paraStart || f.start >= paraEnd) continue;
      result.add(
        f.copyWith(
          start: (f.start - paraStart).clamp(0, paraEnd - paraStart),
          end: (f.end - paraStart).clamp(0, paraEnd - paraStart),
        ),
      );
    }
    return result;
  }

  double _maxFontSizeInFormats(List<TextFormat> formats, double base) {
    double m = base;
    for (final f in formats) {
      if (f.fontSize != null && f.fontSize! > m) m = f.fontSize!;
    }
    return m;
  }

  // ── Paragraphs → document sync ──────────────────────────────────

  /// Reconstruct flat text from paragraph controllers and push to
  /// document controller.  We set controller.value (not .text) so
  /// that the value setter in RichTextController receives a valid
  /// selection and can compute correct changeStart/changeEnd for
  /// _updateFormatPositions.  This prevents format bleed.
  void _syncToDocument() {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final buffer = StringBuffer();
      for (int i = 0; i < _paraControllers.length; i++) {
        if (i > 0) buffer.write('\n');
        buffer.write(_paraControllers[i].text);
      }
      final newText = buffer.toString();

      // Compute the global cursor position from the active paragraph
      final activeIdx = _activeParagraphIndex.clamp(
        0,
        _paraControllers.length - 1,
      );
      final activeCtrl = _paraControllers[activeIdx];
      final localSel = activeCtrl.selection;

      int globalBase;
      int globalExtent;
      if (localSel.isValid) {
        globalBase =
            (activeCtrl.paragraphOffset +
                    localSel.baseOffset.clamp(0, activeCtrl.text.length))
                .clamp(0, newText.length);
        globalExtent =
            (activeCtrl.paragraphOffset +
                    localSel.extentOffset.clamp(0, activeCtrl.text.length))
                .clamp(0, newText.length);
      } else {
        globalBase = newText.length;
        globalExtent = newText.length;
      }

      // Compute change and explicitly update format positions before
      // setting the value. This is more reliable than the auto-detection
      // in the value setter, which depends on _previousValue ordering.
      final oldText = widget.controller.text;
      final oldLen = oldText.length;
      final newLen = newText.length;
      final delta = newLen - oldLen;

      widget.controller.removeListener(_onDocumentChanged);

      if (delta != 0) {
        // Determine change position from the global cursor.
        int changeStart;
        int changeEnd;
        if (delta > 0) {
          // Insertion: new chars end at globalBase
          changeStart = (globalBase - delta).clamp(0, oldLen);
          changeEnd = changeStart;
        } else {
          // Deletion: chars removed before globalBase
          changeStart = globalBase.clamp(0, newLen);
          changeEnd = (changeStart - delta).clamp(0, oldLen);
        }
        widget.controller.updateFormatsForChange(changeStart, changeEnd, delta);
      }

      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: globalBase,
          extentOffset: globalExtent,
        ),
      );
      widget.controller.addListener(_onDocumentChanged);

      // Only rebuild if text structure changed (paragraph count).
      // Selection updates are handled by _updateDocumentSelection,
      // not by syncing back to the document.
      final newParaCount = newText.split('\n').length;
      if (newParaCount != _paraControllers.length) {
        _rebuildParagraphs();
      } else {
        // Paragraph count unchanged — still refresh localFormats to pick
        // up any format spans added by the value setter (e.g. pendingFormat).
        _refreshLocalFormats();
      }

      widget.onChanged(newText);
    } finally {
      _isSyncing = false;
    }
  }

  /// Lightweight refresh: re-slice document-level formats into each
  /// paragraph controller's localFormats and update maxFontSize.
  /// This does NOT dispose or re-create paragraph controllers —
  /// it only updates the format data they render with.
  void _refreshLocalFormats() {
    final text = widget.controller.text;
    final paragraphs = text.split('\n');
    int offset = 0;
    for (int i = 0; i < _paraControllers.length && i < paragraphs.length; i++) {
      final paraText = paragraphs[i];
      final paraStart = offset;
      final paraEnd = offset + paraText.length;

      final localFormats = _sliceFormats(
        widget.controller.formats,
        paraStart,
        paraEnd,
      );
      final maxFontSize = _maxFontSizeInFormats(localFormats, _baseFontSize);

      _paraControllers[i].update(
        paraText,
        localFormats,
        paraStart,
        maxFontSize,
      );

      offset = paraEnd + 1; // +1 for \n
    }
  }

  void _disposeParagraphs() {
    for (final c in _paraControllers) {
      c.dispose();
    }
    for (final f in _paraFocusNodes) {
      f.dispose();
    }
    _paraControllers.clear();
    _paraFocusNodes.clear();
  }

  // ── Keyboard navigation across paragraphs ───────────────────────

  /// Handle Enter: split current paragraph at cursor, creating a new one.
  void _handleEnter(int paragraphIndex) {
    final ctrl = _paraControllers[paragraphIndex];
    final cursorPos = ctrl.selection.baseOffset.clamp(0, ctrl.text.length);

    // Insert \n into the document at the global offset
    final globalOffset = ctrl.paragraphOffset + cursorPos;

    // Propagate formatting to the new line: capture the format at the
    // cursor (or the active pendingFormat) so the new empty paragraph
    // inherits the current style (Word-like Enter behaviour).
    widget.controller.pendingFormat ??= widget.controller.getFormatAtCursor();

    widget.controller.removeListener(_onDocumentChanged);

    // Build new text
    final oldText = widget.controller.text;
    final newText =
        '${oldText.substring(0, globalOffset)}\n${oldText.substring(globalOffset)}';

    // Explicitly update format positions: inserting 1 char at globalOffset
    widget.controller.updateFormatsForChange(globalOffset, globalOffset, 1);

    // Set value with proper selection (cursor at start of new paragraph)
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: globalOffset + 1),
    );

    widget.controller.addListener(_onDocumentChanged);

    // Rebuild paragraphs
    _rebuildParagraphs();

    // Move focus to the start of the new paragraph
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (paragraphIndex + 1 < _paraFocusNodes.length) {
        _paraFocusNodes[paragraphIndex + 1].requestFocus();
        _paraControllers[paragraphIndex + 1].selection =
            const TextSelection.collapsed(offset: 0);
      }
    });

    widget.onChanged(widget.controller.text);
  }

  /// Handle Backspace at position 0: merge with previous paragraph.
  void _handleBackspaceAtStart(int paragraphIndex) {
    if (paragraphIndex <= 0) return;

    final prevCtrl = _paraControllers[paragraphIndex - 1];
    final cursorInPrev = prevCtrl.text.length;

    // Remove the \n between prev and current paragraph
    final globalOffset = prevCtrl.paragraphOffset + prevCtrl.text.length;

    widget.controller.removeListener(_onDocumentChanged);

    final oldText = widget.controller.text;
    final newText =
        oldText.substring(0, globalOffset) +
        oldText.substring(globalOffset + 1);

    // Explicitly update format positions: deleting 1 char (\n) at globalOffset
    widget.controller.updateFormatsForChange(
      globalOffset,
      globalOffset + 1,
      -1,
    );

    // Set value with proper selection (cursor at merge point)
    final globalCursor = (prevCtrl.paragraphOffset + cursorInPrev).clamp(
      0,
      newText.length,
    );
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: globalCursor),
    );

    widget.controller.addListener(_onDocumentChanged);

    _rebuildParagraphs();

    // Focus previous paragraph at the merge point
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (paragraphIndex - 1 < _paraFocusNodes.length) {
        _paraFocusNodes[paragraphIndex - 1].requestFocus();
        _paraControllers[paragraphIndex - 1].selection =
            TextSelection.collapsed(offset: cursorInPrev);
      }
    });

    widget.onChanged(widget.controller.text);
  }

  /// Handle Delete at end: merge with next paragraph.
  void _handleDeleteAtEnd(int paragraphIndex) {
    if (paragraphIndex >= _paraControllers.length - 1) return;

    final curCtrl = _paraControllers[paragraphIndex];
    final cursorPos = curCtrl.text.length;

    // Remove the \n between current and next paragraph
    final globalOffset = curCtrl.paragraphOffset + curCtrl.text.length;

    widget.controller.removeListener(_onDocumentChanged);

    final oldText = widget.controller.text;
    final newText =
        oldText.substring(0, globalOffset) +
        oldText.substring(globalOffset + 1);

    // Explicitly update format positions: deleting 1 char (\n) at globalOffset
    widget.controller.updateFormatsForChange(
      globalOffset,
      globalOffset + 1,
      -1,
    );

    // Set value with proper selection
    final globalCursor = (curCtrl.paragraphOffset + cursorPos).clamp(
      0,
      newText.length,
    );
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: globalCursor),
    );

    widget.controller.addListener(_onDocumentChanged);

    _rebuildParagraphs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (paragraphIndex < _paraFocusNodes.length) {
        _paraFocusNodes[paragraphIndex].requestFocus();
        _paraControllers[paragraphIndex].selection = TextSelection.collapsed(
          offset: cursorPos,
        );
      }
    });

    widget.onChanged(widget.controller.text);
  }

  /// Move cursor up from first line of a paragraph → focus previous paragraph. so that gang respects gang
  void _moveToPreviousParagraph(int paragraphIndex, int horizontalOffset) {
    if (paragraphIndex <= 0) return;
    final prev = _paraControllers[paragraphIndex - 1];
    final offset = horizontalOffset.clamp(0, prev.text.length);
    _paraFocusNodes[paragraphIndex - 1].requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prev.selection = TextSelection.collapsed(offset: offset);
    });
  }

  /// Move cursor down from last line of a paragraph → focus next paragraph.
  void _moveToNextParagraph(int paragraphIndex, int horizontalOffset) {
    if (paragraphIndex >= _paraControllers.length - 1) return;
    final next = _paraControllers[paragraphIndex + 1];
    final offset = horizontalOffset.clamp(0, next.text.length);
    _paraFocusNodes[paragraphIndex + 1].requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      next.selection = TextSelection.collapsed(offset: offset);
    });
  }

  // ── Sync the document-level selection for toolbar state ─────────

  void _updateDocumentSelection(int paragraphIndex) {
    if (paragraphIndex >= _paraControllers.length) return;
    final ctrl = _paraControllers[paragraphIndex];
    final sel = ctrl.selection;
    if (!sel.isValid) return;

    final globalBase =
        ctrl.paragraphOffset + sel.baseOffset.clamp(0, ctrl.text.length);
    final globalExtent =
        ctrl.paragraphOffset + sel.extentOffset.clamp(0, ctrl.text.length);

    widget.controller.removeListener(_onDocumentChanged);
    widget.controller.selection = TextSelection(
      baseOffset: globalBase.clamp(0, widget.controller.text.length),
      extentOffset: globalExtent.clamp(0, widget.controller.text.length),
    );
    widget.controller.addListener(_onDocumentChanged);
  }

  // ── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_paraControllers.isEmpty) {
      return TextField(
        controller: TextEditingController(),
        focusNode: widget.focusNode,
        maxLines: null,
        minLines: widget.minLines,
        style: widget.baseStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          filled: false,
          border: InputBorder.none,
        ),
      );
    }

    return GestureDetector(
      // Tap on empty space below paragraphs → focus last paragraph
      onTap: () {
        if (_paraFocusNodes.isNotEmpty) {
          final lastIdx = _paraFocusNodes.length - 1;
          _paraFocusNodes[lastIdx].requestFocus();
          final lastCtrl = _paraControllers[lastIdx];
          lastCtrl.selection = TextSelection.collapsed(
            offset: lastCtrl.text.length,
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minLines * (widget.baseStyle.fontSize ?? 14) * 1.8,
        ),
        child: Column(
          crossAxisAlignment: _alignmentToCross(widget.textAlign),
          children: [
            for (int i = 0; i < _paraControllers.length; i++)
              _buildParagraphField(i, cs),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraphField(int index, ColorScheme cs) {
    final ctrl = _paraControllers[index];
    final maxFs = ctrl.maxFontSize;

    // StrutStyle scaled to the largest font in THIS paragraph alone and alone only
    // This forces the line height to accommodate the tallest glyph
    final strutStyle = StrutStyle(
      fontSize: maxFs,
      height: 1.6,
      forceStrutHeight: false,
      leading: 0.2,
    );

    return KeyboardListener(
      focusNode: FocusNode(skipTraversal: true), // wrapper focus for key events
      onKeyEvent: (event) => _handleKeyEvent(event, index),
      child: TextField(
        controller: ctrl,
        focusNode: _paraFocusNodes[index],
        maxLines: null,
        minLines: 1,
        textAlign: widget.textAlign,
        strutStyle: strutStyle,
        style: widget.baseStyle.copyWith(
          // Ensure height is consistent for baseline alignment
          height: maxFs > _baseFontSize ? (maxFs / _baseFontSize) * 1.2 : 1.8,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        decoration: InputDecoration(
          hintText:
              index == 0 && _paraControllers.length == 1 && ctrl.text.isEmpty
              ? widget.hintText
              : null,
          hintStyle: widget.hintStyle,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        onChanged: (text) {
          _syncToDocument();
          _updateDocumentSelection(index);
        },
        onTap: () {
          _activeParagraphIndex = index;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateDocumentSelection(index);
          });
        },
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event, int paragraphIndex) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    final ctrl = _paraControllers[paragraphIndex];
    final sel = ctrl.selection;
    if (!sel.isValid) return;

    final cursorPos = sel.baseOffset;
    final isCollapsed = sel.isCollapsed;

    // Enter key — split paragraph
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      // Let the default TextField handle it — it will insert \n.
      // We intercept in onChanged and rebuild paragraphs.
      // Actually, we need to handle this ourselves since each paragraph
      // is its own TextField.
      _handleEnter(paragraphIndex);
      return;
    }

    // Backspace at position 0 — merge with previous paragraph
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        isCollapsed &&
        cursorPos == 0) {
      _handleBackspaceAtStart(paragraphIndex);
      return;
    }

    // Delete at end — merge with next paragraph
    if (event.logicalKey == LogicalKeyboardKey.delete &&
        isCollapsed &&
        cursorPos == ctrl.text.length) {
      _handleDeleteAtEnd(paragraphIndex);
      return;
    }

    // Arrow Up at first line → move to previous paragraph
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      // Heuristic: if cursor is on the first line (offset < ~80 chars or
      // we can compute using TextPainter), move to prev paragraph
      // For simplicity, check if cursor is in the first visual line
      _handleArrowUp(paragraphIndex, cursorPos);
      return;
    }

    // Arrow Down at last line → move to next paragraph
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _handleArrowDown(paragraphIndex, cursorPos);
      return;
    }
  }

  void _handleArrowUp(int paragraphIndex, int cursorPos) {
    if (paragraphIndex <= 0) return;
    // Use a TextPainter to check if cursor is on the first visual line
    final ctrl = _paraControllers[paragraphIndex];
    final painter = TextPainter(
      text: ctrl.buildTextSpan(
        context: context,
        style: widget.baseStyle,
        withComposing: false,
      ),
      textDirection: TextDirection.ltr,
      textAlign: widget.textAlign,
    );
    // Use a reasonable max width
    painter.layout(maxWidth: MediaQuery.of(context).size.width - 100);
    final caretOffset = painter.getOffsetForCaret(
      TextPosition(offset: cursorPos),
      Rect.zero,
    );
    // If the caret is near the top (within first line height), move up
    final firstLineMetrics = painter.computeLineMetrics();
    if (firstLineMetrics.isNotEmpty) {
      final firstLineBottom = firstLineMetrics.first.height;
      if (caretOffset.dy < firstLineBottom) {
        _moveToPreviousParagraph(paragraphIndex, cursorPos);
      }
    }
    painter.dispose();
  }

  void _handleArrowDown(int paragraphIndex, int cursorPos) {
    if (paragraphIndex >= _paraControllers.length - 1) return;
    final ctrl = _paraControllers[paragraphIndex];
    final painter = TextPainter(
      text: ctrl.buildTextSpan(
        context: context,
        style: widget.baseStyle,
        withComposing: false,
      ),
      textDirection: TextDirection.ltr,
      textAlign: widget.textAlign,
    );
    painter.layout(maxWidth: MediaQuery.of(context).size.width - 100);
    final caretOffset = painter.getOffsetForCaret(
      TextPosition(offset: cursorPos),
      Rect.zero,
    );
    final lines = painter.computeLineMetrics();
    if (lines.isNotEmpty) {
      final lastLineTop = painter.height - lines.last.height;
      if (caretOffset.dy >= lastLineTop) {
        _moveToNextParagraph(paragraphIndex, cursorPos);
      }
    }
    painter.dispose();
  }

  CrossAxisAlignment _alignmentToCross(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }
}

// ════════════════════════════════════════════════════════════════════
// PER-PARAGRAPH CONTROLLER
//
// A lightweight TextEditingController that knows its position in the
// document and builds TextSpans with the correct formatting for its
// local text segment.
// ════════════════════════════════════════════════════════════════════

class _ParagraphController extends TextEditingController {
  List<TextFormat> localFormats;
  int paragraphOffset;
  double maxFontSize;
  final double baseFontSize;

  _ParagraphController({
    required String paraText,
    required this.localFormats,
    required this.paragraphOffset,
    required this.maxFontSize,
    required this.baseFontSize,
  }) : super(text: paraText);

  void update(
    String paraText,
    List<TextFormat> formats,
    int offset,
    double maxFs,
  ) {
    localFormats = formats;
    paragraphOffset = offset;
    maxFontSize = maxFs;
    if (text != paraText) {
      // Preserve selection if possible, please i beg of u
      final oldSel = selection;
      text = paraText;
      if (oldSel.isValid &&
          oldSel.start <= paraText.length &&
          oldSel.end <= paraText.length) {
        selection = oldSel;
      }
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final baseStyle = style ?? const TextStyle();

    if (localFormats.isEmpty || text.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final children = <TextSpan>[];
    final sorted = List<TextFormat>.from(localFormats)
      ..sort((a, b) => a.start.compareTo(b.start));

    int lastEnd = 0;

    for (final format in sorted) {
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

    // Remaining plain text screw it
    if (lastEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }

    return TextSpan(children: children, style: baseStyle);
  }
}
