import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/bash.dart' as bash;
import 'package:highlight/languages/cpp.dart' as cpp;
import 'package:highlight/languages/dart.dart' as dart;
import 'package:highlight/languages/go.dart' as go;
import 'package:highlight/languages/java.dart' as java;
import 'package:highlight/languages/javascript.dart' as javascript;
import 'package:highlight/languages/json.dart' as json;
import 'package:highlight/languages/python.dart' as python;
import 'package:highlight/languages/rust.dart' as rust;
import 'package:highlight/languages/sql.dart' as sql;
import 'package:highlight/languages/typescript.dart' as typescript;
import 'package:highlight/languages/yaml.dart' as yaml;
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import '../../models/models.dart';
import '../../theme/design_tokens.dart';

// ═══════════════════════════════════════════════════════════════════
// BLOCK TYPE ENUMS
// ═══════════════════════════════════════════════════════════════════

/// Enum representing the available block types for the add block menu.
enum BlockType {
  text(
    Icons.text_fields_rounded,
    'Text',
    'Plain text content',
    BlockCategory.text,
  ),
  heading(Icons.title_rounded, 'Heading', 'Section header', BlockCategory.text),
  bulletList(
    Icons.format_list_bulleted_rounded,
    'Bullet List',
    'Unordered list',
    BlockCategory.text,
  ),
  quote(
    Icons.format_quote_rounded,
    'Quote',
    'Citation or callout',
    BlockCategory.text,
  ),
  code(Icons.code_rounded, 'Code', 'Code snippet', BlockCategory.technical),
  math(
    Icons.functions_rounded,
    'Math',
    'LaTeX expression',
    BlockCategory.technical,
  ),
  sketch(
    Icons.gesture_rounded,
    'Sketch',
    'Freehand drawing',
    BlockCategory.media,
  ),
  audio(Icons.mic_rounded, 'Audio', 'Voice recording', BlockCategory.media),
  workspaceRef(
    Icons.widgets_rounded,
    'Workspace',
    'Link to workspace session',
    BlockCategory.integration,
  );

  const BlockType(this.icon, this.label, this.description, this.category);
  final IconData icon;
  final String label;
  final String description;
  final BlockCategory category;
}

/// Categories for organizing block types in the selector
enum BlockCategory {
  text('Text & Lists', Icons.text_fields_rounded),
  media('Media', Icons.perm_media_rounded),
  technical('Technical', Icons.terminal_rounded),
  integration('Integration', Icons.link_rounded);

  const BlockCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

// ═══════════════════════════════════════════════════════════════════
// BLOCK TYPE SELECTOR SHEET
// ═══════════════════════════════════════════════════════════════════

/// Shows the block type selector as a bottom sheet
/// Returns the selected BlockType or null if cancelled
Future<BlockType?> showBlockTypeSelector(BuildContext context) {
  return showModalBottomSheet<BlockType>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _BlockTypeSelectorSheet(),
  );
}

