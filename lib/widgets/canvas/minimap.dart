import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Compact minimap showing node positions and current viewport.
class CanvasMinimap extends StatelessWidget {
  const CanvasMinimap({
    super.key,
    required this.bounds,
    required this.viewport,
    required this.nodes,
    required this.origin,
    required this.onJumpToScene,
  });

  final Rect bounds;
  final Rect viewport;
  final List<IdeaNode> nodes;
  final Offset origin;
  final ValueChanged<Offset> onJumpToScene;

  @override
  Widget build(BuildContext context) {
    const double size = 160;
    const double padding = 8;
    final scaleX = (size - padding * 2) / bounds.width;
    final scaleY = (size - padding * 2) / bounds.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    Offset project(Offset scene) {
      final dx = (scene.dx - bounds.left) * scale + padding;
      final dy = (scene.dy - bounds.top) * scale + padding;
      return Offset(dx, dy);
    }

    final vpTopLeft = project(viewport.topLeft);
    final vpSize = Size(viewport.width * scale, viewport.height * scale);

    // Ensure jump target stays within rendered bounds
    Offset clampToBounds(Offset scene) {
      final clampedX = scene.dx.clamp(bounds.left, bounds.right);
      final clampedY = scene.dy.clamp(bounds.top, bounds.bottom);
      return Offset(clampedX, clampedY);
    }

    return Material(
      elevation: 6,
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (details) {
          final local = details.localPosition;
          final scene = Offset(
            bounds.left + (local.dx - padding) / scale,
            bounds.top + (local.dy - padding) / scale,
          );
          onJumpToScene(clampToBounds(scene));
        },
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Stack(
            children: [
              // Nodes
              ...nodes.map((n) {
                final pos = project(
                  Offset(n.position.x + origin.dx, n.position.y + origin.dy),
                );
                return Positioned(
                  left: pos.dx - 2,
                  top: pos.dy - 2,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
              // Viewport rectangle
              Positioned(
                left: vpTopLeft.dx,
                top: vpTopLeft.dy,
                child: Container(
                  width: vpSize.width,
                  height: vpSize.height,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
