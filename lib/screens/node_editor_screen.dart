import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../theme/design_tokens.dart';
import '../widgets/widgets.dart';

/// Full-screen editor for an IdeaNode.
/// Theme-aware: uses colorScheme for all surfaces/accents.
class NodeEditorScreen extends ConsumerStatefulWidget {
  const NodeEditorScreen({
    super.key,
    required this.nodeId,
    this.highlightBlockId,
  });

  final String nodeId;
  final String? highlightBlockId;

  @override
  ConsumerState<NodeEditorScreen> createState() => _NodeEditorScreenState();
}

class _NodeEditorScreenState extends ConsumerState<NodeEditorScreen> {
  Timer? _saveDebounce;
  Timer? _nameDebounce;
  late TextEditingController _nodeNameController;
  late FocusNode _nodeNameFocusNode;
  String? _activeNodeId;
  String? _highlightedBlockId;
  Timer? _highlightFadeTimer;

  @override
  void initState() {
    super.initState();
    _nodeNameController = TextEditingController();
    _nodeNameFocusNode = FocusNode();
    _highlightedBlockId = widget.highlightBlockId;

    // Start fade-out timer for highlight (visible for 3 seconds)
    if (_highlightedBlockId != null) {
      _highlightFadeTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _highlightedBlockId = null;
          });
        }
      });
    } else {
      _highlightFadeTimer = null;
    }
  }

  @override
  void didUpdateWidget(NodeEditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the highlightBlockId changed (e.g., user tapped another search result), restart highlight
    if (oldWidget.highlightBlockId != widget.highlightBlockId &&
        widget.highlightBlockId != null) {
      _highlightFadeTimer?.cancel();
      setState(() {
        _highlightedBlockId = widget.highlightBlockId;
      });

      // Restart fade-out timer
      _highlightFadeTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _highlightedBlockId = null;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _nameDebounce?.cancel();
    _nodeNameController.dispose();
    _nodeNameFocusNode.dispose();
    _highlightFadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return nodesAsync.when(
      loading: () => Scaffold(
        backgroundColor: cs.surface,
        body: Center(
          child: CircularProgressIndicator(color: cs.primary),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text('Error', style: TextStyle(color: cs.onSurface)),
          backgroundColor: cs.surface,
        ),
        body: Center(
          child: Text('Error: $error', style: TextStyle(color: cs.onSurface)),
        ),
      ),
      data: (nodes) {
        final node = _findNode(nodes, widget.nodeId);
        if (node == null) {
          return Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              title: Text(
                'Node Not Found',
                style: TextStyle(color: cs.onSurface),
              ),
              backgroundColor: cs.surface,
            ),
            body: Center(
              child: Text(
                'This node no longer exists.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          );
        }

        _syncNodeNameController(node);

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: cs.surface,
            title: Text('Edit Node', style: TextStyle(color: cs.onSurface)),
            elevation: 0,
            iconTheme: IconThemeData(color: cs.onSurface),
            actions: [
              IconButton(
                icon: Icon(Icons.add_link_rounded, color: cs.secondary),
                tooltip: 'Add link',
                onPressed: () => _showAddLinkDialog(node),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                tooltip: 'Delete node',
                onPressed: () => _confirmDelete(node),
              ),
            ],
          ),
          body: Column(
            children: [
              // Node name editing header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AxiomSpacing.md),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(color: cs.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node name (editable)
                    TextField(
                      controller: _nodeNameController,
                      focusNode: _nodeNameFocusNode,
                      onChanged: (name) =>
                          _updateNodeNameDebounced(node.id, name),
                      onSubmitted: (name) => _updateNodeName(node.id, name),
                      textInputAction: TextInputAction.done,
                      style: AxiomTypography.heading2.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Untitled Node',
                        hintStyle: AxiomTypography.heading2.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(150),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.sm),
                    // Node metadata (scrollable to handle long content)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            'ID: ${node.id.substring(0, 8)}...',
                            style: AxiomTypography.labelSmall.copyWith(
                              fontFamily: 'monospace',
                              color: cs.onSurfaceVariant.withAlpha(150),
                            ),
                          ),
                          const SizedBox(width: AxiomSpacing.md),
                          Text(
                            'Pos: (${node.position.x.toInt()}, ${node.position.y.toInt()})',
                            style: AxiomTypography.labelSmall.copyWith(
                              color: cs.onSurfaceVariant.withAlpha(150),
                            ),
                          ),
                          const SizedBox(width: AxiomSpacing.md),
                          Text(
                            '${node.blocks.length} block${node.blocks.length != 1 ? 's' : ''}',
                            style: AxiomTypography.labelSmall.copyWith(
                              color: cs.onSurfaceVariant.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Links section
              if (node.links.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AxiomSpacing.md),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    border: Border(
                      bottom: BorderSide(color: cs.outlineVariant),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.link_rounded, size: 16, color: cs.secondary),
                          const SizedBox(width: AxiomSpacing.sm),
                          Text(
                            'Linked to ${node.links.length} node${node.links.length != 1 ? 's' : ''}',
                            style: AxiomTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AxiomSpacing.sm),
                      Wrap(
                        spacing: AxiomSpacing.sm,
                        runSpacing: AxiomSpacing.sm,
                        children: node.links.map((link) {
                          final targetNode = _findNode(
                            nodes,
                            link.targetNodeId,
                          );
                          final label = link.label.isNotEmpty
                              ? link.label
                              : (targetNode != null &&
                                        targetNode.previewText.isNotEmpty
                                    ? targetNode.previewText
                                    : 'Node ${link.targetNodeId.substring(0, 6)}...');

                          return InputChip(
                            backgroundColor: cs.surfaceContainer,
                            avatar: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: cs.secondary,
                            ),
                            label: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: cs.onSurface),
                            ),
                            onPressed: () {
                              // Navigate to linked node
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NodeEditorScreen(
                                    nodeId: link.targetNodeId,
                                  ),
                                ),
                              );
                            },
                            onDeleted: () =>
                                _removeLink(node.id, link.targetNodeId),
                            deleteIconColor: cs.error.withAlpha(180),
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
                        padding: const EdgeInsets.all(AxiomSpacing.md),
                        itemCount: node.blocks.length,
                        buildDefaultDragHandles: false,
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
            backgroundColor: cs.primary,
            foregroundColor: cs.surface,
            onPressed: () => _showAddBlockDialog(node),
            tooltip: 'Add block',
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, IdeaNode node) {
    final cs = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_add_rounded, size: 48, color: cs.onSurfaceVariant.withAlpha(150)),
          const SizedBox(height: AxiomSpacing.md),
          Text(
            'No blocks yet',
            style: AxiomTypography.bodyLarge.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AxiomSpacing.md),
          FilledButton.icon(
            onPressed: () => _showAddBlockDialog(node),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Block'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockEditor(IdeaNode node, ContentBlock block, int index) {
    final isHighlighted = _highlightedBlockId == block.id;

    final editor = switch (block) {
      TextBlock() => TextBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onContentChanged: (content) =>
            _updateBlockContent(node.id, block.id, content),
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      HeadingBlock() => HeadingBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onContentChanged: (content) =>
            _updateBlockContent(node.id, block.id, content),
        onLevelChanged: (level) =>
            _updateHeadingLevel(node.id, block.id, level),
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      BulletListBlock() => BulletListBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onItemsChanged: (items) =>
            _updateBulletListItems(node.id, block.id, items),
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      CodeBlock() => CodeBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onContentChanged: (content) =>
            _updateBlockContent(node.id, block.id, content),
        onLanguageChanged: (lang) =>
            _updateCodeLanguage(node.id, block.id, lang),
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      QuoteBlock() => QuoteBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onContentChanged: (content) =>
            _updateBlockContent(node.id, block.id, content),
        onAttributionChanged: (attr) =>
            _updateQuoteAttribution(node.id, block.id, attr),
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      SketchBlock() => SketchBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
      ),
      MathBlock() => BlockEditorCard(
        key: ValueKey(block.id),
        blockType: 'Math',
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        child: MathBlockEditor(
          latex: block.latex,
          onChanged: (latex) => _updateBlockLatex(node.id, block.id, latex),
        ),
      ),
      AudioBlock() => BlockEditorCard(
        key: ValueKey(block.id),
        blockType: 'Audio',
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        child: AudioBlockEditor(
          audioFile: block.audioFile,
          durationMs: block.durationMs,
        ),
      ),
      WorkspaceRefBlock() => BlockEditorCard(
        key: ValueKey(block.id),
        blockType: 'Workspace',
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        child: WorkspaceRefBlockDisplay(
          sessionId: block.sessionId,
          label: block.label,
        ),
      ),
      ToolBlock() => BlockEditorCard(
        key: ValueKey(block.id),
        blockType: 'Tool',
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        child: const Text('Tool Block (Coming Soon)'),
      ),
    };

    // Wrap with highlight decoration if this block is highlighted
    if (isHighlighted) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AxiomColors.yellow, width: 3),
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        child: editor,
      );
    }

    return editor;
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
        break;
      case BlockType.heading:
        notifier.addHeadingBlock(node.id);
        break;
      case BlockType.bulletList:
        notifier.addBulletListBlock(node.id);
        break;
      case BlockType.code:
        notifier.addCodeBlock(node.id);
        break;
      case BlockType.quote:
        notifier.addQuoteBlock(node.id);
        break;
      case BlockType.sketch:
        notifier.addSketchBlock(node.id);
        break;
      case BlockType.math:
        notifier.addMathBlock(node.id);
        break;
      case BlockType.audio:
        await _recordAndAddAudio(node, notifier);
        break;
      case BlockType.workspaceRef:
        await _addWorkspaceRefBlock(node);
        break;
    }
  }

  Future<void> _recordAndAddAudio(IdeaNode node, NodesNotifier notifier) async {
    final result = await showDialog<AudioRecordingResult>(
      context: context,
      builder: (context) => const AudioRecorderDialog(),
    );

    if (result != null && mounted) {
      await notifier.addAudioBlock(
        node.id,
        audioFile: result.filePath,
        durationMs: result.durationMs,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Audio block added')));
    }
  }

  Future<void> _addWorkspaceRefBlock(IdeaNode node) async {
    // Load existing sessions (matrix workspace only for now)
    final sessions = await ref.read(workspaceSessionsProvider.future);
    final matrixSessions = sessions
        .where((s) => s.workspaceType == 'matrix_calculator')
        .toList();

    if (!mounted) return;

    final result = await showDialog<_WorkspaceSessionChoice?>(
      context: context,
      builder: (context) {
        final labelController = TextEditingController();

        return AlertDialog(
          title: const Text('Workspace Session'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (matrixSessions.isNotEmpty) ...[
                  Text(
                    'Existing sessions',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: matrixSessions.length,
                      itemBuilder: (context, index) {
                        final session = matrixSessions[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.widgets_rounded),
                          title: Text(
                            session.label.isNotEmpty
                                ? session.label
                                : session.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Created ${session.createdAt.toLocal().toIso8601String().split('T').first}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () => Navigator.pop(
                            context,
                            _WorkspaceSessionChoice(session.id, session.label),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 24),
                ],
                Text(
                  'Create new matrix workspace',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(
                    labelText: 'Label (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                final label = labelController.text.trim();
                Navigator.pop(
                  context,
                  _WorkspaceSessionChoice('__create__', label),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (result == null) return;

    final workspaceNotifier = ref.read(
      workspaceSessionsNotifierProvider.notifier,
    );
    final nodesNotifier = ref.read(nodesNotifierProvider.notifier);

    // Create session if requested
    String sessionId = result.sessionId;
    String label = result.label;

    if (result.sessionId == '__create__') {
      final data = MatrixCalculatorData().toJson();
      final session = await workspaceNotifier.createSession(
        workspaceType: 'matrix_calculator',
        data: data,
        label: label,
      );
      sessionId = session.id;
      label = session.label;
    }

    await nodesNotifier.addWorkspaceRefBlock(
      node.id,
      sessionId: sessionId,
      label: label,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Workspace reference added')));
  }

  void _updateBlockContent(String nodeId, String blockId, String content) {
    // Debounce saves
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(nodesNotifierProvider.notifier)
          .updateBlockContent(nodeId, blockId, content);
    });
  }

  void _updateHeadingLevel(String nodeId, String blockId, int level) {
    ref
        .read(nodesNotifierProvider.notifier)
        .updateHeadingLevel(nodeId, blockId, level);
  }

  void _updateBulletListItems(
    String nodeId,
    String blockId,
    List<String> items,
  ) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(nodesNotifierProvider.notifier)
          .updateBulletListItems(nodeId, blockId, items);
    });
  }

  void _updateCodeLanguage(String nodeId, String blockId, String language) {
    ref
        .read(nodesNotifierProvider.notifier)
        .updateCodeLanguage(nodeId, blockId, language);
  }

  void _updateQuoteAttribution(
    String nodeId,
    String blockId,
    String attribution,
  ) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(nodesNotifierProvider.notifier)
          .updateQuoteAttribution(nodeId, blockId, attribution);
    });
  }

  void _updateBlockLatex(String nodeId, String blockId, String latex) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(nodesNotifierProvider.notifier)
          .updateBlockLatex(nodeId, blockId, latex);
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
        content: const Text(
          'This will permanently delete this node and all its content.',
        ),
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
      return n.id != node.id &&
          !node.links.any((link) => link.targetNodeId == n.id);
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
                leading: const Icon(Icons.note_rounded),
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

    if (!mounted) return;

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

      if (!mounted) return;

      if (label != null) {
        await ref
            .read(nodesNotifierProvider.notifier)
            .addLink(node.id, selected.id, label: label);
      }
    }
  }

  void _removeLink(String nodeId, String targetNodeId) {
    ref.read(nodesNotifierProvider.notifier).removeLink(nodeId, targetNodeId);
  }

  void _syncNodeNameController(IdeaNode node) {
    if (_activeNodeId != node.id) {
      _activeNodeId = node.id;
      _nodeNameController.text = node.name;
      return;
    }

    if (!_nodeNameFocusNode.hasFocus && _nodeNameController.text != node.name) {
      _nodeNameController.text = node.name;
    }
  }

  void _updateNodeNameDebounced(String nodeId, String newName) {
    _nameDebounce?.cancel();
    _nameDebounce = Timer(const Duration(milliseconds: 400), () {
      _updateNodeName(nodeId, newName);
    });
  }

  Future<void> _updateNodeName(String nodeId, String newName) async {
    if (newName.isEmpty || newName.trim().isEmpty) return;

    final notifier = ref.read(nodesNotifierProvider.notifier);
    final nodes = ref.read(nodesProvider).value ?? [];
    final node = _findNode(nodes, nodeId);

    if (node != null) {
      final updatedNode = node.copyWith(name: newName.trim());
      await notifier.updateNode(updatedNode);
    }
  }

  IdeaNode? _findNode(List<IdeaNode> nodes, String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
    }
    return null;
  }
}

class _WorkspaceSessionChoice {
  const _WorkspaceSessionChoice(this.sessionId, this.label);
  final String sessionId;
  final String label;
}
