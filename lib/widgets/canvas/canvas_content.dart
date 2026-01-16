import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/gestures.dart' show kSecondaryMouseButton;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../nodes/idea_node_card.dart';
import '../canvas_sketch_layer.dart';
import 'node_connections_painter.dart';

/// The content layer of the canvas that renders positioned IdeaNodes.
class CanvasContent extends ConsumerStatefulWidget {
  const CanvasContent({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    this.highlightNodeId,
    required this.onNodeTap,
    required this.onNodeDoubleTap,
    required this.onNodeDragEnd,
    required this.onCanvasTap,
    required this.onCanvasDoubleTap,
    this.onCanvasInfoChanged,
    this.onBoundsChanged,
  });

  final List<IdeaNode> nodes;
  final String? selectedNodeId;
  final String? highlightNodeId;
  final ValueChanged<String> onNodeTap;
  final ValueChanged<String> onNodeDoubleTap;
  final void Function(String nodeId, Offset delta) onNodeDragEnd;
  final VoidCallback onCanvasTap;
  final ValueChanged<Offset> onCanvasDoubleTap;

  /// Callback to report the origin position in scene coordinates
  final ValueChanged<Offset>? onCanvasInfoChanged;

  /// Callback to report canvas bounds
  final ValueChanged<Rect>? onBoundsChanged;

  /// Constant padding around content
  static const double padding = 2000.0;

  @override
  ConsumerState<CanvasContent> createState() => _CanvasContentState();
}

class _CanvasContentState extends ConsumerState<CanvasContent> {
  DateTime? _lastSecondaryDown;

  OverlayEntry? _contextMenuEntry;
  String? _hoveredLinkId;
  bool _tapConsumed = false;

  @override
  void dispose() {
    _removeContextMenu();
    super.dispose();
  }

  void _removeContextMenu() {
    _contextMenuEntry?.remove();
    _contextMenuEntry = null;
  }

