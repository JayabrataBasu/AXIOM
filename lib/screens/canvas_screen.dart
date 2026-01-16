import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/node_template.dart';
import '../providers/providers.dart';
import '../services/search_service.dart' as search;
import '../widgets/widgets.dart';
import '../widgets/canvas_sketch_overlay.dart';
import '../widgets/dialogs/add_canvas_item_dialog.dart';
import 'node_editor_screen.dart';
import 'search_nodes_screen.dart';

/// The main canvas screen - the primary thinking surface.
class CanvasScreen extends ConsumerStatefulWidget {
  const CanvasScreen({super.key, this.workspaceId});

  final String? workspaceId;

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  final _canvasKey = GlobalKey<InfiniteCanvasState>();
  final _focusNode = FocusNode();
  double _currentZoom = 1.0;
  Rect? _contentBounds;
  String? _recentlyCreatedNodeId;
  Timer? _newNodeHighlightTimer;
  Rect? _viewportRect;
  // ignore: prefer_final_fields
  bool _sketchMode = false;
  bool _doodleMode = false;
  // ignore: prefer_final_fields
  List<DoodleStroke> _doodleStrokes = [];
  List<Offset> _currentDoodleStroke = [];
  Color _doodleColor = Colors.white;
  double _doodleWidth = 2.0;