/// Bottom sheet selector for block types — clean M3 style
class _BlockTypeSelectorSheet extends StatelessWidget {
  const _BlockTypeSelectorSheet();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AxiomSpacing.lg,
              AxiomSpacing.md,
              AxiomSpacing.md,
              0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(AxiomRadius.sm),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: cs.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AxiomSpacing.sm),
                Text(
                  'Add Block',
                  style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          Divider(color: cs.outlineVariant, height: 1),
          // Categories and block types
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AxiomSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: BlockCategory.values.map((category) {
                  final blocksInCategory = BlockType.values
                      .where((b) => b.category == category)
                      .toList();

                  return _CategorySection(
                    category: category,
                    blocks: blocksInCategory,
                    onBlockSelected: (type) => Navigator.of(context).pop(type),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A section showing a category with its block types
class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.blocks,
    required this.onBlockSelected,
  });

  final BlockCategory category;
  final List<BlockType> blocks;
  final ValueChanged<BlockType> onBlockSelected;

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AxiomSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: const EdgeInsets.only(
              left: AxiomSpacing.xs,
              bottom: AxiomSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(category.icon, size: 14, color: cs.onSurfaceVariant),
                const SizedBox(width: AxiomSpacing.xs),
                Text(
                  category.label.toUpperCase(),
                  style: AxiomTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          // Block type grid
          Wrap(
            spacing: AxiomSpacing.sm,
            runSpacing: AxiomSpacing.sm,
            children: blocks
                .map(
                  (type) => _BlockTypeChip(
                    type: type,
                    onTap: () => onBlockSelected(type),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// A chip representing a block type
class _BlockTypeChip extends StatelessWidget {
  const _BlockTypeChip({required this.type, required this.onTap});

  final BlockType type;
  final VoidCallback onTap;

  Color _accentColor(ColorScheme cs) {
    return switch (type.category) {
      BlockCategory.text => cs.primary,
      BlockCategory.media => cs.tertiary,
      BlockCategory.technical => cs.secondary,
      BlockCategory.integration => cs.tertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = _accentColor(cs);

    return Material(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AxiomRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AxiomRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.md,
            vertical: AxiomSpacing.sm + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withAlpha(25),
                  borderRadius: BorderRadius.circular(AxiomRadius.sm),
                ),
                child: Icon(type.icon, size: 18, color: accent),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type.label,
                    style: AxiomTypography.labelMedium.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    type.description,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Legacy dialog for compatibility - uses bottom sheet internally
class BlockTypeSelector extends StatelessWidget {
  const BlockTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      showBlockTypeSelector(context).then((type) {
        if (type != null && context.mounted) {
          Navigator.of(context).pop(type);
        }
      });
    });
    return const SizedBox.shrink();
  }
}

// ═══════════════════════════════════════════════════════════════════
// BLOCK EDITOR CARD — Clean wrapper for all block editors
// ═══════════════════════════════════════════════════════════════════

/// Base card wrapper for block editors.
/// Clean M3 card: surfaceContainerLow body, subtle header, rounded corners.
class BlockEditorCard extends StatefulWidget {
  const BlockEditorCard({
    super.key,
    required this.blockType,
    required this.dragIndex,
    required this.onDelete,
    required this.child,
    this.trailing,
  });

  final String blockType;
  final int dragIndex;
  final VoidCallback onDelete;
  final Widget child;
  final Widget? trailing;

  @override
  State<BlockEditorCard> createState() => _BlockEditorCardState();
}

class _BlockEditorCardState extends State<BlockEditorCard> {
  void _confirmDelete(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Block?'),
        content: Text(
          'Delete this ${widget.blockType.toLowerCase()} block? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AxiomSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        border: Border.all(color: cs.outlineVariant.withAlpha(100)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header — subtle, functional
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AxiomSpacing.md,
              vertical: AxiomSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withAlpha(120),
              border: Border(
                bottom: BorderSide(color: cs.outlineVariant.withAlpha(60)),
              ),
            ),
            child: Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: widget.dragIndex,
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: 18,
                    color: cs.onSurfaceVariant.withAlpha(140),
                  ),
                ),
                const SizedBox(width: AxiomSpacing.sm),
                // Block type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AxiomSpacing.sm + 2,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(18),
                    borderRadius: BorderRadius.circular(AxiomRadius.sm),
                  ),
                  child: Text(
                    widget.blockType.toUpperCase(),
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: AxiomSpacing.sm),
                  widget.trailing!,
                ],
                const Spacer(),
                // Delete button
                Tooltip(
                  message:
                      'Delete this ${widget.blockType.toLowerCase()} block',
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: cs.error.withAlpha(160),
                    ),
                    onPressed: () => _confirmDelete(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AxiomRadius.sm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Block content — generous padding
          Padding(
            padding: const EdgeInsets.all(AxiomSpacing.md),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TEXT BLOCK EDITOR — Clean, spacious text area
// ═══════════════════════════════════════════════════════════════════

/// Editor for TextBlock.
/// Clean text area with no harsh borders — focus on the content.
class TextBlockEditor extends StatefulWidget {
  const TextBlockEditor({
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
  State<TextBlockEditor> createState() => _TextBlockEditorState();
}

class _TextBlockEditorState extends State<TextBlockEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  TextAlign _textAlign = TextAlign.left;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      _controller.text = widget.block.content;
    }
  }

  void _toggleBold() => setState(() => _isBold = !_isBold);
  void _toggleItalic() => setState(() => _isItalic = !_isItalic);
  void _toggleUnderline() => setState(() => _isUnderline = !_isUnderline);
  void _setAlignment(TextAlign align) => setState(() => _textAlign = align);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlockEditorCard(
      blockType: 'Text',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Formatting toolbar — word-processor style ──
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AxiomSpacing.sm,
              vertical: AxiomSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
            ),
            child: Row(
              children: [
                _FormatButton(
                  icon: Icons.format_bold_rounded,
                  isActive: _isBold,
                  onPressed: _toggleBold,
                  tooltip: 'Bold',
                ),
                _FormatButton(
                  icon: Icons.format_italic_rounded,
                  isActive: _isItalic,
                  onPressed: _toggleItalic,
                  tooltip: 'Italic',
                ),
                _FormatButton(
                  icon: Icons.format_underlined_rounded,
                  isActive: _isUnderline,
                  onPressed: _toggleUnderline,
                  tooltip: 'Underline',
                ),
                Container(
                  width: 1,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  color: cs.outlineVariant.withAlpha(80),
                ),
                _FormatButton(
                  icon: Icons.format_align_left_rounded,
                  isActive: _textAlign == TextAlign.left,
                  onPressed: () => _setAlignment(TextAlign.left),
                  tooltip: 'Align left',
                ),
                _FormatButton(
                  icon: Icons.format_align_center_rounded,
                  isActive: _textAlign == TextAlign.center,
                  onPressed: () => _setAlignment(TextAlign.center),
                  tooltip: 'Center',
                ),
                _FormatButton(
                  icon: Icons.format_align_right_rounded,
                  isActive: _textAlign == TextAlign.right,
                  onPressed: () => _setAlignment(TextAlign.right),
                  tooltip: 'Align right',
                ),
                const Spacer(),
                // Word + character count
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
          ),
          const SizedBox(height: AxiomSpacing.sm),
          // ── Document-like writing area ──
          Container(
            constraints: const BoxConstraints(minHeight: 180),
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
              minLines: 8,
              textAlign: _textAlign,
              style: AxiomTypography.bodyMedium.copyWith(
                color: cs.onSurface,
                height: 1.8,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline ? TextDecoration.underline : null,
              ),
              decoration: InputDecoration(
                hintText: 'Start writing...',
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
              onChanged: widget.onContentChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small toggle button for the text formatting toolbar.
class _FormatButton extends StatelessWidget {
  const _FormatButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final bool isActive;
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
            color: isActive ? cs.primary.withAlpha(30) : Colors.transparent,
            borderRadius: BorderRadius.circular(AxiomRadius.xs),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? cs.primary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HEADING BLOCK EDITOR
// ═══════════════════════════════════════════════════════════════════

/// Editor for HeadingBlock.
class HeadingBlockEditor extends StatefulWidget {
  const HeadingBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onContentChanged,
    required this.onLevelChanged,
    required this.onDelete,
  });

  final HeadingBlock block;
  final int dragIndex;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<int> onLevelChanged;
  final VoidCallback onDelete;

  @override
  State<HeadingBlockEditor> createState() => _HeadingBlockEditorState();
}

class _HeadingBlockEditorState extends State<HeadingBlockEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HeadingBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      _controller.text = widget.block.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final headingStyle = switch (widget.block.level) {
      1 => AxiomTypography.heading1,
      2 => AxiomTypography.heading2,
      _ => AxiomTypography.heading3,
    };

    final isMobile = AxiomBreakpoints.isMobile(context);

    return BlockEditorCard(
      blockType: 'H${widget.block.level}',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      trailing: isMobile
          ? _HeadingLevelPopup(
              currentLevel: widget.block.level,
              onLevelChanged: widget.onLevelChanged,
            )
          : SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('H1')),
                ButtonSegment(value: 2, label: Text('H2')),
                ButtonSegment(value: 3, label: Text('H3')),
              ],
              selected: {widget.block.level},
              onSelectionChanged: (set) => widget.onLevelChanged(set.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return cs.primaryContainer;
                  }
                  return cs.surfaceContainer;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return cs.onPrimaryContainer;
                  }
                  return cs.onSurfaceVariant;
                }),
              ),
            ),
      child: TextField(
        controller: _controller,
        maxLines: 1,
        style: headingStyle.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'Heading...',
          hintStyle: headingStyle.copyWith(
            color: cs.onSurfaceVariant.withAlpha(100),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onContentChanged,
      ),
    );
  }
}

/// Popup menu for heading level selection on mobile
class _HeadingLevelPopup extends StatelessWidget {
  const _HeadingLevelPopup({
    required this.currentLevel,
    required this.onLevelChanged,
  });

  final int currentLevel;
  final ValueChanged<int> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<int>(
      initialValue: currentLevel,
      onSelected: onLevelChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.sm + 2,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'H$currentLevel',
              style: AxiomTypography.labelMedium.copyWith(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: cs.onPrimaryContainer,
              size: 18,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        for (final level in [1, 2, 3])
          PopupMenuItem<int>(
            value: level,
            child: Row(
              children: [
                if (level == currentLevel)
                  Icon(Icons.check_rounded, size: 16, color: cs.primary)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(
                  'Heading $level',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: level == currentLevel
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// BULLET LIST BLOCK EDITOR
// ═══════════════════════════════════════════════════════════════════

/// Editor for BulletListBlock.
class BulletListBlockEditor extends StatefulWidget {
  const BulletListBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onItemsChanged,
    required this.onDelete,
  });

  final BulletListBlock block;
  final int dragIndex;
  final ValueChanged<List<String>> onItemsChanged;
  final VoidCallback onDelete;

  @override
  State<BulletListBlockEditor> createState() => _BulletListBlockEditorState();
}

class _BulletListBlockEditorState extends State<BulletListBlockEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.block.items
        .map((item) => TextEditingController(text: item))
        .toList();
    if (_controllers.isEmpty) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateItems() {
    widget.onItemsChanged(_controllers.map((c) => c.text).toList());
  }

  void _addItem() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _updateItems();
  }

  void _removeItem(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
      });
      _updateItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlockEditorCard(
      blockType: 'List',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        children: [
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AxiomSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: AxiomSpacing.sm + 2),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: cs.onSurface,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'List item...',
                        hintStyle: AxiomTypography.bodyMedium.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(100),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AxiomSpacing.sm,
                        ),
                        suffixIcon: _controllers.length > 1
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: cs.error.withAlpha(160),
                                ),
                                onPressed: () => _removeItem(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              )
                            : null,
                      ),
                      onChanged: (_) => _updateItems(),
                    ),
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add item'),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// CODE BLOCK EDITOR — Monospace, dark surface for contrast
// ═══════════════════════════════════════════════════════════════════

/// Editor for CodeBlock.
class CodeBlockEditor extends StatefulWidget {
  const CodeBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onContentChanged,
    required this.onLanguageChanged,
    required this.onDelete,
  });

  final CodeBlock block;
  final int dragIndex;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onDelete;

  @override
  State<CodeBlockEditor> createState() => _CodeBlockEditorState();
}

