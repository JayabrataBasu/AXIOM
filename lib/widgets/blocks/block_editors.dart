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

/// Enum representing the available block types for the add block menu.
enum BlockType {
  text(Icons.text_fields, 'Text', 'Plain text content', BlockCategory.text),
  heading(Icons.title, 'Heading', 'Section header', BlockCategory.text),
  bulletList(
    Icons.format_list_bulleted,
    'Bullet List',
    'Unordered list',
    BlockCategory.text,
  ),
  quote(Icons.format_quote, 'Quote', 'Citation or callout', BlockCategory.text),
  code(Icons.code, 'Code', 'Code snippet', BlockCategory.technical),
  math(Icons.functions, 'Math', 'LaTeX expression', BlockCategory.technical),
  sketch(Icons.gesture, 'Sketch', 'Freehand drawing', BlockCategory.media),
  audio(Icons.mic, 'Audio', 'Voice recording', BlockCategory.media),
  workspaceRef(
    Icons.widgets,
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
  text('Text & Lists', Icons.text_fields),
  media('Media', Icons.perm_media),
  technical('Technical', Icons.terminal),
  integration('Integration', Icons.link);

  const BlockCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Shows the block type selector as a bottom sheet
/// Returns the selected BlockType or null if cancelled
Future<BlockType?> showBlockTypeSelector(BuildContext context) {
  return showModalBottomSheet<BlockType>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const _BlockTypeSelectorSheet(),
  );
}

/// Bottom sheet selector for block types - Everforest styled with categories
class _BlockTypeSelectorSheet extends StatelessWidget {
  const _BlockTypeSelectorSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AxiomColors.bg1,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AxiomRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AxiomSpacing.sm + 2),
            decoration: BoxDecoration(
              color: AxiomColors.grey2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AxiomSpacing.md),
            child: Row(
              children: [
                Icon(Icons.add_box_rounded, color: AxiomColors.green, size: 28),
                const SizedBox(width: AxiomSpacing.sm),
                Text(
                  'Add Block',
                  style: AxiomTypography.heading2.copyWith(
                    color: AxiomColors.fg,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: AxiomColors.grey0),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(color: AxiomColors.bg3, height: 1),
          // Categories and block types
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AxiomSpacing.md,
                vertical: AxiomSpacing.sm,
              ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: AxiomSpacing.md),
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
                Icon(category.icon, size: 16, color: AxiomColors.grey1),
                const SizedBox(width: AxiomSpacing.xs),
                Text(
                  category.label,
                  style: AxiomTypography.labelMedium.copyWith(
                    color: AxiomColors.grey0,
                    fontWeight: FontWeight.w600,
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

/// A chip representing a block type - Everforest styled
class _BlockTypeChip extends StatelessWidget {
  const _BlockTypeChip({required this.type, required this.onTap});

  final BlockType type;
  final VoidCallback onTap;

  Color get _accentColor {
    return switch (type.category) {
      BlockCategory.text => AxiomColors.green,
      BlockCategory.media => AxiomColors.orange,
      BlockCategory.technical => AxiomColors.blue,
      BlockCategory.integration => AxiomColors.yellow,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AxiomColors.bg2,
      borderRadius: BorderRadius.circular(AxiomRadius.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AxiomRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.sm + 2,
            vertical: AxiomSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(type.icon, size: 18, color: _accentColor),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type.label,
                    style: AxiomTypography.labelMedium.copyWith(
                      color: AxiomColors.fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    type.description,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.grey1,
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
    // Return a dialog that redirects to the bottom sheet
    // This maintains backward compatibility
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

/// Base card wrapper for block editors.
/// Everforest styled: bg1 card, bg2 header, green type badge.
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AxiomColors.bg1,
        title: Text(
          'Delete Block?',
          style: AxiomTypography.heading3.copyWith(color: AxiomColors.fg),
        ),
        content: Text(
          'Delete this ${widget.blockType.toLowerCase()} block? This action cannot be undone.',
          style: AxiomTypography.bodyMedium.copyWith(color: AxiomColors.grey0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AxiomColors.grey0)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: AxiomColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AxiomSpacing.sm + 2),
      elevation: 1,
      color: AxiomColors.bg1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AxiomRadius.md),
        side: BorderSide(color: AxiomColors.bg3.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header - Everforest bg2
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AxiomSpacing.sm + 2,
              vertical: AxiomSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AxiomColors.bg2,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AxiomRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: widget.dragIndex,
                  child: Icon(
                    Icons.drag_handle,
                    size: 20,
                    color: AxiomColors.grey1,
                  ),
                ),
                const SizedBox(width: AxiomSpacing.sm),
                // Block type badge - Everforest green tint
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AxiomSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AxiomColors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.blockType.toUpperCase(),
                      style: AxiomTypography.labelSmall.copyWith(
                        color: AxiomColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: AxiomSpacing.sm),
                  widget.trailing!,
                ],
                const Spacer(),
                // Delete button with tooltip
                Tooltip(
                  message:
                      'Delete this ${widget.blockType.toLowerCase()} block',
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _confirmDelete(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AxiomColors.red.withAlpha(180),
                    hoverColor: AxiomColors.red.withAlpha(50),
                  ),
                ),
              ],
            ),
          ),
          // Block content
          Padding(
            padding: const EdgeInsets.all(AxiomSpacing.sm + 2),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Editor for TextBlock.
/// Everforest styled text input with fg text, grey hints.
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
  void didUpdateWidget(TextBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      _controller.text = widget.block.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlockEditorCard(
      blockType: 'Text',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text field - Everforest styled
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 3,
            style: AxiomTypography.bodyMedium.copyWith(color: AxiomColors.fg),
            decoration: InputDecoration(
              hintText: 'Enter text content...',
              hintStyle: AxiomTypography.bodyMedium.copyWith(
                color: AxiomColors.grey1,
              ),
              filled: true,
              fillColor: AxiomColors.bg0.withAlpha(150),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.sm),
                borderSide: BorderSide(color: AxiomColors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.sm),
                borderSide: BorderSide(color: AxiomColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.sm),
                borderSide: BorderSide(color: AxiomColors.green, width: 2),
              ),
              contentPadding: const EdgeInsets.all(AxiomSpacing.sm + 2),
              isDense: true,
            ),
            onChanged: widget.onContentChanged,
          ),
          // Character count
          Padding(
            padding: const EdgeInsets.only(top: AxiomSpacing.sm),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) => Text(
                '${value.text.length} characters',
                style: AxiomTypography.labelSmall.copyWith(
                  color: AxiomColors.grey1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    // Everforest styled heading with typography tokens
    final headingStyle = switch (widget.block.level) {
      1 => AxiomTypography.heading1,
      2 => AxiomTypography.heading2,
      _ => AxiomTypography.heading3,
    };

    // Responsive: use popup menu on mobile, segmented button on tablet+
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
                    return AxiomColors.green.withAlpha(40);
                  }
                  return AxiomColors.bg2;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AxiomColors.green;
                  }
                  return AxiomColors.grey0;
                }),
              ),
            ),
      child: TextField(
        controller: _controller,
        maxLines: 1,
        style: headingStyle.copyWith(
          color: AxiomColors.fg,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: 'Heading...',
          hintStyle: headingStyle.copyWith(color: AxiomColors.grey1),
          border: InputBorder.none,
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
    return PopupMenuButton<int>(
      initialValue: currentLevel,
      onSelected: onLevelChanged,
      color: AxiomColors.bg2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AxiomRadius.sm),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AxiomColors.green.withAlpha(40),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'H$currentLevel',
              style: AxiomTypography.labelMedium.copyWith(
                color: AxiomColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: AxiomColors.green, size: 18),
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
                  Icon(Icons.check, size: 16, color: AxiomColors.green)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(
                  'Heading $level',
                  style: TextStyle(
                    color: AxiomColors.fg,
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
    // Everforest styled bullet list
    return BlockEditorCard(
      blockType: 'List',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        children: [
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AxiomSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: AxiomColors.green,
                    ),
                  ),
                  const SizedBox(width: AxiomSpacing.sm + 2),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: AxiomColors.fg,
                      ),
                      decoration: InputDecoration(
                        hintText: 'List item...',
                        hintStyle: AxiomTypography.bodyMedium.copyWith(
                          color: AxiomColors.grey1,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AxiomSpacing.sm,
                        ),
                        suffixIcon: _controllers.length > 1
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AxiomColors.red.withAlpha(180),
                                ),
                                onPressed: () => _removeItem(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
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
              icon: Icon(Icons.add, size: 18, color: AxiomColors.green),
              label: Text(
                'Add item',
                style: TextStyle(color: AxiomColors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  static const _commonLanguages = [
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
    // Everforest styled code editor
    return BlockEditorCard(
      blockType: 'Code',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      trailing: DropdownButton<String>(
        value: _commonLanguages.contains(widget.block.language)
            ? widget.block.language
            : '',
        isDense: true,
        underline: const SizedBox.shrink(),
        dropdownColor: AxiomColors.bg2,
        style: TextStyle(color: AxiomColors.fg),
        items: _commonLanguages.map((lang) {
          return DropdownMenuItem(
            value: lang,
            child: Text(
              lang.isEmpty ? 'Plain' : lang,
              style: AxiomTypography.labelMedium.copyWith(
                color: AxiomColors.fg,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            widget.onLanguageChanged(value);
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language info badge - Everforest blue accent
          if (widget.block.language.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AxiomSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AxiomColors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.block.language.toUpperCase(),
                  style: AxiomTypography.labelSmall.copyWith(
                    color: AxiomColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Code editor with monospace font - Everforest bg0 surface
          Container(
            decoration: BoxDecoration(
              color: AxiomColors.bg0,
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              border: Border.all(color: AxiomColors.outlineVariant),
            ),
            child: Stack(
              children: [
                CodeTheme(
                  data: CodeThemeData(
                    styles: monokaiSublimeTheme, // Always dark for Everforest
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AxiomSpacing.sm + 2),
                    child: CodeField(
                      controller: _codeController,
                      maxLines: null,
                      minLines: 5,
                      textStyle: AxiomTypography.code.copyWith(
                        color: AxiomColors.fg,
                        height: 1.5,
                      ),
                      onChanged: widget.onContentChanged,
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _codeController,
                  builder: (context, value, _) {
                    if (value.text.isNotEmpty) {
                      return const SizedBox.shrink();
                    }

                    return IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.all(AxiomSpacing.sm + 2),
                        child: Text(
                          '// Enter code here...',
                          style: AxiomTypography.code.copyWith(
                            color: AxiomColors.grey1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code stats
          Padding(
            padding: const EdgeInsets.only(top: AxiomSpacing.sm),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _codeController,
              builder: (context, value, _) {
                final text = value.text;
                final lineCount = text.isEmpty ? 0 : text.split('\n').length;
                return Row(
                  children: [
                    Text(
                      '$lineCount lines',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: AxiomColors.grey1,
                      ),
                    ),
                    const SizedBox(width: AxiomSpacing.sm + 2),
                    Text(
                      '${text.length} chars',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: AxiomColors.grey1,
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
    // Everforest styled quote with purple accent
    return BlockEditorCard(
      blockType: 'Quote',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: AxiomColors.purple, width: 4)),
        ),
        padding: const EdgeInsets.only(left: AxiomSpacing.sm + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 2,
              style: AxiomTypography.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                color: AxiomColors.fg,
              ),
              decoration: InputDecoration(
                hintText: 'Enter quote...',
                hintStyle: AxiomTypography.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AxiomColors.grey1,
                ),
                border: InputBorder.none,
              ),
              onChanged: widget.onContentChanged,
            ),
            TextField(
              controller: _attributionController,
              maxLines: 1,
              style: AxiomTypography.bodySmall.copyWith(
                color: AxiomColors.grey0,
              ),
              decoration: InputDecoration(
                hintText: '— Attribution (optional)',
                hintStyle: AxiomTypography.bodySmall.copyWith(
                  color: AxiomColors.grey1,
                ),
                border: InputBorder.none,
                prefixText: _attributionController.text.isEmpty ? null : '— ',
                prefixStyle: AxiomTypography.bodySmall.copyWith(
                  color: AxiomColors.grey0,
                ),
                isDense: true,
              ),
              onChanged: widget.onAttributionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
