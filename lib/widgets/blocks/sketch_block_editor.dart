import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import '../../models/models.dart';
import '../../models/content_block.dart';
import '../../providers/sketch_tools_provider.dart';
import '../../services/sketch_service.dart';

/// Editor for SketchBlock - freehand drawing canvas with tool support.
class SketchBlockEditor extends ConsumerStatefulWidget {
  const SketchBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onDelete,
  });

  final ContentBlock block;
  final int dragIndex;
  final VoidCallback onDelete;

  @override
  ConsumerState<SketchBlockEditor> createState() => _SketchBlockEditorState();
}

class _SketchBlockEditorState extends ConsumerState<SketchBlockEditor> {
  late List<SketchStroke> _strokes;
  List<SketchPoint> _currentStroke = [];
  final SketchService _sketchService = SketchService.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStrokes();
  }

  Future<void> _loadStrokes() async {
    if (widget.block is! SketchBlock) {
      setState(() => _isLoading = false);
      return;
    }
    final block = widget.block as SketchBlock;
    final strokes = await _sketchService.loadStrokes(block.id);
    if (mounted) {
      setState(() {
        _strokes = strokes;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveStrokes() async {
    if (widget.block is! SketchBlock) return;
    final block = widget.block as SketchBlock;
    await _sketchService.saveStrokes(block.id, _strokes);
  }

  void _eraseAt(Offset position) {
    const eraserRadius = 15.0;
    _strokes.removeWhere((stroke) {
      return stroke.points.any((point) {
        final distance = (point.toOffset() - position).distance;
        return distance < eraserRadius;
      });
    });
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      _saveStrokes();
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
    _saveStrokes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolState = ref.watch(sketchToolsProvider);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              const Icon(Icons.drag_handle, size: 20),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SKETCH',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // Current tool indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: toolState.color.withValues(alpha: 0.2),
                  border: Border.all(color: toolState.color),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: toolState.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${toolState.brushSize.toStringAsFixed(1)}px',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.undo, size: 20),
                onPressed: _strokes.isEmpty ? null : _undo,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Undo last stroke',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Delete block',
              ),
            ],
          ),
        ),
        // Canvas
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: SizedBox(
            height: 300,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                final toolState = ref.read(sketchToolsProvider);
                if (toolState.tool == SketchTool.selector) {
                  return;
                }
                
                if (toolState.tool == SketchTool.eraser) {
                  // Erase strokes that overlap this point
                  _eraseAt(details.localPosition);
                  setState(() {});
                  return;
                }
                
                _currentStroke = [
                  SketchPoint.fromOffset(details.localPosition, pressure: 1.0),
                ];
                setState(() {});
              },
              onPanUpdate: (details) {
                final toolState = ref.read(sketchToolsProvider);
                
                if (toolState.tool == SketchTool.eraser) {
                  _eraseAt(details.localPosition);
                  setState(() {});
                  return;
                }
                
                if (_currentStroke.isNotEmpty) {
                  _currentStroke.add(
                    SketchPoint.fromOffset(details.localPosition, pressure: 1.0),
                  );
                  // Minimal repaint trigger
                  (context as Element).markNeedsBuild();
                }
              },
              onPanEnd: (details) {
                final toolState = ref.read(sketchToolsProvider);
                if (toolState.tool == SketchTool.eraser) {
                  _saveStrokes();
                  return;
                }
                
                if (_currentStroke.isNotEmpty) {
                  _strokes.add(SketchStroke(
                    points: List.from(_currentStroke),
                    color: toolState.color,
                    width: toolState.brushSize,
                  ));
                  _currentStroke = [];
                  setState(() {});
                  _saveStrokes();
                }
              },
              child: Stack(
                children: [
                  // Background
                  Container(color: Colors.white),
                  // Canvas
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _SketchCanvasPainter(
                        strokes: _strokes,
                        currentStroke: _currentStroke,
                        currentColor: toolState.color,
                        currentWidth: toolState.brushSize,
                        currentTool: toolState.tool,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Footer with actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_strokes.length} stroke${_strokes.length != 1 ? 's' : ''}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              TextButton.icon(
                onPressed: _strokes.isEmpty ? null : _clear,
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Display (non-editable) version of a sketch block.
class SketchBlockDisplay extends StatefulWidget {
  const SketchBlockDisplay({
    super.key,
    required this.block,
  });

  final ContentBlock block;

  @override
  State<SketchBlockDisplay> createState() => _SketchBlockDisplayState();
}

class _SketchBlockDisplayState extends State<SketchBlockDisplay> {
  late List<SketchStroke> _strokes;
  final SketchService _sketchService = SketchService.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStrokes();
  }

  Future<void> _loadStrokes() async {
    if (widget.block is! SketchBlock) {
      setState(() => _isLoading = false);
      return;
    }
    final block = widget.block as SketchBlock;
    final strokes = await _sketchService.loadStrokes(block.id);
    if (mounted) {
      setState(() {
        _strokes = strokes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () => debugPrint('Sketch display tapped'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: _SketchCanvasPainter(
            strokes: _strokes,
            currentStroke: [],
            currentColor: Colors.black,
            currentWidth: 2.0,
            currentTool: SketchTool.pen,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// CustomPainter for rendering sketch strokes with color and width support.
class _SketchCanvasPainter extends CustomPainter {
  _SketchCanvasPainter({
    required this.strokes,
    required this.currentStroke,
    required this.currentColor,
    required this.currentWidth,
    required this.currentTool,
  });

  final List<SketchStroke> strokes;
  final List<SketchPoint> currentStroke;
  final Color currentColor;
  final double currentWidth;
  final SketchTool currentTool;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes with their own colors and widths
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.width;

      _drawStroke(canvas, paint, stroke.points, SketchTool.pen);
    }

    // Draw current stroke with current tool settings
    if (currentStroke.isNotEmpty) {
      final paint = Paint()
        ..color = currentColor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = _getToolWidth(currentTool, currentWidth);

      _drawStroke(canvas, paint, currentStroke, currentTool);
    }
  }

  double _getToolWidth(SketchTool tool, double baseWidth) {
    switch (tool) {
      case SketchTool.marker:
        return baseWidth * 1.5; // Wider
      case SketchTool.pencil:
        return baseWidth * 0.6; // Thinner
      case SketchTool.brush:
        return baseWidth * 1.2; // Slightly wider, smoother
      default:
        return baseWidth;
    }
  }

  void _drawStroke(Canvas canvas, Paint paint, List<SketchPoint> points, SketchTool tool) {
    if (points.length < 2) {
      // Draw a single point as a small circle
      if (points.isNotEmpty) {
        final point = points[0];
        final pressureWidth = (paint.strokeWidth * point.pressure).clamp(0.5, 50.0);
        final pressurePaint = Paint()
          ..color = paint.color.withValues(alpha: paint.color.alpha * point.pressure)
          ..strokeCap = paint.strokeCap
          ..strokeJoin = paint.strokeJoin
          ..strokeWidth = pressureWidth;
        canvas.drawCircle(point.toOffset(), pressureWidth / 2, pressurePaint);
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

      canvas.drawLine(p0.toOffset(), p1.toOffset(), segmentPaint);
    }
  }

  @override
  bool shouldRepaint(_SketchCanvasPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentWidth != currentWidth ||
        oldDelegate.currentTool != currentTool;
  }
}
