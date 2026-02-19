import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../services/maths_service.dart';
import '../services/mind_map_service.dart';
import '../services/preferences_service.dart';
import '../models/maths.dart';
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
  late BlockCollapseController _blockCollapseController;
  String? _collapseStateNodeId;
  String? _activeNodeId;
  String? _highlightedBlockId;
  Timer? _highlightFadeTimer;

  // Text editor mode: 'markdown', 'simple', or 'rich'
  // Text editor is now always RichTextBlockEditor

  @override
  void initState() {
    super.initState();
    _nodeNameController = TextEditingController();
    _nodeNameFocusNode = FocusNode();
    _blockCollapseController = BlockCollapseController();
    _blockCollapseController.addListener(_onCollapsedStateChanged);
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
    _blockCollapseController.removeListener(_onCollapsedStateChanged);
    _blockCollapseController.dispose();
    _highlightFadeTimer?.cancel();
    super.dispose();
  }

  String _collapsedBlocksPrefsKey(String nodeId) =>
      'node_collapsed_blocks:$nodeId';

  Future<void> _loadCollapsedStateForNode(String nodeId) async {
    final raw = await PreferencesService.instance.getString(
      _collapsedBlocksPrefsKey(nodeId),
    );
    if (!mounted || _collapseStateNodeId != nodeId) return;

    if (raw == null || raw.isEmpty) {
      _blockCollapseController.setCollapsedBlocks(<String>{});
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _blockCollapseController.setCollapsedBlocks(
          decoded.whereType<String>().toSet(),
        );
      } else {
        _blockCollapseController.setCollapsedBlocks(<String>{});
      }
    } catch (_) {
      _blockCollapseController.setCollapsedBlocks(<String>{});
    }
  }

  void _ensureCollapseStateForNode(IdeaNode node) {
    if (_collapseStateNodeId == node.id) return;
    _collapseStateNodeId = node.id;
    unawaited(_loadCollapsedStateForNode(node.id));
  }

  void _onCollapsedStateChanged() {
    final nodeId = _collapseStateNodeId;
    if (nodeId == null) return;
    final encoded = jsonEncode(
      _blockCollapseController.collapsedBlockIds.toList(),
    );
    unawaited(
      PreferencesService.instance.setString(
        _collapsedBlocksPrefsKey(nodeId),
        encoded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return nodesAsync.when(
      loading: () => Scaffold(
        backgroundColor: cs.surface,
        body: Center(child: CircularProgressIndicator(color: cs.primary)),
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

        _ensureCollapseStateForNode(node);
        _blockCollapseController.pruneTo(node.blocks.map((b) => b.id));

        _syncNodeNameController(node);

        return Scaffold(
          backgroundColor: cs.surface,
          body: Column(
            children: [
              // Stitch-style floating header
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AxiomSpacing.md,
                    vertical: AxiomSpacing.sm,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface.withAlpha(230),
                      borderRadius: BorderRadius.circular(AxiomRadius.full),
                      border: Border.all(
                        color: cs.outlineVariant.withAlpha(40),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withAlpha(10),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Back button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHigh.withAlpha(120),
                            borderRadius: BorderRadius.circular(
                              AxiomRadius.full,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: cs.onSurface,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ),
                        const SizedBox(width: AxiomSpacing.sm),
                        Expanded(
                          child: Text(
                            'Edit Node',
                            style: AxiomTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_link_rounded,
                            color: cs.secondary,
                            size: 20,
                          ),
                          tooltip: 'Add link',
                          onPressed: () => _showAddLinkDialog(node),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.unfold_less_rounded,
                            color: cs.onSurfaceVariant,
                            size: 20,
                          ),
                          tooltip: 'Collapse all blocks',
                          onPressed: node.blocks.isEmpty
                              ? null
                              : () => _blockCollapseController.collapseAll(
                                  node.blocks.map((b) => b.id),
                                ),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.unfold_more_rounded,
                            color: cs.onSurfaceVariant,
                            size: 20,
                          ),
                          tooltip: 'Expand all blocks',
                          onPressed: node.blocks.isEmpty
                              ? null
                              : () => _blockCollapseController.expandAll(),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                        // Text editor mode selector removed - always using RichTextBlockEditor
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: cs.error.withAlpha(180),
                            size: 20,
                          ),
                          tooltip: 'Delete node',
                          onPressed: () => _confirmDelete(node),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Node name editing header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.xl,
                  vertical: AxiomSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  border: Border(
                    bottom: BorderSide(
                      color: cs.outlineVariant.withAlpha(30),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node name (editable) - Stitch-style large title
                    TextField(
                      controller: _nodeNameController,
                      focusNode: _nodeNameFocusNode,
                      onChanged: (name) =>
                          _updateNodeNameDebounced(node.id, name),
                      onSubmitted: (name) => _updateNodeName(node.id, name),
                      textInputAction: TextInputAction.done,
                      style: AxiomTypography.heading1.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Untitled Node',
                        hintStyle: AxiomTypography.heading1.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(100),
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.sm),
                    // Node metadata - styled as subtle badges
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildMetaBadge(
                            Icons.fingerprint_rounded,
                            node.id.substring(0, 8),
                            cs,
                          ),
                          const SizedBox(width: AxiomSpacing.sm),
                          _buildMetaBadge(
                            Icons.grid_4x4_rounded,
                            '(${node.position.x.toInt()}, ${node.position.y.toInt()})',
                            cs,
                          ),
                          const SizedBox(width: AxiomSpacing.sm),
                          _buildMetaBadge(
                            Icons.widgets_rounded,
                            '${node.blocks.length} block${node.blocks.length != 1 ? 's' : ''}',
                            cs,
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
                          Icon(
                            Icons.link_rounded,
                            size: 16,
                            color: cs.secondary,
                          ),
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
                child: BlockCollapseScope(
                  controller: _blockCollapseController,
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
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AxiomRadius.full),
              boxShadow: [
                BoxShadow(
                  color: cs.secondary.withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: cs.secondary,
              foregroundColor: Colors.white,
              onPressed: () => _showAddBlockDialog(node),
              tooltip: 'Add block',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.full),
              ),
              child: const Icon(Icons.add_rounded),
            ),
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
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: cs.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(AxiomRadius.full),
            ),
            child: Icon(Icons.note_add_rounded, size: 36, color: cs.secondary),
          ),
          const SizedBox(height: AxiomSpacing.xl),
          Text(
            'Start building your idea',
            style: AxiomTypography.heading3.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          Text(
            'Add text, code, sketches, math, and more',
            style: AxiomTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant.withAlpha(150),
            ),
          ),
          const SizedBox(height: AxiomSpacing.xl),
          FilledButton.icon(
            onPressed: () => _showAddBlockDialog(node),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Block'),
            style: FilledButton.styleFrom(
              backgroundColor: cs.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.full),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockEditor(IdeaNode node, ContentBlock block, int index) {
    final isHighlighted = _highlightedBlockId == block.id;

    final editor = switch (block) {
      TextBlock() => RichTextBlockEditor(
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
        blockId: block.id,
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
        blockId: block.id,
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
        blockId: block.id,
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
        blockId: block.id,
        blockType: 'Tool',
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        child: const Text('Tool Block (Coming Soon)'),
      ),
      MindMapRefBlock() => MindMapRefBlockEditor(
        key: ValueKey(block.id),
        block: block,
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
        workspaceId: node.workspaceId,
      ),
      MathsRefBlock() => MathsRefBlockEditor(
        key: ValueKey(block.id),
        block: block,
        mathsService: MathsService.instance,
        workspaceId: node.workspaceId,
        dragIndex: index,
        onDelete: () => _deleteBlock(node.id, block.id),
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
    final blockType = await showBlockTypeSelector(context);

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
      case BlockType.mindMapRef:
        await _addMindMapRefBlock(node);
        break;
      case BlockType.mathsRef:
        await _addMathsRefBlock(node);
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

  Future<void> _addMindMapRefBlock(IdeaNode node) async {
    final mindMapService = MindMapService.instance;
    final workspaceId = ref.read(activeWorkspaceIdProvider) ?? node.workspaceId;

    // Load existing mind maps for this workspace
    final mindMaps = await mindMapService.listMindMaps(workspaceId);

    if (!mounted) return;

    final result = await showDialog<_MindMapChoice?>(
      context: context,
      builder: (context) {
        final labelController = TextEditingController();
        String selectedTemplateId = MindMapService.templates.first.id;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Mind Map'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (mindMaps.isNotEmpty) ...[
                      Text(
                        'Existing mind maps',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: mindMaps.length,
                          itemBuilder: (context, index) {
                            final mindMap = mindMaps[index];
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.account_tree),
                              title: Text(
                                mindMap.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${mindMap.nodes.length} nodes • Created ${mindMap.createdAt.toLocal().toIso8601String().split('T').first}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () => Navigator.pop(
                                context,
                                _MindMapChoice(mindMap.id, mindMap.name),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 24),
                    ],
                    Text(
                      'Create new mind map',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'Mind map name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedTemplateId,
                      decoration: const InputDecoration(
                        labelText: 'Template',
                        border: OutlineInputBorder(),
                      ),
                      items: MindMapService.templates
                          .map(
                            (template) => DropdownMenuItem<String>(
                              value: template.id,
                              child: Text(template.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => selectedTemplateId = value);
                      },
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
                    if (label.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a name')),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      _MindMapChoice(
                        '__create__',
                        label,
                        templateId: selectedTemplateId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    final nodesNotifier = ref.read(nodesNotifierProvider.notifier);

    // Create mind map if requested
    String mapId = result.mapId;
    String label = result.label;

    if (result.mapId == '__create__') {
      final newMap = await mindMapService.createMindMapWithTemplate(
        workspaceId: workspaceId,
        name: label,
        templateId: result.templateId ?? 'blank',
      );
      mapId = newMap.id;
      label = newMap.name;
    }

    await nodesNotifier.addMindMapRefBlock(node.id, mapId: mapId, label: label);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mind map reference added')));
  }

  Future<void> _addMathsRefBlock(IdeaNode node) async {
    final mathsService = MathsService.instance;
    final workspaceId = ref.read(activeWorkspaceIdProvider) ?? node.workspaceId;

    // Load existing maths objects for this workspace
    final mathsObjects = await mathsService.listMathsObjects(workspaceId);

    if (!mounted) return;

    final result = await showDialog<_MathsChoice?>(
      context: context,
      builder: (context) {
        final labelController = TextEditingController();
        String selectedType = 'matrix';
        int rows = 3;
        int cols = 3;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Maths Object'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (mathsObjects.isNotEmpty) ...[
                      Text(
                        'Existing maths objects',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: mathsObjects.length,
                          itemBuilder: (context, index) {
                            final obj = mathsObjects[index];
                            final icon = obj is MatrixObject
                                ? Icons.grid_on
                                : Icons.show_chart;
                            final String subtitle;
                            if (obj is MatrixObject) {
                              subtitle =
                                  '${obj.data.rows}×${obj.data.cols} matrix';
                            } else if (obj is GraphObject) {
                              subtitle =
                                  '${obj.data.equations.length} equations';
                            } else {
                              subtitle = 'unknown';
                            }
                            return ListTile(
                              dense: true,
                              leading: Icon(icon),
                              title: Text(
                                obj.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '$subtitle • ${obj.createdAt.toLocal().toIso8601String().split('T').first}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () => Navigator.pop(
                                context,
                                _MathsChoice(obj.id, obj.name),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 24),
                    ],
                    Text(
                      'Create new maths object',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'matrix',
                          child: Text('Matrix'),
                        ),
                        DropdownMenuItem(value: 'graph', child: Text('Graph')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => selectedType = value);
                      },
                    ),
                    if (selectedType == 'matrix') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: rows,
                              decoration: const InputDecoration(
                                labelText: 'Rows',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(
                                8,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              onChanged: (v) {
                                if (v != null) setState(() => rows = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: cols,
                              decoration: const InputDecoration(
                                labelText: 'Cols',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(
                                8,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              onChanged: (v) {
                                if (v != null) setState(() => cols = v);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    if (label.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a name')),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      _MathsChoice(
                        '__create__',
                        label,
                        type: selectedType,
                        rows: rows,
                        cols: cols,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    final nodesNotifier = ref.read(nodesNotifierProvider.notifier);

    String objectId = result.objectId;
    String label = result.label;

    if (result.objectId == '__create__') {
      if (result.type == 'graph') {
        final newObj = await mathsService.createGraph(
          workspaceId: workspaceId,
          name: label,
        );
        objectId = newObj.id;
        label = newObj.name;
      } else {
        final newObj = await mathsService.createMatrix(
          workspaceId: workspaceId,
          name: label,
          rows: result.rows ?? 3,
          cols: result.cols ?? 3,
        );
        objectId = newObj.id;
        label = newObj.name;
      }
    }

    await nodesNotifier.addMathsRefBlock(
      node.id,
      mathsObjectId: objectId,
      label: label,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Maths object reference added')),
    );
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

  Widget _buildMetaBadge(IconData icon, String label, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withAlpha(100),
        borderRadius: BorderRadius.circular(AxiomRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.onSurfaceVariant.withAlpha(150)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AxiomTypography.labelSmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(150),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceSessionChoice {
  const _WorkspaceSessionChoice(this.sessionId, this.label);
  final String sessionId;
  final String label;
}

class _MindMapChoice {
  const _MindMapChoice(this.mapId, this.label, {this.templateId});
  final String mapId;
  final String label;
  final String? templateId;
}

class _MathsChoice {
  const _MathsChoice(
    this.objectId,
    this.label, {
    this.type = 'matrix',
    this.rows,
    this.cols,
  });
  final String objectId;
  final String label;
  final String type;
  final int? rows;
  final int? cols;
}
