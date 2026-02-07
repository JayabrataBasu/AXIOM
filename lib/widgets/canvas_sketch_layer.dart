import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_sketch.dart';
import '../providers/canvas_sketch_provider.dart';
import '../providers/sketch_tools_provider.dart';
import 'canvas/infinite_canvas.dart';

/// Widget that displays and manages canvas-level sketches overlaid on the infinite canvas.
class CanvasSketchLayer extends ConsumerStatefulWidget {
  const CanvasSketchLayer({super.key});

  @override
  ConsumerState<CanvasSketchLayer> createState() => _CanvasSketchLayerState();
}

class _CanvasSketchLayerState extends ConsumerState<CanvasSketchLayer> {
  List<CanvasSketchPoint> _currentStroke = [];
  int _lastUpdateMillis = 0;
  static const int _throttleMs = 4; // Reduced from 8 for snappier feel

  @override
  Widget build(BuildContext context) {
    final sketchAsync = ref.watch(canvasSketchNotifierProvider);
    final toolState = ref.watch(sketchToolsProvider);
    final effectiveColor = toolState.color.withValues(alpha: toolState.opacity);
    final canvasScale = _currentCanvasScale(context);

    return sketchAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, stack) => const SizedBox.shrink(),
      data: (sketch) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            final toolState = ref.read(sketchToolsProvider);
            if (toolState.tool == SketchTool.selector) return;

            setState(() {
              _currentStroke = [
                CanvasSketchPoint(
                  x: details.localPosition.dx,
                  y: details.localPosition.dy,
                  pressure: 1.0,
                ),
              ];
            });
          },
          onPanUpdate: (details) {
            final toolState = ref.read(sketchToolsProvider);
            if (toolState.tool == SketchTool.selector) return;
            if (_currentStroke.isNotEmpty) {
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now - _lastUpdateMillis < _throttleMs) return;
              _lastUpdateMillis = now;

              setState(() {
                _currentStroke.add(
                  CanvasSketchPoint(
                    x: details.localPosition.dx,
                    y: details.localPosition.dy,
                    pressure: 1.0,
                  ),
                );
              });
            }
          },
          onPanEnd: (details) {
            if (_currentStroke.isEmpty) return;

            final toolState = ref.read(sketchToolsProvider);
            final notifier = ref.read(canvasSketchNotifierProvider.notifier);

            // Handle eraser tool by removing strokes at intersection points
            if (toolState.tool == SketchTool.eraser) {
              notifier.eraseStrokesAt(
                _currentStroke,
                toolState.brushSize / canvasScale,
              );
            } else {
              // Create stroke with current tool settings
              final stroke = CanvasSketchStroke(
                points: _currentStroke,
                color: effectiveColor.toARGB32(),
                width: _effectiveStrokeWidth(toolState) / canvasScale,
                isEraser: false,
              );
              notifier.addStroke(stroke);
            }
            setState(() {
              _currentStroke = [];
            });
          },
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _CanvasSketchLayerPainter(
                strokes: sketch.strokes,
                currentStroke: _currentStroke,
                currentColor: effectiveColor,
                currentWidth: _effectiveStrokeWidth(toolState) / canvasScale,
              ),
            ),
          ),
        );
      },
    );
  }

  double _currentCanvasScale(BuildContext context) {
    final canvasState = context.findAncestorStateOfType<InfiniteCanvasState>();
    return canvasState?.currentScale ?? 1.0;
  }

  double _effectiveStrokeWidth(SketchToolState toolState) {
    switch (toolState.tool) {
      case SketchTool.marker:
        return toolState.brushSize * 1.5;
      case SketchTool.pencil:
        return toolState.brushSize * 0.6;
      case SketchTool.brush:
        return toolState.brushSize * 1.2;
      default:
        return toolState.brushSize;
    }
  }
}

/// CustomPainter for rendering canvas sketch strokes.
class _CanvasSketchLayerPainter extends CustomPainter {
  _CanvasSketchLayerPainter({
    required this.strokes,
    required this.currentStroke,
    required this.currentColor,
    required this.currentWidth,
  });

  final List<CanvasSketchStroke> strokes;
  final List<CanvasSketchPoint> currentStroke;
  final Color currentColor;
  final double currentWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = Color(stroke.color)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.width;

      if (stroke.isEraser) {
        // For eraser, use blend mode to clear
        paint.blendMode = BlendMode.clear;
      }

      _drawStroke(canvas, paint, stroke.points);
    }

    // Draw current stroke
    if (currentStroke.isNotEmpty) {
      final paint = Paint()
        ..color = currentColor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = currentWidth;

      _drawStroke(canvas, paint, currentStroke);
    }
  }

  void _drawStroke(Canvas canvas, Paint paint, List<CanvasSketchPoint> points) {
    if (points.length < 2) {
      if (points.isNotEmpty) {
        final point = points[0];
        canvas.drawCircle(
          Offset(point.x, point.y),
          paint.strokeWidth / 2,
          paint,
        );
      }
      return;
    }

    // Use a single Path to avoid visual thickness doubling from
    // overlapping round caps on individual line segments.
    final strokePaint = Paint()
      ..color = paint.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke;

    if (paint.blendMode == BlendMode.clear) {
      strokePaint.blendMode = BlendMode.clear;
    }

    final path = Path();
    path.moveTo(points.first.x, points.first.y);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_CanvasSketchLayerPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentWidth != currentWidth;
  }
}
