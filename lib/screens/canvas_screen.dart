import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/node_template.dart';
import '../providers/providers.dart';
import '../services/search_service.dart' as search;
import '../theme/design_tokens.dart';
import '../widgets/widgets.dart';
import '../widgets/canvas_sketch_overlay.dart';
import '../widgets/dialogs/add_canvas_item_dialog.dart';
import 'node_editor_screen.dart';
import 'search_nodes_screen.dart';

/// The main canvas screen - the primary thinking surface.
/// Everforest themed: bg0 background, glass toolbar, green accent FAB.
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
  Offset _canvasOrigin = Offset.zero;
  String? _recentlyCreatedNodeId;
  Timer? _newNodeHighlightTimer;
  Rect? _viewportRect;
  bool _minimapVisible = false;
  // ignore: prefer_final_fields
  bool _sketchMode = false;
  final bool _doodleMode = false;
  // ignore: prefer_final_fields
  List<DoodleStroke> _doodleStrokes = [];
  List<Offset> _currentDoodleStroke = [];
  final Color _doodleColor = AxiomColors.fg;
  final double _doodleWidth = 2.0;

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
      backgroundColor: theme.colorScheme.surface,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // Canvas
            nodesAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: AxiomColors.green),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AxiomColors.red),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'Error: $error',
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: AxiomColors.fg,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    FilledButton(
                      onPressed: () {
                        // Defer reload to next frame to avoid lifecycle races
                        Future.microtask(() {
                          if (mounted) {
                            ref.read(nodesNotifierProvider.notifier).reload();
                          }
                        });
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
                child: Stack(
                  children: [
                    CanvasContent(
                      nodes: nodes,
                      selectedNodeId: viewState.selectedNodeId,
                      highlightNodeId: _recentlyCreatedNodeId,
                      onNodeTap: _onNodeTap,
                      onNodeDoubleTap: _onNodeDoubleTap,
                      onNodeDragEnd: _onNodeDragEnd,
                      onCanvasTap: _onCanvasTap,
                      onCanvasDoubleTap: _onCanvasDoubleTap,
                      onCanvasInfoChanged: (origin) {
                        setState(() => _canvasOrigin = origin);
                      },
                      onBoundsChanged: (bounds) {
                        setState(() => _contentBounds = bounds);
                        _updateViewportRect();
                      },
                    ),
                    // Sketch layer renders saved strokes so they persist and transform with canvas
                    const CanvasSketchLayer(),
                  ],
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
            // Minimap modal dialog - Everforest styled
            if (_minimapVisible &&
                _contentBounds != null &&
                _viewportRect != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _minimapVisible = false),
                  child: Container(
                    color: Colors.black.withAlpha(100),
                    child: Center(
                      child: Material(
                        elevation: 12,
                        color: AxiomColors.bg1,
                        borderRadius: BorderRadius.circular(AxiomRadius.lg),
                        child: Container(
                          padding: const EdgeInsets.all(AxiomSpacing.md),
                          decoration: BoxDecoration(
                            color: AxiomColors.bg1,
                            borderRadius: BorderRadius.circular(AxiomRadius.lg),
                            border: Border.all(
                              color: AxiomColors.outlineVariant,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Canvas Map',
                                    style: AxiomTypography.heading2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AxiomColors.fg,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AxiomColors.grey0,
                                    ),
                                    onPressed: () =>
                                        setState(() => _minimapVisible = false),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AxiomSpacing.sm),
                              SizedBox(
                                width: 400,
                                height: 300,
                                child: CanvasMinimap(
                                  bounds: _contentBounds!,
                                  viewport: _viewportRect!,
                                  nodes: nodesAsync.valueOrNull ?? const [],
                                  origin: _canvasOrigin,
                                  onJumpToScene: (scenePos) {
                                    _canvasKey.currentState?.centerOn(scenePos);
                                    setState(() => _minimapVisible = false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
    final cs = theme.colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.sm,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            // Floating glass panel
            color: cs.surface.withAlpha(230),
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            border: Border.all(
              color: cs.outlineVariant.withAlpha(40),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withAlpha(12),
                blurRadius: 20,
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
                  borderRadius: BorderRadius.circular(AxiomRadius.full),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: cs.onSurface,
                    size: 20,
                  ),
                  onPressed: _onBackPressed,
                  tooltip: 'Go back',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              // Title - centered
              Expanded(
                child: Center(
                  child: Text(
                    workspaceLabel,
                    style: AxiomTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: cs.onSurface,
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
                    _ToolbarIconButton(
                      icon: Icons.search_rounded,
                      color: cs.onSurfaceVariant,
                      onPressed: () async {
                        if (!mounted) return;
                        final ctx = context;
                        final nav =
                            await Navigator.push<search.SearchNavigation?>(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => const SearchNodesScreen(),
                              ),
                            );

                        if (nav == null || !mounted) return;

                        final nodes =
                            ref.read(nodesNotifierProvider).valueOrNull ?? [];
                        final position = _getNodePosition(nodes, nav.nodeId);
                        _canvasKey.currentState?.centerOn(position);
                        ref
                            .read(canvasViewProvider.notifier)
                            .selectNode(nav.nodeId);

                        if (nav.blockId.isNotEmpty && mounted) {
                          Navigator.push(
                            ctx,
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
                    ),
                    const SizedBox(width: 4),
                    // Tools dropdown menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.tune_rounded,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                      tooltip: 'Tools & Options',
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      iconSize: 20,
                      color: cs.surfaceContainerHigh,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AxiomRadius.md),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'minimap',
                          child: Row(
                            children: [
                              Icon(
                                Icons.map_rounded,
                                size: 20,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Minimap',
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'sketch_toggle',
                          child: Row(
                            children: [
                              Icon(
                                Icons.draw_rounded,
                                size: 20,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _sketchMode
                                    ? 'Exit Sketch Mode'
                                    : 'Sketch Mode',
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'minimap':
                            setState(() => _minimapVisible = true);
                            break;
                          case 'sketch_toggle':
                            setState(() {
                              _sketchMode = !_sketchMode;
                              if (!_sketchMode) {
                                ref
                                    .read(canvasSketchNotifierProvider.notifier)
                                    .clearCanvas();
                              }
                            });
                            break;
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    // Zoom to fit button
                    _ToolbarIconButton(
                      icon: Icons.fit_screen_rounded,
                      color: cs.onSurfaceVariant,
                      onPressed: () {
                        final nodes =
                            ref.read(nodesNotifierProvider).valueOrNull ?? [];
                        if (nodes.isEmpty) return;

                        const padding = 2000.0;
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

                        final bounds = Rect.fromLTRB(
                          minX,
                          minY,
                          maxX + 230,
                          maxY + 120,
                        );

                        Future.delayed(const Duration(milliseconds: 1), () {
                          if (mounted) {
                            _canvasKey.currentState?.zoomToFit(bounds);
                          }
                        });
                      },
                      tooltip: 'Fit all nodes',
                    ),
                    const SizedBox(width: 6),
                    // Zoom indicator - Stitch styled pill
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: cs.secondary.withAlpha(20),
                        borderRadius: BorderRadius.circular(AxiomRadius.full),
                        border: Border.all(
                          color: cs.secondary.withAlpha(50),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${(_currentZoom * 100).toStringAsFixed(0)}%',
                          style: AxiomTypography.labelSmall.copyWith(
                            fontFamily: 'JetBrains Mono',
                            fontWeight: FontWeight.bold,
                            color: cs.secondary,
                            fontSize: 11,
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
                    _ToolbarIconButton(
                      icon: Icons.search_rounded,
                      color: cs.onSurfaceVariant,
                      onPressed: () async {
                        if (!mounted) return;
                        final ctx = context;
                        final nav =
                            await Navigator.push<search.SearchNavigation?>(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => const SearchNodesScreen(),
                              ),
                            );

                        if (nav == null || !mounted) return;

                        final nodes =
                            ref.read(nodesNotifierProvider).valueOrNull ?? [];
                        final position = _getNodePosition(nodes, nav.nodeId);
                        _canvasKey.currentState?.centerOn(position);
                        ref
                            .read(canvasViewProvider.notifier)
                            .selectNode(nav.nodeId);

                        if (nav.blockId.isNotEmpty && mounted) {
                          Navigator.push(
                            ctx,
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
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.tune_rounded,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                      tooltip: 'Tools & Options',
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      iconSize: 20,
                      color: cs.surfaceContainerHigh,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AxiomRadius.md),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'minimap',
                          child: Row(
                            children: [
                              Icon(
                                Icons.map_rounded,
                                size: 20,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Minimap',
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'sketch_toggle',
                          child: Row(
                            children: [
                              Icon(
                                Icons.draw_rounded,
                                size: 20,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _sketchMode
                                    ? 'Exit Sketch Mode'
                                    : 'Sketch Mode',
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'minimap':
                            setState(() => _minimapVisible = true);
                            break;
                          case 'sketch_toggle':
                            setState(() {
                              _sketchMode = !_sketchMode;
                              if (!_sketchMode) {
                                ref
                                    .read(canvasSketchNotifierProvider.notifier)
                                    .clearCanvas();
                              }
                            });
                            break;
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    _ToolbarIconButton(
                      icon: Icons.fit_screen_rounded,
                      color: cs.onSurfaceVariant,
                      onPressed: () {
                        final nodes =
                            ref.read(nodesNotifierProvider).valueOrNull ?? [];
                        if (nodes.isEmpty) return;

                        const padding = 2000.0;
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

                        final bounds = Rect.fromLTRB(
                          minX,
                          minY,
                          maxX + 230,
                          maxY + 120,
                        );

                        Future.delayed(const Duration(milliseconds: 1), () {
                          if (mounted) {
                            _canvasKey.currentState?.zoomToFit(bounds);
                          }
                        });
                      },
                      tooltip: 'Fit all nodes',
                    ),
                  ],
                ),
            ],
          ),
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

    // Convert node position to render coordinates by adding origin offset
    return Offset(
      node.position.x + _canvasOrigin.dx,
      node.position.y + _canvasOrigin.dy,
    );
  }

  Widget _buildFAB(ThemeData theme) {
    final cs = theme.colorScheme;
    // Stitch-inspired emerald FAB with soft glow
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _createNewNode,
        borderRadius: BorderRadius.circular(AxiomRadius.full),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.secondary, cs.secondary.withAlpha(220)],
            ),
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            boxShadow: [
              BoxShadow(
                color: cs.secondary.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: cs.secondary.withAlpha(30),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
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
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
        title: Text(
          'Delete Node?',
          style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
        ),
        content: Text(
          'This action cannot be undone.',
          style: AxiomTypography.bodyMedium.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            child: const Text('Delete'),
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

/// Small circular icon button for the floating toolbar
class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
