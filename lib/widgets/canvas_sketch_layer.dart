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
  final LayerLink _layerLink = LayerLink();

  void _onPointerDown(PointerDownEvent details) {
    final toolState = ref.read(sketchToolsProvider);
    
    // Only draw with drawing tools (not selector or eraser on empty canvas)
    if (toolState.tool == SketchTool.selector) return;
    
    _currentStroke = [
      CanvasSketchPoint(
        x: details.position.dx,
        y: details.position.dy,
        pressure: details.pressure,
      ),
    ];
  }

  void _onPointerMove(PointerMoveEvent details) {
    final toolState = ref.read(sketchToolsProvider);
    
    // Only draw with drawing tools
    if (toolState.tool == SketchTool.selector) return;
    
    if (_currentStroke.isNotEmpty) {
      setState(() {
        _currentStroke.add(
          CanvasSketchPoint(
            x: details.position.dx,
            y: details.position.dy,
            pressure: details.pressure,
          ),
        );
      });
    }
  }

  void _onPointerUp(PointerUpEvent details) {
    if (_currentStroke.isEmpty) return;
    
    final toolState = ref.read(sketchToolsProvider);
    final notifier = ref.read(canvasSketchNotifierProvider.notifier);

    // Create stroke with current tool settings
    final stroke = CanvasSketchStroke(
      points: _currentStroke,
      color: toolState.color.value,
      width: toolState.brushSize,
    );

    notifier.addStroke(stroke);
    setState(() {
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final sketchAsync = ref.watch(canvasSketchNotifierProvider);
    final toolState = ref.watch(sketchToolsProvider);

    return sketchAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sketch) {
        return Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          child: CustomPaint(
            painter: _CanvasSketchLayerPainter(
              strokes: sketch.strokes,
              currentStroke: _currentStroke,
              currentColor: toolState.color,
              currentWidth: toolState.brushSize,
            ),
            size: Size.infinite,
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
        final pressureWidth = (paint.strokeWidth * point.pressure).clamp(0.5, 50.0);
        final pressurePaint = Paint()
          ..color = paint.color.withValues(alpha: paint.color.alpha * point.pressure)
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
      
      final segmentPaint = Paint()
        ..color = paint.color.withValues(alpha: paint.color.alpha * avgPressure)
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