  @override
  void dispose() {
    _newNodeHighlightTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final viewState = ref.watch(canvasViewProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // Canvas
            nodesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
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
              data: (nodes) => InfiniteCanvas(
                key: _canvasKey,
                panEnabled: !_sketchMode && !_doodleMode,
                contentBounds: _contentBounds,
                onScaleChanged: (scale) {
                  setState(() => _currentZoom = scale);
                  _updateViewportRect();
                },
                child: CanvasContent(
                  nodes: nodes,
                  selectedNodeId: viewState.selectedNodeId,
                  highlightNodeId: _recentlyCreatedNodeId,
                  onNodeTap: _onNodeTap,
                  onNodeDoubleTap: _onNodeDoubleTap,
                  onNodeDragEnd: _onNodeDragEnd,
                  onCanvasTap: _onCanvasTap,
                  onCanvasDoubleTap: _onCanvasDoubleTap,
                  onCanvasInfoChanged: (_) {},
                  onBoundsChanged: (bounds) {
                    setState(() => _contentBounds = bounds);
                    _updateViewportRect();
                  },
                ),
              ),
            ),
            // Canvas sketch overlay (only active in sketch mode, above the canvas)
            if (_sketchMode)
              Positioned.fill(
                child: CanvasSketchOverlay(canvasKey: _canvasKey),
              ),
            // Top toolbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildToolbar(context, theme),
            ),
            // Sketch tools palette (only visible in sketch mode)
            if (_sketchMode) const SketchToolsPalette(),
            // FAB for creating new nodes
            Positioned(bottom: 24, right: 24, child: _buildFAB(theme)),
            // Doodle layer (draw on canvas without creating nodes)
            if (_doodleMode)
              Positioned.fill(
                child: RepaintBoundary(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) {
                      setState(() {
                        _currentDoodleStroke = [details.globalPosition];
                      });
                    },
                    onPanUpdate: (details) {
                      // Throttle updates - only add point if moved sufficiently
                      final lastPoint = _currentDoodleStroke.isNotEmpty
                          ? _currentDoodleStroke.last
                          : null;
                      if (lastPoint == null ||
                          (details.globalPosition - lastPoint).distance > 2.0) {
                        setState(() {
                          _currentDoodleStroke.add(details.globalPosition);
                        });
                      }
                    },
                    onPanEnd: (_) {
                      if (_currentDoodleStroke.isNotEmpty) {
                        setState(() {
                          _doodleStrokes.add(
                            DoodleStroke(
                              points: List.from(_currentDoodleStroke),
                              color: _doodleColor,
                              width: _doodleWidth,
                              createdAt: DateTime.now(),
                            ),
                          );
                          _currentDoodleStroke = [];
                        });
                      }
                    },
                    child: CustomPaint(
                      painter: DoodleCanvasPainter(
                        strokes: _doodleStrokes,
                        currentStroke: _currentDoodleStroke,
                        currentColor: _doodleColor,
                        currentWidth: _doodleWidth,
                      ),
                      size: Size.infinite,
                      isComplex: true,
                      willChange: true,
                    ),
                  ),
                ),
              ),
            // Node navigator (locate and jump to nodes)
            _buildNodeNavigator(nodesAsync, viewState),
            // Minimap overlay
            if (_contentBounds != null && _viewportRect != null)
              Positioned(
                left: 16,
                bottom: 16,
                child: CanvasMinimap(
                  bounds: _contentBounds!,
                  viewport: _viewportRect!,
                  nodes: nodesAsync.valueOrNull ?? const [],
                  onJumpToScene: (scenePos) {
                    _canvasKey.currentState?.centerOn(scenePos);
                  },
                ),
              ),
            // Doodle toolbar
            if (nodesAsync.hasValue)
              DoodleToolbar(
                isEnabled: _doodleMode,
                onEnableToggle: () =>
                    setState(() => _doodleMode = !_doodleMode),
                onColorChanged: (color) => setState(() => _doodleColor = color),
                onWidthChanged: (width) => setState(() => _doodleWidth = width),
                onClear: () => setState(() => _doodleStrokes.clear()),
                color: _doodleColor,
                width: _doodleWidth,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeNavigator(
    AsyncValue<List<IdeaNode>> nodesAsync,
    CanvasViewState viewState,
  ) {
    return nodesAsync.when(
      data: (nodes) => NodeNavigator(
        nodes: nodes,
        selectedNodeId: viewState.selectedNodeId,
        onNodeSelect: (nodeId) {
          final position = _getNodePosition(nodes, nodeId);
          _canvasKey.currentState?.centerOn(position);
          ref.read(canvasViewProvider.notifier).selectNode(nodeId);
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildToolbar(BuildContext context, ThemeData theme) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final workspaceLabel = _getWorkspaceLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // Glass panel effect matching Stitch design
        color: Colors.black.withValues(alpha: 0.55),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        backgroundBlendMode: BlendMode.multiply,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _onBackPressed,
              tooltip: 'Go back',
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              iconSize: 24,
            ),
            // Title - centered
            Expanded(
              child: Center(
                child: Text(
                  workspaceLabel.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Right actions
            if (!isSmallScreen)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search button
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final nav =
                          await Navigator.push<search.SearchNavigation?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchNodesScreen(),
                            ),
                          );

                      if (nav == null) return;
                      if (!mounted) return;

                      final nodes =
                          ref.read(nodesNotifierProvider).valueOrNull ?? [];
                      final position = _getNodePosition(nodes, nav.nodeId);
                      _canvasKey.currentState?.centerOn(position);
                      ref
                          .read(canvasViewProvider.notifier)
                          .selectNode(nav.nodeId);

                      if (nav.blockId.isNotEmpty && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NodeEditorScreen(
                              nodeId: nav.nodeId,
                              highlightBlockId: nav.blockId,
                            ),
                          ),
                        );
                      }
                    },
                    tooltip: 'Search nodes',
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 4),
                  // Zoom to fit button
                  IconButton(
                    icon: const Icon(Icons.fit_screen),
                    onPressed: () {
                      final nodes =
                          ref.read(nodesNotifierProvider).valueOrNull ?? [];
                      if (nodes.isEmpty) return;

                      // Calculate canvas bounds the same way CanvasContent does
                      const padding = 2000.0; // CanvasContent.padding
                      double canvasMinX = -padding;
                      double canvasMinY = -padding;

                      for (final n in nodes) {
                        canvasMinX = canvasMinX < n.position.x - padding
                            ? canvasMinX
                            : n.position.x - padding;
                        canvasMinY = canvasMinY < n.position.y - padding
                            ? canvasMinY
                            : n.position.y - padding;
                      }

                      // Calculate bounds in rendering coordinates
                      double minX = nodes.first.position.x - canvasMinX;
                      double minY = nodes.first.position.y - canvasMinY;
                      double maxX = nodes.first.position.x - canvasMinX;
                      double maxY = nodes.first.position.y - canvasMinY;

                      for (final node in nodes) {
                        final renderX = node.position.x - canvasMinX;
                        final renderY = node.position.y - canvasMinY;
                        if (renderX < minX) minX = renderX;
                        if (renderY < minY) minY = renderY;
                        if (renderX > maxX) maxX = renderX;
                        if (renderY > maxY) maxY = renderY;
                      }

                      // Add approximate node dimensions (230x120)
                      final bounds = Rect.fromLTRB(
                        minX,
                        minY,
                        maxX + 230,
                        maxY + 120,
                      );
                      _canvasKey.currentState?.zoomToFit(bounds);
                    },
                    tooltip: 'Fit all nodes',
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 4),
                  // Zoom indicator
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${(_currentZoom * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final nav =
                          await Navigator.push<search.SearchNavigation?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchNodesScreen(),
                            ),
                          );

                      if (nav == null) return;
                      if (!mounted) return;

                      final nodes =
                          ref.read(nodesNotifierProvider).valueOrNull ?? [];
                      final position = _getNodePosition(nodes, nav.nodeId);
                      _canvasKey.currentState?.centerOn(position);
                      ref
                          .read(canvasViewProvider.notifier)
                          .selectNode(nav.nodeId);

                      if (nav.blockId.isNotEmpty && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NodeEditorScreen(
                              nodeId: nav.nodeId,
                              highlightBlockId: nav.blockId,
                            ),
                          ),
                        );
                      }
                    },
                    tooltip: 'Search nodes',
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    iconSize: 24,
                  ),
                  IconButton(
                    icon: const Icon(Icons.fit_screen),
                    onPressed: () {
                      final nodes =
                          ref.read(nodesNotifierProvider).valueOrNull ?? [];
                      if (nodes.isEmpty) return;

                      // Calculate canvas bounds the same way CanvasContent does
                      const padding = 2000.0; // CanvasContent.padding
                      double canvasMinX = -padding;
                      double canvasMinY = -padding;

                      for (final n in nodes) {
                        canvasMinX = canvasMinX < n.position.x - padding
                            ? canvasMinX
                            : n.position.x - padding;
                        canvasMinY = canvasMinY < n.position.y - padding
                            ? canvasMinY
                            : n.position.y - padding;
                      }

                      // Calculate bounds in rendering coordinates
                      double minX = nodes.first.position.x - canvasMinX;
                      double minY = nodes.first.position.y - canvasMinY;
                      double maxX = nodes.first.position.x - canvasMinX;
                      double maxY = nodes.first.position.y - canvasMinY;

                      for (final node in nodes) {
                        final renderX = node.position.x - canvasMinX;
                        final renderY = node.position.y - canvasMinY;
                        if (renderX < minX) minX = renderX;
                        if (renderY < minY) minY = renderY;
                        if (renderX > maxX) maxX = renderX;
                        if (renderY > maxY) maxY = renderY;
                      }

                      // Add approximate node dimensions (230x120)
                      final bounds = Rect.fromLTRB(
                        minX,
                        minY,
                        maxX + 230,
                        maxY + 120,
                      );
                      _canvasKey.currentState?.zoomToFit(bounds);
                    },
                    tooltip: 'Fit all nodes',
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    iconSize: 24,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getWorkspaceLabel() {
    // Get workspace name from provider or use default
    return 'Workspace';
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Offset _getNodePosition(List<IdeaNode> nodes, String nodeId) {
    if (nodes.isEmpty) return Offset.zero;
    final node = nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => nodes.first,
    );

    // Calculate minX and minY the same way canvas_content does
    const padding = 2000.0; // CanvasContent.padding
    double minX = -padding;
    double minY = -padding;

    for (final n in nodes) {
      minX = minX < n.position.x - padding ? minX : n.position.x - padding;
      minY = minY < n.position.y - padding ? minY : n.position.y - padding;
    }

    // Return position in canvas rendering coordinates (node.position - min offset)
    final renderX = node.position.x - minX;
    final renderY = node.position.y - minY;

    return Offset(renderX, renderY);
  }

  Widget _buildFAB(ThemeData theme) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _createNewNode,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Escape to deselect
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(canvasViewProvider.notifier).clearSelection();
      }
      // Delete selected node
      if (event.logicalKey == LogicalKeyboardKey.delete ||
          event.logicalKey == LogicalKeyboardKey.backspace) {
        final selectedId = ref.read(canvasViewProvider).selectedNodeId;
        if (selectedId != null) {
          _confirmDeleteNode(selectedId);
        }
      }
    }
  }

  void _onNodeTap(String nodeId) {
    ref.read(canvasViewProvider.notifier).selectNode(nodeId);
  }

  void _onNodeDoubleTap(String nodeId) {
    _openNodeEditor(nodeId);
  }

  void _onNodeDragEnd(String nodeId, Offset delta) async {
    final nodes = ref.read(nodesNotifierProvider).valueOrNull ?? [];
    final node = nodes.firstWhere((n) => n.id == nodeId);
    final newPosition = Position(
      x: node.position.x + delta.dx,
      y: node.position.y + delta.dy,
    );
    await ref
        .read(nodesNotifierProvider.notifier)
        .updateNodePosition(nodeId, newPosition);
  }

  /// Create a new node at the canvas origin.
  Future<void> _createNewNode() async {
    // Show new canvas item dialog
    final itemType = await showDialog<CanvasItemType>(
      context: context,
      builder: (context) => const AddCanvasItemDialog(),
    );

    if (itemType == null || !mounted) return;

    // For now, show a message about the feature
    if (itemType != CanvasItemType.container) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Standalone ${itemType.name} blocks are coming soon! '
            'For now, you can add them inside container nodes.',
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
      return;
    }

    // Continue with regular node creation for containers
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateNodeDialog(),
    );

    if (result == null || !mounted) return;

    // Create node at the center of the current view
    final viewportCenter =
        _canvasKey.currentState?.viewportCenter ?? Offset.zero;
    final position = Position(x: viewportCenter.dx, y: viewportCenter.dy);

    final node = await ref
        .read(nodesNotifierProvider.notifier)
        .createNode(
          position: position,
          name: result['name'] as String?,
          template: result['template'] as NodeTemplate?,
        );

    // Select the new node
    ref.read(canvasViewProvider.notifier).selectNode(node.id);
    _highlightNewNode(node.id);

    // Show a snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['name'] != null && (result['name'] as String).isNotEmpty
                ? 'Created node: ${result['name']}'
                : 'New node created',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _highlightNewNode(String nodeId) {
    _newNodeHighlightTimer?.cancel();
    setState(() {
      _recentlyCreatedNodeId = nodeId;
    });

    _newNodeHighlightTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _recentlyCreatedNodeId = null);
    });
  }

  void _updateViewportRect() {
    final rect = _canvasKey.currentState?.sceneViewportRect;
    if (rect == null) return;
    setState(() => _viewportRect = rect);
  }

  void _onCanvasTap() {
    ref.read(canvasViewProvider.notifier).clearSelection();
  }

  void _onCanvasDoubleTap(Offset canvasPosition) async {
    // Show create node dialog
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateNodeDialog(),
    );

    if (result == null || !mounted) return;

    // Create new node at the tapped position
    final position = Position(x: canvasPosition.dx, y: canvasPosition.dy);
    final node = await ref
        .read(nodesNotifierProvider.notifier)
        .createNode(
          position: position,
          name: result['name'] as String?,
          template: result['template'] as NodeTemplate?,
        );
    // Select the new node
    ref.read(canvasViewProvider.notifier).selectNode(node.id);
    _highlightNewNode(node.id);
  }

  void _openNodeEditor(String nodeId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NodeEditorScreen(nodeId: nodeId)),
    );
  }

  Future<void> _confirmDeleteNode(String nodeId) async {
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
      ref.read(canvasViewProvider.notifier).clearSelection();
      await ref.read(nodesNotifierProvider.notifier).deleteNode(nodeId);
    }
  }
}
