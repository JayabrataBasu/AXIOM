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
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import '../../models/models.dart';

/// Enum representing the available block types for the add block menu.
enum BlockType {
  text(Icons.text_fields, 'Text', 'Plain text content'),
  heading(Icons.title, 'Heading', 'Section header'),
  bulletList(Icons.format_list_bulleted, 'Bullet List', 'Unordered list'),
  code(Icons.code, 'Code', 'Code snippet'),
  quote(Icons.format_quote, 'Quote', 'Citation or callout'),
  sketch(Icons.gesture, 'Sketch', 'Freehand drawing'),
  math(Icons.functions, 'Math', 'LaTeX expression'),
  audio(Icons.mic, 'Audio', 'Voice recording'),
  workspaceRef(Icons.widgets, 'Workspace', 'Link to workspace session');

  const BlockType(this.icon, this.label, this.description);
  final IconData icon;
  final String label;
  final String description;
}

/// Dialog to select a block type when adding a new block.
class BlockTypeSelector extends StatelessWidget {
  const BlockTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Add Block'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: BlockType.values.length,
          itemBuilder: (context, index) {
            final type = BlockType.values[index];
            return ListTile(
              leading: Icon(type.icon, color: theme.colorScheme.primary),
              title: Text(type.label),
              subtitle: Text(
                type.description,
                style: theme.textTheme.bodySmall,
              ),
              onTap: () => Navigator.of(context).pop(type),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Base card wrapper for block editors.
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
        title: const Text('Delete Block?'),
        content: Text(
          'Delete this ${widget.blockType.toLowerCase()} block? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                // Block type badge
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.blockType.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 8),
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
                    color: theme.colorScheme.error.withValues(alpha: 0.7),
                    hoverColor: theme.colorScheme.error.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          // Block content
          Padding(padding: const EdgeInsets.all(12), child: widget.child),
        ],
      ),
    );
  }
}

/// Editor for TextBlock.
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
    final theme = Theme.of(context);

    return BlockEditorCard(
      blockType: 'Text',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text field
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 3,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter text content...',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
              isDense: true,
            ),
            onChanged: widget.onContentChanged,
          ),
          // Character count
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) => Text(
                '${value.text.length} characters',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
    final theme = Theme.of(context);

    return BlockEditorCard(
      blockType: 'H${widget.block.level}',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      trailing: SegmentedButton<int>(
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
        ),
      ),
      child: TextField(
        controller: _controller,
        maxLines: 1,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: switch (widget.block.level) {
            1 => 24.0,
            2 => 20.0,
            _ => 18.0,
          },
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          hintText: 'Heading...',
          border: InputBorder.none,
        ),
        onChanged: widget.onContentChanged,
      ),
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
    final theme = Theme.of(context);

    return BlockEditorCard(
      blockType: 'List',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Column(
        children: [
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        hintText: 'List item...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        suffixIcon: _controllers.length > 1
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 16),
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
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add item'),
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
    final theme = Theme.of(context);

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
        items: _commonLanguages.map((lang) {
          return DropdownMenuItem(
            value: lang,
            child: Text(lang.isEmpty ? 'Plain' : lang),
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
          // Language info badge
          if (widget.block.language.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.block.language.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Code editor with monospace font
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Stack(
              children: [
                CodeTheme(
                  data: CodeThemeData(
                    styles: theme.brightness == Brightness.dark
                        ? monokaiSublimeTheme
                        : githubTheme,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CodeField(
                      controller: _codeController,
                      maxLines: null,
                      minLines: 5,
                      textStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
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
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '// Enter code here...',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                            fontFamily: 'monospace',
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
            padding: const EdgeInsets.only(top: 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _codeController,
              builder: (context, value, _) {
                final text = value.text;
                final lineCount = text.isEmpty ? 0 : text.split('\n').length;
                return Row(
                  children: [
                    Text(
                      '$lineCount lines',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${text.length} chars',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
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
    final theme = Theme.of(context);

    return BlockEditorCard(
      blockType: 'Quote',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 4),
          ),
        ),
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 2,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter quote...',
                border: InputBorder.none,
              ),
              onChanged: widget.onContentChanged,
            ),
            TextField(
              controller: _attributionController,
              maxLines: 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              decoration: InputDecoration(
                hintText: '— Attribution (optional)',
                border: InputBorder.none,
                prefixText: _attributionController.text.isEmpty ? null : '— ',
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