  _LinkHit? _hitTestLinks(Offset localPosition, double minX, double minY) {
    const threshold = 12.0;
    const w = NodeConnectionsPainter.nodeWidth;
    const h = NodeConnectionsPainter.nodeHeight;

    // Quick lookup for targets
    final nodeMap = {for (final node in widget.nodes) node.id: node};

    _LinkHit? closest;

    for (final source in widget.nodes) {
      for (final link in source.links) {
        final target = nodeMap[link.targetNodeId];
        if (target == null) continue;

        final start = Offset(
          source.position.x - minX + w / 2,
          source.position.y - minY + h / 2,
        );
        final end = Offset(
          target.position.x - minX + w / 2,
          target.position.y - minY + h / 2,
        );

        final distance = _distanceToSegment(localPosition, start, end);
        if (distance <= threshold &&
            (closest == null || distance < closest.distance)) {
          closest = _LinkHit(
            source: source,
            target: target,
            link: link,
            start: start,
            end: end,
            distance: distance,
          );
        }
      }
    }

    return closest;
  }

  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ap = p - a;
    final ab = b - a;
    final abLen2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (abLen2 == 0) return ap.distance;
    final t = ((ap.dx * ab.dx) + (ap.dy * ab.dy)) / abLen2;
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(a.dx + ab.dx * clampedT, a.dy + ab.dy * clampedT);
    return (p - projection).distance;
  }

  Future<void> _showLinkDetails(_LinkHit hit) async {
    final label = hit.link.label.isNotEmpty ? hit.link.label : 'Link';
    final previewFrom = hit.source.previewText.isNotEmpty
        ? hit.source.previewText
        : hit.source.id;
    final previewTo = hit.target.previewText.isNotEmpty
        ? hit.target.previewText
        : hit.target.id;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'From: $previewFrom',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'To: $previewTo',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNodeDoubleTap(hit.target.id);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open target'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      _removeLink(hit);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.link_off),
                    label: const Text('Remove link'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeLink(_LinkHit hit) {
    ref
        .read(nodesNotifierProvider.notifier)
        .removeLink(hit.source.id, hit.link.targetNodeId);
  }

  void _showContextMenu(
    BuildContext context,
    Offset position,
    Offset scenePos,
  ) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
      minX = minX < node.position.x - padding
          ? minX
          : node.position.x - padding;
      minY = minY < node.position.y - padding
          ? minY
          : node.position.y - padding;
      maxX = maxX > node.position.x + padding
          ? maxX
          : node.position.x + padding;
      maxY = maxY > node.position.y + padding
          ? maxY
          : node.position.y + padding;
    }

    final width = maxX - minX;
    final height = maxY - minY;

    // Origin position in scene coordinates (where 0,0 is rendered)
    final originInScene = Offset(-minX, -minY);

    // Create bounds rect
    final bounds = Rect.fromLTWH(minX, minY, width, height);

    // Report canvas info and bounds after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCanvasInfoChanged?.call(originInScene);
      widget.onBoundsChanged?.call(bounds);
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
          final hit = _hitTestLinks(event.localPosition, minX, minY);
          if (hit != null) {
            _removeLink(hit);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Link removed')));
            _lastSecondaryDown = null;
            return;
          }

          final now = DateTime.now();
          final scenePos = event.localPosition + Offset(minX, minY);

          if (_lastSecondaryDown != null &&
              now.difference(_lastSecondaryDown!) <
                  const Duration(milliseconds: 550)) {
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
              if (mounted &&
                  _lastSecondaryDown == clickTime &&
                  context.mounted) {
                _showContextMenu(context, clickPosition, scenePos);
              }
            });
          }
        }
      },
      onPointerHover: (event) {
        final hit = _hitTestLinks(event.localPosition, minX, minY);
        final linkId = hit == null
            ? null
            : '${hit.source.id}-${hit.link.targetNodeId}';
        if (linkId != _hoveredLinkId) {
          setState(() => _hoveredLinkId = linkId);
        }
      },
      onPointerMove: (event) {
        if (event.kind != PointerDeviceKind.mouse) return;
        final hit = _hitTestLinks(event.localPosition, minX, minY);
        final linkId = hit == null
            ? null
            : '${hit.source.id}-${hit.link.targetNodeId}';
        if (linkId != _hoveredLinkId) {
          setState(() => _hoveredLinkId = linkId);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final hit = _hitTestLinks(details.localPosition, minX, minY);
          if (hit != null) {
            _tapConsumed = true;
            _showLinkDetails(hit);
            return;
          }
          _tapConsumed = false;
        },
        onTap: () {
          if (_tapConsumed) {
            _tapConsumed = false;
            return;
          }
          widget.onCanvasTap();
        },
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
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  gridSize: 50,
                ),
              ),
              // Canvas sketch layer (beneath nodes)
              SizedBox(
                width: width,
                height: height,
                child: CanvasSketchLayer(),
              ),
              // Connection lines between nodes
              CustomPaint(
                size: Size(width, height),
                painter: NodeConnectionsPainter(
                  nodes: widget.nodes,
                  minX: minX,
                  minY: minY,
                  selectedNodeId: widget.selectedNodeId,
                  hoveredLinkId: _hoveredLinkId,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              // Render nodes
              ...widget.nodes.map((node) {
                final isSelected = node.id == widget.selectedNodeId;
                final isHighlighted = node.id == widget.highlightNodeId;
                return Positioned(
                  left: node.position.x - minX,
                  top: node.position.y - minY,
                  child: IdeaNodeCard(
                    node: node,
                    isSelected: isSelected,
                    isHighlighted: isHighlighted,
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
  _GridPainter({required this.color, required this.gridSize});

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

class _LinkHit {
  _LinkHit({
    required this.source,
    required this.target,
    required this.link,
    required this.start,
    required this.end,
    required this.distance,
  });

  final IdeaNode source;
  final IdeaNode target;
  final NodeLink link;
  final Offset start;
  final Offset end;
  final double distance;
}