class _CodeBlockEditorState extends State<CodeBlockEditor> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.block.content,
      language: _resolveLanguage(widget.block.language),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CodeBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      _codeController.text = widget.block.content;
      _codeController.language = _resolveLanguage(widget.block.language);
      return;
    }

    if (oldWidget.block.language != widget.block.language) {
      _codeController.language = _resolveLanguage(widget.block.language);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlockEditorCard(
      blockType: 'Code',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      trailing: _LanguageDropdown(
        currentLanguage: widget.block.language,
        onChanged: widget.onLanguageChanged,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language badge
          if (widget.block.language.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AxiomSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.sm + 2,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: cs.tertiary.withAlpha(20),
                  borderRadius: BorderRadius.circular(AxiomRadius.sm),
                ),
                child: Text(
                  widget.block.language.toUpperCase(),
                  style: AxiomTypography.labelSmall.copyWith(
                    color: cs.tertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          // Code editor — always dark surface for contrast
          Container(
            decoration: BoxDecoration(
              color: AxiomColors.darkBg1,
              borderRadius: BorderRadius.circular(AxiomRadius.md),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: Padding(
                    padding: const EdgeInsets.all(AxiomSpacing.md),
                    child: CodeField(
                      controller: _codeController,
                      maxLines: null,
                      minLines: 5,
                      textStyle: AxiomTypography.code.copyWith(
                        color: AxiomColors.darkFg,
                        height: 1.6,
                      ),
                      onChanged: widget.onContentChanged,
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _codeController,
                  builder: (context, value, _) {
                    if (value.text.isNotEmpty) return const SizedBox.shrink();
                    return IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.all(AxiomSpacing.md),
                        child: Text(
                          '// Enter code here...',
                          style: AxiomTypography.code.copyWith(
                            color: AxiomColors.darkGrey1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code stats footer
          Padding(
            padding: const EdgeInsets.only(top: AxiomSpacing.sm),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _codeController,
              builder: (context, value, _) {
                final text = value.text;
                final lineCount = text.isEmpty ? 0 : text.split('\n').length;
                return Row(
                  children: [
                    Icon(
                      Icons.segment_rounded,
                      size: 12,
                      color: cs.onSurfaceVariant.withAlpha(120),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$lineCount lines',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                    const SizedBox(width: AxiomSpacing.md),
                    Icon(
                      Icons.abc_rounded,
                      size: 12,
                      color: cs.onSurfaceVariant.withAlpha(120),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${text.length} chars',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Mode? _resolveLanguage(String language) {
    return switch (language) {
      'dart' => dart.dart,
      'python' => python.python,
      'javascript' => javascript.javascript,
      'typescript' => typescript.typescript,
      'java' => java.java,
      'cpp' => cpp.cpp,
      'rust' => rust.rust,
      'go' => go.go,
      'sql' => sql.sql,
      'json' => json.json,
      'yaml' => yaml.yaml,
      'bash' => bash.bash,
      _ => null,
    };
  }
}

/// Language dropdown for code blocks
class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.currentLanguage,
    required this.onChanged,
  });

  final String currentLanguage;
  final ValueChanged<String> onChanged;

  static const _languages = [
    '',
    'dart',
    'python',
    'javascript',
    'typescript',
    'java',
    'cpp',
    'rust',
    'go',
    'sql',
    'json',
    'yaml',
    'bash',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DropdownButton<String>(
      value: _languages.contains(currentLanguage) ? currentLanguage : '',
      isDense: true,
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(AxiomRadius.sm),
      dropdownColor: cs.surfaceContainerLow,
      style: AxiomTypography.labelMedium.copyWith(color: cs.onSurface),
      items: _languages.map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang.isEmpty ? 'Plain' : lang),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// QUOTE BLOCK EDITOR — Left accent border, italic style
// ═══════════════════════════════════════════════════════════════════

/// Editor for QuoteBlock.
class QuoteBlockEditor extends StatefulWidget {
  const QuoteBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onContentChanged,
    required this.onAttributionChanged,
    required this.onDelete,
  });

  final QuoteBlock block;
  final int dragIndex;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<String> onAttributionChanged;
  final VoidCallback onDelete;

  @override
  State<QuoteBlockEditor> createState() => _QuoteBlockEditorState();
}

class _QuoteBlockEditorState extends State<QuoteBlockEditor> {
  late TextEditingController _contentController;
  late TextEditingController _attributionController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.block.content);
    _attributionController = TextEditingController(
      text: widget.block.attribution,
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _attributionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuoteBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      _contentController.text = widget.block.content;
      _attributionController.text = widget.block.attribution;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlockEditorCard(
      blockType: 'Quote',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: cs.secondary, width: 3)),
        ),
        padding: const EdgeInsets.only(left: AxiomSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 2,
              style: AxiomTypography.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                color: cs.onSurface,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'Enter quote...',
                hintStyle: AxiomTypography.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  color: cs.onSurfaceVariant.withAlpha(100),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onContentChanged,
            ),
            TextField(
              controller: _attributionController,
              maxLines: 1,
              style: AxiomTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
              decoration: InputDecoration(
                hintText: '— Attribution (optional)',
                hintStyle: AxiomTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant.withAlpha(100),
                ),
                border: InputBorder.none,
                prefixText: _attributionController.text.isEmpty ? null : '— ',
                prefixStyle: AxiomTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onAttributionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
