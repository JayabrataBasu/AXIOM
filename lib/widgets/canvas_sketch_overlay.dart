import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_sketch.dart';
import '../providers/canvas_sketch_provider.dart';
import '../providers/sketch_tools_provider.dart';
import 'canvas/infinite_canvas.dart';

/// Overlay for canvas-level sketching that sits above the infinite canvas.
/// Uses efficient rendering by minimizing setState calls.
class CanvasSketchOverlay extends ConsumerStatefulWidget {
  const CanvasSketchOverlay({super.key, required this.canvasKey});

  final GlobalKey<InfiniteCanvasState> canvasKey;

  @override
  ConsumerState<CanvasSketchOverlay> createState() =>
      _CanvasSketchOverlayState();
}

class _CanvasSketchOverlayState extends ConsumerState<CanvasSketchOverlay> {
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    final sketchAsync = ref.watch(canvasSketchNotifierProvider);
    final toolState = ref.watch(sketchToolsProvider);

    return sketchAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, stack) => const SizedBox.shrink(),
      data: (sketch) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            if (toolState.tool == SketchTool.selector) return;

            if (toolState.tool == SketchTool.eraser) {
              _eraseAt(sketch, details.localPosition);
              setState(() {});
              return;
            }

            _isDrawing = true;
            _currentPoints = [details.localPosition];
            setState(() {});
          },
          onPanUpdate: (details) {
            if (toolState.tool == SketchTool.eraser) {
              _eraseAt(sketch, details.localPosition);
              setState(() {});
              return;
            }

            if (!_isDrawing) return;

            // Add point without setState - just update the list
            _currentPoints.add(details.localPosition);

            // Force repaint by calling setState minimally
            (context as Element).markNeedsBuild();
          },
          onPanEnd: (details) {
            if (toolState.tool == SketchTool.eraser) {
              return;
            }

            if (!_isDrawing || _currentPoints.length < 2) {
              _isDrawing = false;
              _currentPoints = [];
              setState(() {});
              return;
            }

            // Convert screen points to canvas points and save
            final canvasState = widget.canvasKey.currentState;
            if (canvasState != null) {
              final canvasPoints = _currentPoints.map((p) {
                final canvasPos = canvasState.screenToCanvas(p);
                return CanvasSketchPoint(
                  x: canvasPos.dx,
                  y: canvasPos.dy,
                  pressure: 1.0,
                );
              }).toList();

              final stroke = CanvasSketchStroke(
                points: canvasPoints,
                color: toolState.color.toARGB32(),
                width: toolState.brushSize,
              );

              ref.read(canvasSketchNotifierProvider.notifier).addStroke(stroke);
            }

            _isDrawing = false;
            _currentPoints = [];
            setState(() {});
          },
          child: CustomPaint(
            painter: _CanvasSketchOverlayPainter(
              strokes: sketch.strokes,
              currentPoints: _currentPoints,
              currentColor: toolState.color,
              currentWidth: toolState.brushSize,
              currentTool: toolState.tool,
              isDrawing: _isDrawing,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  void _eraseAt(CanvasSketch sketch, Offset screenPosition) {
    const eraserRadius = 20.0;
    final canvasState = widget.canvasKey.currentState;
    if (canvasState == null) return;

    final canvasPosition = canvasState.screenToCanvas(screenPosition);

    final newStrokes = <CanvasSketchStroke>[];

    for (final stroke in sketch.strokes) {
      final keptSegments = <List<CanvasSketchPoint>>[];
      var currentSegment = <CanvasSketchPoint>[];

      for (final point in stroke.points) {
        final dx = point.x - canvasPosition.dx;
        final dy = point.y - canvasPosition.dy;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance >= eraserRadius) {
          currentSegment.add(point);
        } else {
          if (currentSegment.isNotEmpty) {
            keptSegments.add(currentSegment);
            currentSegment = <CanvasSketchPoint>[];
          }
        }
      }

      if (currentSegment.isNotEmpty) {
        keptSegments.add(currentSegment);
      }

      if (keptSegments.isEmpty) {
        // Entire stroke erased - skip it
        continue;
      } else if (keptSegments.length == 1 &&
          keptSegments[0].length == stroke.points.length) {
        // Unchanged - keep original stroke
        newStrokes.add(stroke);
      } else {
        // Add each remaining segment as a new stroke
        for (final seg in keptSegments) {
          newStrokes.add(
            CanvasSketchStroke(
              points: seg,
              color: stroke.color,
              width: stroke.width,
            ),
          );
        }
      }
    }

    // Replace strokes in provider with the trimmed list
    ref
        .read(canvasSketchNotifierProvider.notifier)
        .setCanvasStrokes(newStrokes);
  }
}

/// Painter for canvas sketch strokes.
class _CanvasSketchOverlayPainter extends CustomPainter {
  _CanvasSketchOverlayPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    required this.currentTool,
    required this.isDrawing,
  });

  final List<CanvasSketchStroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;
  final SketchTool currentTool;
  final bool isDrawing;

  @override
  void paint(Canvas canvas, Size size) {
    // Only draw the current, in-progress stroke on the overlay (saved strokes are
    // rendered by the canvas content layer so they participate in transforms).
    if (isDrawing && currentPoints.isNotEmpty) {
      _drawStroke(
        canvas,
        currentPoints,
        currentColor,
        currentWidth,
        currentTool,
      );
    }
  }

  void _drawStroke(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double width,
    SketchTool tool,
  ) {
    if (points.length < 2) {
      if (points.isNotEmpty) {
        final paint = Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = width;
        canvas.drawCircle(points[0], width / 2, paint);
      }
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = _getToolWidth(tool, width)
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  double _getToolWidth(SketchTool tool, double baseWidth) {
    switch (tool) {
      case SketchTool.marker:
        return baseWidth * 1.5; // Wider
      case SketchTool.pencil:
        return baseWidth * 0.6; // Thinner
      case SketchTool.brush:
        return baseWidth * 1.2; // Slightly wider
      default:
        return baseWidth;
    }
  }

  @override
  bool shouldRepaint(_CanvasSketchOverlayPainter oldDelegate) {
    return isDrawing || oldDelegate.isDrawing || strokes != oldDelegate.strokes;
  }
}
