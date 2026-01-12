import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../nodes/idea_node_card.dart';

/// The content layer of the canvas that renders positioned IdeaNodes.
class CanvasContent extends ConsumerWidget {
  const CanvasContent({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    required this.onNodeTap,
    required this.onNodeDoubleTap,
    required this.onNodeDragEnd,
    required this.onCanvasTap,
    required this.onCanvasDoubleTap,
  });

  final List<IdeaNode> nodes;
  final String? selectedNodeId;
  final ValueChanged<String> onNodeTap;
  final ValueChanged<String> onNodeDoubleTap;
  final void Function(String nodeId, Offset delta) onNodeDragEnd;
  final VoidCallback onCanvasTap;
  final ValueChanged<Offset> onCanvasDoubleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate canvas bounds based on node positions
    // Add padding around the content
    const padding = 2000.0;
    double minX = -padding;
    double minY = -padding;
    double maxX = padding;
    double maxY = padding;

    for (final node in nodes) {
      minX = minX < node.position.x - padding ? minX : node.position.x - padding;
      minY = minY < node.position.y - padding ? minY : node.position.y - padding;
      maxX = maxX > node.position.x + padding ? maxX : node.position.x + padding;
      maxY = maxY > node.position.y + padding ? maxY : node.position.y + padding;
    }

    final width = maxX - minX;
    final height = maxY - minY;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onCanvasTap,
      onDoubleTapDown: (details) {
        // Convert local position to canvas coordinates
        onCanvasDoubleTap(details.localPosition + Offset(minX, minY));
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
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            // Render nodes
            ...nodes.map((node) {
              final isSelected = node.id == selectedNodeId;
              return Positioned(
                left: node.position.x - minX,
                top: node.position.y - minY,
                child: IdeaNodeCard(
                  node: node,
                  isSelected: isSelected,
                  onTap: () => onNodeTap(node.id),
                  onDoubleTap: () => onNodeDoubleTap(node.id),
                  onDragEnd: (delta) => onNodeDragEnd(node.id, delta),
                ),
              );
            }),
          ],
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
