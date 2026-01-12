import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// Full-screen editor for an IdeaNode.
class NodeEditorScreen extends ConsumerStatefulWidget {
  const NodeEditorScreen({
    super.key,
    required this.nodeId,
  });

  final String nodeId;

  @override
  ConsumerState<NodeEditorScreen> createState() => _NodeEditorScreenState();
}

class _NodeEditorScreenState extends ConsumerState<NodeEditorScreen> {
  Timer? _saveDebounce;

  @override
  void dispose() {
    _saveDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final theme = Theme.of(context);

    return nodesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (nodes) {
        final node = nodes.where((n) => n.id == widget.nodeId).firstOrNull;
        if (node == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Node Not Found')),
            body: const Center(child: Text('This node no longer exists.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Node'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete node',
                onPressed: () => _confirmDelete(node),
              ),
            ],
          ),
          body: Column(
            children: [
              // Node info header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${node.id.substring(0, 8)}...',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'monospace',
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Position: (${node.position.x.toInt()}, ${node.position.y.toInt()})',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${node.blocks.length} block${node.blocks.length != 1 ? 's' : ''}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Block list
              Expanded(
                child: node.blocks.isEmpty
                    ? _buildEmptyState(theme, node)
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: node.blocks.length,
                        onReorder: (oldIndex, newIndex) {
                          _reorderBlocks(node, oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final block = node.blocks[index];
                          return _buildBlockEditor(node, block, index);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddBlockDialog(node),
            tooltip: 'Add block',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, IdeaNode node) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No blocks yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddBlockDialog(node),
            icon: const Icon(Icons.add),
            label: const Text('Add Block'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockEditor(IdeaNode node, ContentBlock block, int index) {
    return switch (block) {
      TextBlock() => TextBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onContentChanged: (content) => _updateBlockContent(node.id, block.id, content),
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
      HeadingBlock() => HeadingBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onContentChanged: (content) => _updateBlockContent(node.id, block.id, content),
          onLevelChanged: (level) => _updateHeadingLevel(node.id, block.id, level),
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
      BulletListBlock() => BulletListBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onItemsChanged: (items) => _updateBulletListItems(node.id, block.id, items),
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
      CodeBlock() => CodeBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onContentChanged: (content) => _updateBlockContent(node.id, block.id, content),
          onLanguageChanged: (lang) => _updateCodeLanguage(node.id, block.id, lang),
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
      QuoteBlock() => QuoteBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onContentChanged: (content) => _updateBlockContent(node.id, block.id, content),
          onAttributionChanged: (attr) => _updateQuoteAttribution(node.id, block.id, attr),
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
    };
  }

  Future<void> _showAddBlockDialog(IdeaNode node) async {
    final blockType = await showDialog<BlockType>(
      context: context,
      builder: (context) => const BlockTypeSelector(),
    );

    if (blockType == null) return;

    final notifier = ref.read(nodesNotifierProvider.notifier);
    switch (blockType) {
      case BlockType.text:
        notifier.addTextBlock(node.id);
      case BlockType.heading:
        notifier.addHeadingBlock(node.id);
      case BlockType.bulletList:
        notifier.addBulletListBlock(node.id);
      case BlockType.code:
        notifier.addCodeBlock(node.id);
      case BlockType.quote:
        notifier.addQuoteBlock(node.id);
    }
  }

  void _updateBlockContent(String nodeId, String blockId, String content) {
    // Debounce saves
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(nodesNotifierProvider.notifier).updateBlockContent(nodeId, blockId, content);
    });
  }

  void _updateHeadingLevel(String nodeId, String blockId, int level) {
    ref.read(nodesNotifierProvider.notifier).updateHeadingLevel(nodeId, blockId, level);
  }

  void _updateBulletListItems(String nodeId, String blockId, List<String> items) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(nodesNotifierProvider.notifier).updateBulletListItems(nodeId, blockId, items);
    });
  }

  void _updateCodeLanguage(String nodeId, String blockId, String language) {
    ref.read(nodesNotifierProvider.notifier).updateCodeLanguage(nodeId, blockId, language);
  }

  void _updateQuoteAttribution(String nodeId, String blockId, String attribution) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(nodesNotifierProvider.notifier).updateQuoteAttribution(nodeId, blockId, attribution);
    });
  }

  void _deleteBlock(String nodeId, String blockId) {
    ref.read(nodesNotifierProvider.notifier).deleteBlock(nodeId, blockId);
  }

  void _reorderBlocks(IdeaNode node, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final blocks = List<ContentBlock>.from(node.blocks);
    final block = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, block);
    
    final updated = node.copyWith(blocks: blocks);
    ref.read(nodesNotifierProvider.notifier).updateNode(updated);
  }

  Future<void> _confirmDelete(IdeaNode node) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Node?'),
        content: const Text('This will permanently delete this node and all its content.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(nodesNotifierProvider.notifier).deleteNode(node.id);
      if (mounted) Navigator.pop(context);
    }
  }
}
