import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Renders connection lines between linked nodes on the canvas.
class NodeConnectionsPainter extends CustomPainter {
  NodeConnectionsPainter({
    required this.nodes,
    required this.minX,
    required this.minY,
    required this.selectedNodeId,
    this.hoveredLinkId,
  });

  final List<IdeaNode> nodes;
  final double minX;
  final double minY;
  final String? selectedNodeId;
  final String? hoveredLinkId;

  // Standard node card dimensions for connection calculation
  static const double nodeWidth = 230.0;
  static const double nodeHeight = 100.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Create a map for quick node lookup
    final nodeMap = {for (final node in nodes) node.id: node};

    for (final node in nodes) {
      for (final link in node.links) {
        final targetNode = nodeMap[link.targetNodeId];
        if (targetNode == null) continue;

        // Calculate connection points (center of each node)
        final startX = node.position.x - minX + nodeWidth / 2;
        final startY = node.position.y - minY + nodeHeight / 2;
        final endX = targetNode.position.x - minX + nodeWidth / 2;
        final endY = targetNode.position.y - minY + nodeHeight / 2;

        // Determine line style based on selection and hover
        final isFromSelected = node.id == selectedNodeId;
        final isToSelected = link.targetNodeId == selectedNodeId;
        final isHovered = hoveredLinkId == '${node.id}-${link.targetNodeId}';
        final isRelatedToSelected = isFromSelected || isToSelected;

        _drawConnection(
          canvas,
          Offset(startX, startY),
          Offset(endX, endY),
          isRelatedToSelected: isRelatedToSelected,
          isHovered: isHovered,
          label: link.label,
        );
      }
    }
  }

  void _drawConnection(
    Canvas canvas,
    Offset start,
    Offset end, {
    required bool isRelatedToSelected,
    required bool isHovered,
    String? label,
  }) {
    // Line styling
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 3.0 : (isRelatedToSelected ? 2.5 : 1.5);

    // Color based on state
    if (isHovered) {
      paint.color = Colors.blue.withValues(alpha: 0.9);
    } else if (isRelatedToSelected) {
      paint.color = Colors.blue.withValues(alpha: 0.6);
    } else {
      paint.color = Colors.grey.withValues(alpha: 0.3);
    }

    // Draw curved connection line using quadratic bezier
    final controlPointOffset = (end - start) * 0.5;
    final controlPoint = start + controlPointOffset;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(path, paint);

    // Draw arrowhead at end
    _drawArrowhead(canvas, end, start, paint);

    // Draw label if present and visible
    if (label != null && label.isNotEmpty && (isHovered || isRelatedToSelected)) {
      _drawLabel(canvas, start, end, label);
    }
  }

  void _drawArrowhead(Canvas canvas, Offset end, Offset start, Paint paint) {
    const arrowSize = 12.0;
    final direction = (end - start);
    final angle = direction.direction;

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * math.cos(angle - 0.3),
        end.dy - arrowSize * math.sin(angle - 0.3),
      )
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * math.cos(angle + 0.3),
        end.dy - arrowSize * math.sin(angle + 0.3),
      );

    canvas.drawPath(arrowPath, paint);
  }

  void _drawLabel(Canvas canvas, Offset start, Offset end, String label) {
    final midPoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Draw background for better readability
    final bgRect = Rect.fromCenter(
      center: midPoint,
      width: textPainter.width + 8,
      height: textPainter.height + 4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(
      canvas,
      Offset(midPoint.dx - textPainter.width / 2, midPoint.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(NodeConnectionsPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.hoveredLinkId != hoveredLinkId;
  }
}

/// Helper extension for Offset direction calculation.
extension OffsetExtension on Offset {
  double get direction => math.atan2(dy, dx);
}
