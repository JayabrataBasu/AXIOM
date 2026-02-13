import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/content_block.dart';
import '../../theme/design_tokens.dart';
import 'block_editors.dart';
import 'rich_text_editor.dart';
import 'rich_text_commands.dart';

/// Advanced rich text editor with per-selection formatting (MS Word style)
class RichTextBlockEditor extends StatefulWidget {
  const RichTextBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onContentChanged,
    required this.onDelete,
  });

  final TextBlock block;
  final int dragIndex;
  final ValueChanged<String> onContentChanged;
  final VoidCallback onDelete;

  @override
  State<RichTextBlockEditor> createState() => _RichTextBlockEditorState();
}

class _RichTextBlockEditorState extends State<RichTextBlockEditor> {
  late RichTextController _controller;
  late FocusNode _focusNode;
  late CommandHistory _history;
  TextFormat? _currentFormat;

  static const List<String> _fontFamilies = [
    'Default',
    'Roboto',
    'Arial',
    'Times New Roman',
    'Courier New',
    'Georgia',
    'Verdana',
    'Monospace',
  ];

  static const List<double> _fontSizes = [
    8,
    9,
    10,
    11,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    26,
    28,
    32,
    36,
    48,
    72,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize history
    _history = CommandHistory();

    // Try to parse as rich text JSON, fallback to plain text
    try {
      if (widget.block.content.startsWith('{')) {
        _controller = RichTextController.fromJson(widget.block.content);
      } else {
        _controller = RichTextController(text: widget.block.content);
      }
    } catch (e) {
      _controller = RichTextController(text: widget.block.content);
    }
    _focusNode = FocusNode();
    _controller.addListener(_updateCurrentFormat);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentFormat);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateCurrentFormat() {
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentFormat = _controller.getFormatAtCursor();
        });
      }
    });
  }

  @override
  void didUpdateWidget(RichTextBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      // Properly dispose old controller to prevent memory leak
      _controller.removeListener(_updateCurrentFormat);
      _controller.dispose();

      // Create new controller
      try {
        if (widget.block.content.startsWith('{')) {
          _controller = RichTextController.fromJson(widget.block.content);
        } else {
          _controller = RichTextController(text: widget.block.content);
        }
      } catch (e) {
        _controller = RichTextController(text: widget.block.content);
      }

      // Re-attach listener
      _controller.addListener(_updateCurrentFormat);
    }
  }

  void _applyToggleFormat(String formatType) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.start == selection.end) {
      // Show hint to select text
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select text to format'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final currentFormat =
        _currentFormat ??
        TextFormat(start: selection.start, end: selection.end);

    TextFormat newFormat;
    switch (formatType) {
      case 'bold':
        newFormat = currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          bold: !(currentFormat.bold),
        );
        break;
      case 'italic':
        newFormat = currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          italic: !(currentFormat.italic),
        );
        break;
      case 'underline':
        newFormat = currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          underline: !(currentFormat.underline),
        );
        break;
      case 'strikethrough':
        newFormat = currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          strikethrough: !(currentFormat.strikethrough),
        );
        break;
      default:
        return;
    }

    _controller.applyFormat(newFormat);
    widget.onContentChanged(_controller.toJson());
  }

  void _applyFontSize(double size) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.start == selection.end) return;

    final currentFormat =
        _currentFormat ??
        TextFormat(start: selection.start, end: selection.end);

    _controller.applyFormat(
      currentFormat.copyWith(
        start: selection.start,
        end: selection.end,
        fontSize: size,
      ),
    );
    widget.onContentChanged(_controller.toJson());
  }

  void _applyFontFamily(String family) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.start == selection.end) return;

    final currentFormat =
        _currentFormat ??
        TextFormat(start: selection.start, end: selection.end);

    _controller.applyFormat(
      currentFormat.copyWith(
        start: selection.start,
        end: selection.end,
        fontFamily: family == 'Default' ? null : family,
      ),
    );
    widget.onContentChanged(_controller.toJson());
  }

  void _applyColor(Color? color, bool isText) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.start == selection.end) return;

    final currentFormat =
        _currentFormat ??
        TextFormat(start: selection.start, end: selection.end);

    if (isText) {
      _controller.applyFormat(
        currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          textColor: color,
          clearTextColor: color == null,
        ),
      );
    } else {
      _controller.applyFormat(
        currentFormat.copyWith(
          start: selection.start,
          end: selection.end,
          backgroundColor: color,
          clearBackgroundColor: color == null,
        ),
      );
    }
    widget.onContentChanged(_controller.toJson());
  }

  void _clearFormatting() {
    _controller.clearFormat();
    widget.onContentChanged(_controller.toJson());
  }

  void _setAlignment(TextAlign align) {
    setState(() {
      _controller.textAlign = align;
    });
  }

  void _transformCase(String transform) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.start == selection.end) return;

    final selectedText = _controller.text.substring(
      selection.start,
      selection.end,
    );
    String transformed;

    switch (transform) {
      case 'upper':
        transformed = selectedText.toUpperCase();
        break;
      case 'lower':
        transformed = selectedText.toLowerCase();
        break;
      case 'title':
        transformed = selectedText
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
            )
            .join(' ');
        break;
      default:
        return;
    }

    _controller.text =
        _controller.text.substring(0, selection.start) +
        transformed +
        _controller.text.substring(selection.end);
    _controller.selection = TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.start + transformed.length,
    );
    widget.onContentChanged(_controller.toJson());
  }

  void _insertSpecialChar(String char) {
    final selection = _controller.selection;
    final offset = selection.baseOffset;
    _controller.text =
        _controller.text.substring(0, offset) +
        char +
        _controller.text.substring(offset);
    _controller.selection = TextSelection.collapsed(
      offset: offset + char.length,
    );
    widget.onContentChanged(_controller.toJson());
  }

  void _showColorPicker(bool isTextColor) {
    final cs = Theme.of(context).colorScheme;
    final colors = [
      null, // Reset/default
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.yellow.shade700,
      Colors.brown,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isTextColor ? 'Text Color' : 'Highlight Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                _applyColor(color, isTextColor);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color ?? cs.surface,
                  border: Border.all(
                    color: color == null
                        ? cs.outline
                        : (color == Colors.white
                              ? cs.outline
                              : Colors.transparent),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: color == null
                    ? Icon(Icons.clear, size: 20, color: cs.onSurface)
                    : null,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSpecialCharsDialog() {
    final specialChars = [
      '©',
      '®',
      '™',
      '€',
      '£',
      '¥',
      '¢',
      '§',
      '¶',
      '†',
      '‡',
      '•',
      '°',
      '±',
      '×',
      '÷',
      '≈',
      '≠',
      '≤',
      '≥',
      '∞',
      '∑',
      '∏',
      '√',
      'α',
      'β',
      'γ',
      'π',
      'Ω',
      '→',
      '←',
      '↑',
      '↓',
      '↔',
      '⇒',
      '⇔',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Special Character'),
        content: SizedBox(
          width: 300,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: specialChars.map((char) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _insertSpecialChar(char);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(char, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _undo() {
    if (_history.undo()) {
      setState(() {});
      widget.onContentChanged(_controller.toJson());
    }
  }

  void _redo() {
    if (_history.redo()) {
      setState(() {});
      widget.onContentChanged(_controller.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bool isBold = _currentFormat?.bold ?? false;
    final bool isItalic = _currentFormat?.italic ?? false;
    final bool isUnderline = _currentFormat?.underline ?? false;
    final bool isStrikethrough = _currentFormat?.strikethrough ?? false;
    final double fontSize = _currentFormat?.fontSize ?? 16.0;
    final String fontFamily = _currentFormat?.fontFamily ?? 'Default';

    return BlockEditorCard(
      blockType: 'Rich Text',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Enhanced MS Word-style toolbar ──
          Container(
            padding: const EdgeInsets.all(AxiomSpacing.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              border: Border.all(color: cs.outlineVariant.withAlpha(30)),
            ),
            child: Column(
              children: [
                // Row 1: Font controls and basic formatting
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Font family
                    _DropdownControl(
                      value: fontFamily,
                      items: _fontFamilies,
                      onChanged: _applyFontFamily,
                      width: 140,
                    ),
                    // Font size
                    _DropdownControl(
                      value: fontSize,
                      items: _fontSizes,
                      onChanged: _applyFontSize,
                      width: 60,
                      displayText: (val) => '${val.toInt()}',
                    ),
                    _VerticalDivider(cs: cs),
                    // Text formatting
                    _FormatButton(
                      icon: Icons.format_bold_rounded,
                      isActive: isBold,
                      onPressed: () => _applyToggleFormat('bold'),
                      tooltip: 'Bold (Ctrl+B)',
                    ),
                    _FormatButton(
                      icon: Icons.format_italic_rounded,
                      isActive: isItalic,
                      onPressed: () => _applyToggleFormat('italic'),
                      tooltip: 'Italic (Ctrl+I)',
                    ),
                    _FormatButton(
                      icon: Icons.format_underlined_rounded,
                      isActive: isUnderline,
                      onPressed: () => _applyToggleFormat('underline'),
                      tooltip: 'Underline (Ctrl+U)',
                    ),
                    _FormatButton(
                      icon: Icons.strikethrough_s_rounded,
                      isActive: isStrikethrough,
                      onPressed: () => _applyToggleFormat('strikethrough'),
                      tooltip: 'Strikethrough',
                    ),
                    _FormatButton(
                      icon: Icons.format_clear_rounded,
                      isActive: false,
                      onPressed: _clearFormatting,
                      tooltip: 'Clear formatting',
                    ),
                    _VerticalDivider(cs: cs),
                    // Colors
                    _ColorButton(
                      icon: Icons.format_color_text_rounded,
                      color: _currentFormat?.textColor ?? cs.primary,
                      onPressed: () => _showColorPicker(true),
                      tooltip: 'Text color',
                    ),
                    _ColorButton(
                      icon: Icons.format_color_fill_rounded,
                      color:
                          _currentFormat?.backgroundColor ??
                          Colors.yellow.shade300,
                      onPressed: () => _showColorPicker(false),
                      tooltip: 'Highlight',
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Row 2: Undo/Redo, Alignment, lists, and utilities
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Undo/Redo buttons
                    _FormatButton(
                      icon: Icons.undo_rounded,
                      isActive: false,
                      onPressed: _history.canUndo ? _undo : null,
                      tooltip: 'Undo (Ctrl+Z)',
                    ),
                    _FormatButton(
                      icon: Icons.redo_rounded,
                      isActive: false,
                      onPressed: _history.canRedo ? _redo : null,
                      tooltip: 'Redo (Ctrl+Y)',
                    ),
                    _VerticalDivider(cs: cs),
                    // Alignment
                    _FormatButton(
                      icon: Icons.format_align_left_rounded,
                      isActive: _controller.textAlign == TextAlign.left,
                      onPressed: () => _setAlignment(TextAlign.left),
                      tooltip: 'Align left',
                    ),
                    _FormatButton(
                      icon: Icons.format_align_center_rounded,
                      isActive: _controller.textAlign == TextAlign.center,
                      onPressed: () => _setAlignment(TextAlign.center),
                      tooltip: 'Center',
                    ),
                    _FormatButton(
                      icon: Icons.format_align_right_rounded,
                      isActive: _controller.textAlign == TextAlign.right,
                      onPressed: () => _setAlignment(TextAlign.right),
                      tooltip: 'Align right',
                    ),
                    _FormatButton(
                      icon: Icons.format_align_justify_rounded,
                      isActive: _controller.textAlign == TextAlign.justify,
                      onPressed: () => _setAlignment(TextAlign.justify),
                      tooltip: 'Justify',
                    ),
                    _VerticalDivider(cs: cs),
                    // Text case
                    _FormatButton(
                      icon: Icons.text_fields_rounded,
                      isActive: false,
                      onPressed: () => _transformCase('upper'),
                      tooltip: 'UPPERCASE',
                    ),
                    _FormatButton(
                      icon: Icons.title_rounded,
                      isActive: false,
                      onPressed: () => _transformCase('title'),
                      tooltip: 'Title Case',
                    ),
                    _FormatButton(
                      icon: Icons.format_size_rounded,
                      isActive: false,
                      onPressed: () => _transformCase('lower'),
                      tooltip: 'lowercase',
                    ),
                    _VerticalDivider(cs: cs),
                    // Special characters
                    _FormatButton(
                      icon: Icons.insert_emoticon_outlined,
                      isActive: false,
                      onPressed: _showSpecialCharsDialog,
                      tooltip: 'Insert special character',
                    ),
                    // Word count
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) {
                        final charCount = value.text.length;
                        final wordCount = value.text.trim().isEmpty
                            ? 0
                            : value.text.trim().split(RegExp(r'\s+')).length;
                        return Text(
                          '$wordCount words · $charCount chars',
                          style: AxiomTypography.labelSmall.copyWith(
                            color: cs.onSurfaceVariant.withAlpha(120),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          // ── Rich text editor field ──
          Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AxiomSpacing.lg,
              vertical: AxiomSpacing.md,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              border: Border.all(color: cs.outlineVariant.withAlpha(40)),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              minLines: 10,
              textAlign: _controller.textAlign,
              style: AxiomTypography.bodyMedium.copyWith(
                color: cs.onSurface,
                height: 1.8,
              ),
              decoration: InputDecoration(
                hintText: 'Start writing... Select text to apply formatting.',
                hintStyle: AxiomTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant.withAlpha(100),
                  height: 1.8,
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (text) {
                setState(() {}); // Update format at cursor
                widget.onContentChanged(_controller.toJson());
              },
            ),
          ),
          // Format count indicator
          if (_controller.formats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AxiomSpacing.xs),
              child: Text(
                '${_controller.formats.length} format span(s) applied',
                style: AxiomTypography.labelSmall.copyWith(
                  color: cs.primary.withAlpha(180),
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════

class _DropdownControl<T> extends StatelessWidget {
  const _DropdownControl({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.width,
    this.displayText,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final double width;
  final String Function(T)? displayText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 30,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AxiomRadius.xs),
        border: Border.all(color: cs.outlineVariant.withAlpha(50)),
      ),
      child: DropdownButton<T>(
        value: value,
        isDense: true,
        isExpanded: true,
        underline: const SizedBox(),
        style: AxiomTypography.labelSmall.copyWith(color: cs.onSurface),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              displayText?.call(item) ?? item.toString(),
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: cs.outlineVariant.withAlpha(80),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(AxiomRadius.xs),
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AxiomRadius.xs),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 18, color: cs.onSurfaceVariant),
              Positioned(
                bottom: 4,
                child: Container(
                  width: 16,
                  height: 3,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Format button widget for toolbar
class _FormatButton extends StatelessWidget {
  const _FormatButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback? onPressed; // Can be null for disabled state
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(AxiomRadius.xs),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? cs.primary.withAlpha(30) : Colors.transparent,
            borderRadius: BorderRadius.circular(AxiomRadius.xs),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isEnabled
                ? (isActive ? cs.primary : cs.onSurfaceVariant)
                : cs.outlineVariant.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
