import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${node.id.substring(0, 8)}...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Position: (${node.position.x.toInt()}, ${node.position.y.toInt()})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Block list
              Expanded(
                child: node.blocks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.note_add_outlined,
                              size: 48,
                              color: theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No blocks yet',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _addTextBlock(node),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Text Block'),
                            ),
                          ],
                        ),
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: node.blocks.length,
                        onReorder: (oldIndex, newIndex) {
                          _reorderBlocks(node, oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final block = node.blocks[index];
                          return _BlockEditor(
                            key: ValueKey(block.id),
                            node: node,
                            block: block,
                            onContentChanged: (content) {
                              _updateBlockContent(node, block.id, content);
                            },
                            onDelete: () => _deleteBlock(node, block.id),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: node.blocks.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => _addTextBlock(node),
                  tooltip: 'Add block',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  void _addTextBlock(IdeaNode node) {
    ref.read(nodesNotifierProvider.notifier).addTextBlock(node.id);
  }

  void _updateBlockContent(IdeaNode node, String blockId, String content) {
    // Debounce saves
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(nodesNotifierProvider.notifier).updateBlockContent(
            node.id,
            blockId,
            content,
          );
    });
  }

  void _deleteBlock(IdeaNode node, String blockId) {
    ref.read(nodesNotifierProvider.notifier).deleteBlock(node.id, blockId);
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

/// Editor widget for a single content block.
class _BlockEditor extends StatefulWidget {
  const _BlockEditor({
    super.key,
    required this.node,
    required this.block,
    required this.onContentChanged,
    required this.onDelete,
  });

  final IdeaNode node;
  final ContentBlock block;
  final ValueChanged<String> onContentChanged;
  final VoidCallback onDelete;

  @override
  State<_BlockEditor> createState() => _BlockEditorState();
}

class _BlockEditorState extends State<_BlockEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final content = switch (widget.block) {
      TextBlock(:final content) => content,
    };
    _controller = TextEditingController(text: content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_BlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.id != widget.block.id) {
      final content = switch (widget.block) {
        TextBlock(:final content) => content,
      };
      _controller.text = content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: widget.node.blocks.indexOf(widget.block),
                  child: const Icon(Icons.drag_handle, size: 20),
                ),
                const SizedBox(width: 8),
                // Block type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _blockTypeName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: widget.onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Delete block',
                ),
              ],
            ),
          ),
          // Block content
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildBlockContent(theme),
          ),
        ],
      ),
    );
  }

  String get _blockTypeName {
    return switch (widget.block) {
      TextBlock() => 'TEXT',
    };
  }

  Widget _buildBlockContent(ThemeData theme) {
    return switch (widget.block) {
      TextBlock() => TextField(
          controller: _controller,
          maxLines: null,
          minLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter text...',
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onContentChanged,
        ),
    };
  }
}
