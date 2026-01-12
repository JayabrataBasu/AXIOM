import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/gestures.dart' show kSecondaryMouseButton;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../nodes/idea_node_card.dart';

/// The content layer of the canvas that renders positioned IdeaNodes.
class CanvasContent extends ConsumerStatefulWidget {
  const CanvasContent({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    required this.onNodeTap,
    required this.onNodeDoubleTap,
    required this.onNodeDragEnd,
    required this.onCanvasTap,
    required this.onCanvasDoubleTap,
    this.onCanvasInfoChanged,
  });

  final List<IdeaNode> nodes;
  final String? selectedNodeId;
  final ValueChanged<String> onNodeTap;
  final ValueChanged<String> onNodeDoubleTap;
  final void Function(String nodeId, Offset delta) onNodeDragEnd;
  final VoidCallback onCanvasTap;
  final ValueChanged<Offset> onCanvasDoubleTap;
  /// Callback to report the origin position in scene coordinates
  final ValueChanged<Offset>? onCanvasInfoChanged;

  /// Constant padding around content
  static const double padding = 2000.0;

  @override
  ConsumerState<CanvasContent> createState() => _CanvasContentState();
}

class _CanvasContentState extends ConsumerState<CanvasContent> {
  DateTime? _lastSecondaryDown;
  Offset? _contextMenuPosition;
  OverlayEntry? _contextMenuEntry;

  @override
  void dispose() {
    _removeContextMenu();
    super.dispose();
  }

  void _removeContextMenu() {
    _contextMenuEntry?.remove();
    _contextMenuEntry = null;
    if (mounted) {
      setState(() {
        _contextMenuPosition = null;
      });
    }
  }

  void _showContextMenu(BuildContext context, Offset position, Offset scenePos) {
    _removeContextMenu();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final globalPosition = renderBox.localToGlobal(position);

    _contextMenuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible barrier to close menu on tap
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeContextMenu,
              onSecondaryTap: _removeContextMenu,
            ),
          ),
          // Context menu
          Positioned(
            left: globalPosition.dx,
            top: globalPosition.dy,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  _removeContextMenu();
                  widget.onCanvasDoubleTap(scenePos);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Create Node Here',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_contextMenuEntry!);
    setState(() {
      _contextMenuPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate canvas bounds based on node positions
    // Add padding around the content
    const padding = CanvasContent.padding;
    double minX = -padding;
    double minY = -padding;
    double maxX = padding;
    double maxY = padding;

    for (final node in widget.nodes) {
      minX = minX < node.position.x - padding ? minX : node.position.x - padding;
      minY = minY < node.position.y - padding ? minY : node.position.y - padding;
      maxX = maxX > node.position.x + padding ? maxX : node.position.x + padding;
      maxY = maxY > node.position.y + padding ? maxY : node.position.y + padding;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    
    // Origin position in scene coordinates (where 0,0 is rendered)
    final originInScene = Offset(-minX, -minY);
    
    // Report canvas info after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCanvasInfoChanged?.call(originInScene);
    });

    return Listener(
      onPointerDown: (event) {
        // Close context menu on any click
        if (_contextMenuEntry != null) {
          _removeContextMenu();
        }

        // Only handle mouse right-button for creation
        if (event.kind == PointerDeviceKind.mouse &&
            (event.buttons & kSecondaryMouseButton) != 0) {
          final now = DateTime.now();
          final scenePos = event.localPosition + Offset(minX, minY);
          
          if (_lastSecondaryDown != null &&
              now.difference(_lastSecondaryDown!) < const Duration(milliseconds: 550)) {
            // Double-click: create node immediately
            widget.onCanvasDoubleTap(scenePos);
            _lastSecondaryDown = null;
          } else {
            // Single click: schedule context menu
            _lastSecondaryDown = now;
            final clickTime = now;
            final clickPosition = event.localPosition;
            
            // Show context menu after delay if it wasn't a double-click
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted && _lastSecondaryDown == clickTime) {
                _showContextMenu(context, clickPosition, scenePos);
              }
            });
          }
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onCanvasTap,
        child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Grid background
            CustomPaint(
              size: Size(width, height),
              painter: _GridPainter(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                gridSize: 50,
              ),
            ),
            // Origin marker
            Positioned(
              left: -minX - 10,
              top: -minY - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Render nodes
            ...widget.nodes.map((node) {
              final isSelected = node.id == widget.selectedNodeId;
              return Positioned(
                left: node.position.x - minX,
                top: node.position.y - minY,
                child: IdeaNodeCard(
                  node: node,
                  isSelected: isSelected,
                  onTap: () => widget.onNodeTap(node.id),
                  onDoubleTap: () => widget.onNodeDoubleTap(node.id),
                  onDragEnd: (delta) => widget.onNodeDragEnd(node.id, delta),
                ),
              );
            }),
          ],
        ),
      ),
      ),
    );
  }
}

/// Paints a grid pattern on the canvas.
class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.color,
    required this.gridSize,
  });

  final Color color;
  final double gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.gridSize != gridSize;
  }
}
