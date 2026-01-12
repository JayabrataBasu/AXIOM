import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_sketch.dart';
import '../providers/canvas_sketch_provider.dart';
import '../providers/sketch_tools_provider.dart';
import 'canvas/infinite_canvas.dart';

/// Overlay for canvas-level sketching that sits above the infinite canvas.
/// Uses efficient rendering by minimizing setState calls.
class CanvasSketchOverlay extends ConsumerStatefulWidget {
  const CanvasSketchOverlay({
    super.key,
    required this.canvasKey,
  });

  final GlobalKey<InfiniteCanvasState> canvasKey;

  @override
  ConsumerState<CanvasSketchOverlay> createState() => _CanvasSketchOverlayState();
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
      error: (_, __) => const SizedBox.shrink(),
      data: (sketch) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            if (toolState.tool == SketchTool.selector || 
                toolState.tool == SketchTool.eraser) return;
            
            _isDrawing = true;
            _currentPoints = [details.localPosition];
            setState(() {});
          },
          onPanUpdate: (details) {
            if (!_isDrawing) return;
            
            // Add point without setState - just update the list
            _currentPoints.add(details.localPosition);
            
            // Force repaint by calling setState minimally
            (context as Element).markNeedsBuild();
          },
          onPanEnd: (details) {
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
                color: toolState.color.value,
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
              currentPoints: _currentPoints,
              currentColor: toolState.color,
              currentWidth: toolState.brushSize,
              isDrawing: _isDrawing,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

/// Painter for the current stroke being drawn (screen coordinates).
class _CanvasSketchOverlayPainter extends CustomPainter {
  _CanvasSketchOverlayPainter({
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    required this.isDrawing,
  });

  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;
  final bool isDrawing;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDrawing || currentPoints.length < 2) return;

    final paint = Paint()
      ..color = currentColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = currentWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(currentPoints.first.dx, currentPoints.first.dy);
    
    for (int i = 1; i < currentPoints.length; i++) {
      path.lineTo(currentPoints[i].dx, currentPoints[i].dy);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CanvasSketchOverlayPainter oldDelegate) {
    return isDrawing || oldDelegate.isDrawing;
  }
}
