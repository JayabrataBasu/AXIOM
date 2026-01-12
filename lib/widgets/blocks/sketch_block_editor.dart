import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import '../../models/models.dart';
import '../../models/content_block.dart';
import '../../services/sketch_service.dart';

/// Editor for SketchBlock - freehand drawing canvas.
class SketchBlockEditor extends StatefulWidget {
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
  State<SketchBlockEditor> createState() => _SketchBlockEditorState();
}

class _SketchBlockEditorState extends State<SketchBlockEditor> {
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

  void _onPointerDown(PointerDownEvent details) {
    _currentStroke = [
      SketchPoint.fromOffset(details.localPosition),
    ];
  }

  void _onPointerMove(PointerMoveEvent details) {
    if (_currentStroke.isNotEmpty) {
      setState(() {
        _currentStroke.add(SketchPoint.fromOffset(details.localPosition));
      });
    }
  }

  void _onPointerUp(PointerUpEvent details) {
    if (_currentStroke.isNotEmpty) {
      setState(() {
        _strokes.add(SketchStroke(points: _currentStroke));
        _currentStroke = [];
      });
      _saveStrokes();
    }
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
            child: Listener(
              onPointerDown: _onPointerDown,
              onPointerMove: _onPointerMove,
              onPointerUp: _onPointerUp,
              child: CustomPaint(
                painter: _SketchCanvasPainter(
                  strokes: _strokes,
                  currentStroke: _currentStroke,
                ),
                size: Size.infinite,
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
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// CustomPainter for rendering sketch strokes.
class _SketchCanvasPainter extends CustomPainter {
  _SketchCanvasPainter({required this.strokes, required this.currentStroke});

  final List<SketchStroke> strokes;
  final List<SketchPoint> currentStroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, paint, stroke.points);
    }

    // Draw current stroke
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, paint, currentStroke);
    }
  }

  void _drawStroke(Canvas canvas, Paint paint, List<SketchPoint> points) {
    if (points.length < 2) {
      // Draw a single point as a small circle
      if (points.isNotEmpty) {
        canvas.drawCircle(points[0].toOffset(), 2, paint);
      }
      return;
    }

    // Simple line path (perfect_freehand integration deferred)
    final path = Path()..moveTo(points[0].x, points[0].y);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SketchCanvasPainter oldDelegate) {
    return oldDelegate.strokes != strokes || oldDelegate.currentStroke != currentStroke;
  }
}
