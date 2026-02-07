import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_sketch.dart';
import '../providers/canvas_sketch_provider.dart';
import '../providers/sketch_tools_provider.dart';

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
              notifier.eraseStrokesAt(_currentStroke, toolState.brushSize);
            } else {
              // Create stroke with current tool settings
              final stroke = CanvasSketchStroke(
                points: _currentStroke,
                color: toolState.color.toARGB32(),
                width: toolState.brushSize,
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
                currentColor: toolState.color,
                currentWidth: toolState.brushSize,
              ),
            ),
          ),
        );
      },
    );
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
        final pressureWidth = (paint.strokeWidth * point.pressure).clamp(
          0.5,
          50.0,
        );
        final pressureAlpha = (paint.color.a * point.pressure)
            .clamp(0, 255)
            .toDouble();
        final pressurePaint = Paint()
          ..color = paint.color.withValues(alpha: pressureAlpha)
          ..strokeCap = paint.strokeCap
          ..strokeJoin = paint.strokeJoin
          ..strokeWidth = pressureWidth;
        canvas.drawCircle(
          Offset(point.x, point.y),
          pressureWidth / 2,
          pressurePaint,
        );
      }
      return;
    }

    // Draw strokes with pressure-sensitive width
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // Use average pressure for this segment
      final avgPressure = (p0.pressure + p1.pressure) / 2;
      final pressureWidth = (paint.strokeWidth * avgPressure).clamp(0.5, 50.0);

      final segmentAlpha = (paint.color.a * avgPressure)
          .clamp(0, 255)
          .toDouble();
      final segmentPaint = Paint()
        ..color = paint.color.withValues(alpha: segmentAlpha)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = pressureWidth;

      canvas.drawLine(Offset(p0.x, p0.y), Offset(p1.x, p1.y), segmentPaint);
    }
  }

  @override
  bool shouldRepaint(_CanvasSketchLayerPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentWidth != currentWidth;
  }
}
