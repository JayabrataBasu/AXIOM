import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../widgets/blocks/sketch_block_editor.dart';
import '../widgets/blocks/math_block_editor.dart';
import '../widgets/blocks/audio_block_editor.dart';

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
                icon: const Icon(Icons.add_link),
                tooltip: 'Add link',
                onPressed: () => _showAddLinkDialog(node),
              ),
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
              // Links section
              if (node.links.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    border: Border(
                      bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Linked to ${node.links.length} node${node.links.length != 1 ? 's' : ''}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: node.links.map((link) {
                          final targetNode = nodes.firstWhereOrNull((n) => n.id == link.targetNodeId);
                          final label = link.label.isNotEmpty
                              ? link.label
                              : (targetNode != null && targetNode.previewText.isNotEmpty
                                  ? targetNode.previewText
                                  : 'Node ${link.targetNodeId.substring(0, 6)}...');

                          return InputChip(
                            avatar: const Icon(Icons.arrow_forward, size: 16),
                            label: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {
                              // Navigate to linked node
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NodeEditorScreen(nodeId: link.targetNodeId),
                                ),
                              );
                            },
                            onDeleted: () => _removeLink(node.id, link.targetNodeId),
                          );
                        }).toList(),
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
      SketchBlock() => SketchBlockEditor(
          key: ValueKey(block.id),
          block: block,
          dragIndex: index,
          onDelete: () => _deleteBlock(node.id, block.id),
        ),
      MathBlock() => BlockEditorCard(
          blockType: 'Math',
          dragIndex: index,
          onDelete: () => _deleteBlock(node.id, block.id),
          child: MathBlockEditor(
            latex: block.latex,
            onChanged: (latex) => _updateBlockLatex(node.id, block.id, latex),
          ),
        ),
      AudioBlock() => BlockEditorCard(
          blockType: 'Audio',
          dragIndex: index,
          onDelete: () => _deleteBlock(node.id, block.id),
          child: AudioBlockEditor(
            audioFile: block.audioFile,
            durationMs: block.durationMs,
          ),
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
      case BlockType.sketch:
        notifier.addSketchBlock(node.id);
      case BlockType.math:
        notifier.addMathBlock(node.id);
      case BlockType.audio:
        // TODO: Implement audio recording UI
        // For now, create a placeholder audio block
        notifier.addAudioBlock(node.id, audioFile: '', durationMs: 0);
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

  void _updateBlockLatex(String nodeId, String blockId, String latex) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(nodesNotifierProvider.notifier).updateBlockLatex(nodeId, blockId, latex);
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

  Future<void> _showAddLinkDialog(IdeaNode node) async {
    final nodesAsync = ref.read(nodesNotifierProvider);
    final allNodes = nodesAsync.valueOrNull ?? [];
    
    // Filter out current node and already linked nodes
    final availableNodes = allNodes.where((n) {
      return n.id != node.id && !node.links.any((link) => link.targetNodeId == n.id);
    }).toList();

    if (availableNodes.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No other nodes available to link')),
        );
      }
      return;
    }

    final selected = await showDialog<IdeaNode>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link to Node'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableNodes.length,
            itemBuilder: (context, index) {
              final targetNode = availableNodes[index];
              return ListTile(
                leading: const Icon(Icons.note_outlined),
                title: Text(
                  targetNode.previewText.isEmpty
                      ? 'Node ${targetNode.id.substring(0, 8)}...'
                      : targetNode.previewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${targetNode.blocks.length} blocks • ${targetNode.links.length} links',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => Navigator.of(context).pop(targetNode),
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
      ),
    );

    if (selected != null) {
      // Optionally prompt for label
      final label = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Link Label (optional)'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'e.g., "related to", "depends on"',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, ''),
                child: const Text('Skip'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Add'),
              ),
            ],
          );
        },
      );

      if (label != null) {
        await ref.read(nodesNotifierProvider.notifier).addLink(
              node.id,
              selected.id,
              label: label,
            );
      }
    }
  }

  void _removeLink(String nodeId, String targetNodeId) {
    ref.read(nodesNotifierProvider.notifier).removeLink(nodeId, targetNodeId);
  }
}
