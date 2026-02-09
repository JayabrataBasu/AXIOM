import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/file_service.dart';

/// Temporary debug screen to test persistence (Stage 1).
/// This will be replaced by the canvas in Stage 2.
class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Axiom - Debug Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Show data directory',
            onPressed: () => _showDataDirectory(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from disk',
            onPressed: () {
              ref.read(nodesNotifierProvider.notifier).reload();
            },
          ),
        ],
      ),
      body: nodesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(nodesNotifierProvider.notifier).reload();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (nodes) => _buildNodesList(context, ref, nodes),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNode(ref),
        icon: const Icon(Icons.add),
        label: const Text('New Node'),
      ),
    );
  }

  Widget _buildNodesList(
    BuildContext context,
    WidgetRef ref,
    List<IdeaNode> nodes,
  ) {
    if (nodes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.note_add_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No nodes yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to create your first IdeaNode',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        return _NodeCard(node: node);
      },
    );
  }

  Future<void> _createNode(WidgetRef ref) async {
    await ref.read(nodesNotifierProvider.notifier).createNode();
  }

  Future<void> _showDataDirectory(BuildContext context) async {
    final rootDir = await FileService.instance.rootDirectory;
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Directory'),
        content: SelectableText(rootDir.path),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NodeCard extends ConsumerStatefulWidget {
  const _NodeCard({required this.node});

  final IdeaNode node;

  @override
  ConsumerState<_NodeCard> createState() => _NodeCardState();
}

class _NodeCardState extends ConsumerState<_NodeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final node = widget.node;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '${node.blocks.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              node.previewText.isEmpty ? '(empty node)' : node.previewText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'ID: ${node.id.substring(0, 8)}... | '
              'Pos: (${node.position.x.toInt()}, ${node.position.y.toInt()})',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteNode(node.id),
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Created', node.createdAt.toString()),
                  _buildInfoRow('Updated', node.updatedAt.toString()),
                  _buildInfoRow(
                    'Position',
                    '(${node.position.x}, ${node.position.y})',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Blocks:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...node.blocks.map((block) => _buildBlockEditor(node, block)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _addTextBlock(node.id),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Text Block'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockEditor(IdeaNode node, ContentBlock block) {
    final (typeName, typeColor, content) = switch (block) {
      TextBlock(:final content) => ('TEXT', Colors.blue, content),
      HeadingBlock(:final content, :final level) => (
        'H$level',
        Colors.purple,
        content,
      ),
      BulletListBlock(:final items) => ('LIST', Colors.green, items.join('\n')),
      CodeBlock(:final content, :final language) => (
        'CODE${language.isNotEmpty ? ' ($language)' : ''}',
        Colors.orange,
        content,
      ),
      QuoteBlock(:final content) => ('QUOTE', Colors.teal, content),
      SketchBlock() => ('SKETCH', Colors.deepOrange, '[drawing]'),
      MathBlock(:final latex) => ('MATH', Colors.indigo, latex),
      AudioBlock(:final durationMs) => (
        'AUDIO',
        Colors.cyan,
        '${(durationMs / 1000).toStringAsFixed(1)}s',
      ),
      WorkspaceRefBlock(:final label, :final sessionId) => (
        'WORKSPACE',
        Colors.lime,
        label.isNotEmpty ? label : 'Session: ${sessionId.substring(0, 6)}...',
      ),
      MindMapRefBlock(:final label, :final mapId) => (
        'MINDMAP',
        Colors.purple,
        label.isNotEmpty ? label : 'Map: ${mapId.substring(0, 6)}...',
      ),
      ToolBlock(:final toolType) => ('TOOL', Colors.pink, toolType),
    };

    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    typeName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${block.id.substring(0, 8)}...',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => _deleteBlock(node.id, block.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: content,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter text...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) =>
                  _updateBlockContent(node.id, block.id, value),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteNode(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Node?'),
        content: const Text('This action cannot be undone.'),
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

    if (confirmed == true) {
      await ref.read(nodesNotifierProvider.notifier).deleteNode(id);
    }
  }

  Future<void> _addTextBlock(String nodeId) async {
    await ref.read(nodesNotifierProvider.notifier).addTextBlock(nodeId);
  }

  Future<void> _updateBlockContent(
    String nodeId,
    String blockId,
    String content,
  ) async {
    await ref
        .read(nodesNotifierProvider.notifier)
        .updateBlockContent(nodeId, blockId, content);
  }

  Future<void> _deleteBlock(String nodeId, String blockId) async {
    await ref.read(nodesNotifierProvider.notifier).deleteBlock(nodeId, blockId);
  }
}
