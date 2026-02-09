import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/design_tokens.dart';
import '../../models/models.dart';
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
  bool _isDrawing = false;
  int _lastUpdateMillis = 0;
  static const int _throttleMs = 4;

  /// ValueNotifier to trigger only CustomPaint repaints, not full widget rebuilds
  late final ValueNotifier<List<SketchPoint>> _currentStrokeNotifier;
  late final ValueNotifier<List<SketchStroke>> _strokesNotifier;

  /// Get the block ID for per-block tool state
  String get _blockId => (widget.block as SketchBlock).id;

  void _startStroke(Offset position, SketchToolState toolState) {
    if (toolState.tool == SketchTool.selector) return;

    _isDrawing = true;

    if (toolState.tool == SketchTool.eraser) {
      _eraseAt(position);
      _strokesNotifier.value = List.from(_strokes);
      return;
    }

    final point = SketchPoint.fromOffset(position, pressure: 1.0);
    _currentStroke = [point];
    _currentStrokeNotifier.value = List.from(_currentStroke);
  }

  void _updateStroke(Offset position, SketchToolState toolState) {
    if (toolState.tool == SketchTool.selector) return;

    if (toolState.tool == SketchTool.eraser) {
      _eraseAt(position);
      _strokesNotifier.value = List.from(_strokes);
      return;
    }

    if (_currentStroke.isNotEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastUpdateMillis < _throttleMs) return;
      _lastUpdateMillis = now;

      _currentStroke.add(SketchPoint.fromOffset(position, pressure: 1.0));
      _currentStrokeNotifier.value = List.from(_currentStroke);
    }
  }

  void _endStroke(SketchToolState toolState) {
    if (toolState.tool == SketchTool.eraser) {
      _saveStrokes();
      _isDrawing = false;
      return;
    }

    if (_currentStroke.isNotEmpty) {
      _strokes.add(
        SketchStroke(
          points: List.from(_currentStroke),
          color: _effectiveColorForTool(toolState),
          width: _effectiveStrokeWidth(toolState),
          tool: toolState.tool, // Save the tool type with the stroke
        ),
      );
      _strokesNotifier.value = List.from(_strokes);
      _currentStroke = [];
      _currentStrokeNotifier.value = [];
      _saveStrokes();
    }
    _isDrawing = false;
  }

  Color _effectiveColorForTool(SketchToolState toolState) {
    final toolColor = toolState.color;
    return toolColor.withValues(alpha: toolState.opacity);
  }

  @override
  void initState() {
    super.initState();
    _currentStrokeNotifier = ValueNotifier<List<SketchPoint>>([]);
    _strokesNotifier = ValueNotifier<List<SketchStroke>>([]);
    _loadStrokes();
  }

  @override
  void dispose() {
    _currentStrokeNotifier.dispose();
    _strokesNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadStrokes() async {
    if (widget.block is! SketchBlock) {
      setState(() => _isLoading = false);
      return;
    }
    final block = widget.block as SketchBlock;
    final strokes = await _sketchService.loadStrokes(block.id);
    if (mounted) {
      _strokes = strokes;
      _strokesNotifier.value = List.from(_strokes);
      setState(() {
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

  /// Build a compact tool button
  Widget _buildToolButton(
    BuildContext context,
    SketchTool tool,
    IconData icon,
    SketchToolState toolState,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = toolState.tool == tool;

    return InkWell(
      onTap: () =>
          ref.read(sketchToolsBlockProvider(_blockId).notifier).setTool(tool),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Build a compact color button
  Widget _buildColorButton(
    BuildContext context,
    Color color,
    SketchToolState toolState,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = toolState.color == color;

    return Padding(
      padding: EdgeInsets.only(right: AxiomSpacing.xs),
      child: InkWell(
        onTap: () => ref
            .read(sketchToolsBlockProvider(_blockId).notifier)
            .setColor(color),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? cs.primary : cs.outlineVariant,
              width: isSelected ? 3 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withAlpha(50),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final toolState = ref.watch(sketchToolsBlockProvider(_blockId));
    final effectiveColor = toolState.color.withValues(alpha: toolState.opacity);

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    return Column(
      children: [
        // Header - Everforest styled
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AxiomSpacing.sm + 2,
            vertical: AxiomSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AxiomRadius.md),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.drag_handle, size: 20, color: cs.onSurfaceVariant),
              SizedBox(width: AxiomSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AxiomColors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SKETCH',
                  style: AxiomTypography.labelSmall.copyWith(
                    color: AxiomColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // Current tool indicator - Everforest styled
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: toolState.color.withAlpha(50),
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
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AxiomSpacing.sm),
              IconButton(
                icon: Icon(
                  Icons.undo,
                  size: 20,
                  color: _strokes.isEmpty ? cs.outlineVariant : cs.onSurface,
                ),
                onPressed: _strokes.isEmpty ? null : _undo,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Undo last stroke',
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20, color: cs.error),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Delete block',
              ),
            ],
          ),
        ),
        // Tool Controls - Compact per-block tool selection
        Container(
          padding: EdgeInsets.all(AxiomSpacing.sm + 2),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            border: Border(
              bottom: BorderSide(color: cs.outlineVariant, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tool buttons row
              Row(
                children: [
                  _buildToolButton(
                    context,
                    SketchTool.pen,
                    Icons.edit,
                    toolState,
                  ),
                  SizedBox(width: AxiomSpacing.xs),
                  _buildToolButton(
                    context,
                    SketchTool.marker,
                    Icons.border_color,
                    toolState,
                  ),
                  SizedBox(width: AxiomSpacing.xs),
                  _buildToolButton(
                    context,
                    SketchTool.brush,
                    Icons.brush,
                    toolState,
                  ),
                  SizedBox(width: AxiomSpacing.xs),
                  _buildToolButton(
                    context,
                    SketchTool.pencil,
                    Icons.create,
                    toolState,
                  ),
                  SizedBox(width: AxiomSpacing.xs),
                  _buildToolButton(
                    context,
                    SketchTool.eraser,
                    Icons.auto_fix_normal,
                    toolState,
                  ),
                ],
              ),
              SizedBox(height: AxiomSpacing.sm),
              // Color quick-select
              Row(
                children: [
                  Text(
                    'Color: ',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildColorButton(context, Colors.black, toolState),
                          _buildColorButton(
                            context,
                            AxiomColors.red,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.orange,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.yellow,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.green,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.aqua,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.blue,
                            toolState,
                          ),
                          _buildColorButton(
                            context,
                            AxiomColors.purple,
                            toolState,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AxiomSpacing.sm),
              // Size slider
              Row(
                children: [
                  Text(
                    'Size: ',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: toolState.brushSize,
                      min: 1.0,
                      max: 50.0,
                      divisions: 49,
                      onChanged: (value) => ref
                          .read(sketchToolsBlockProvider(_blockId).notifier)
                          .setBrushSize(value),
                    ),
                  ),
                  Text(
                    '${toolState.brushSize.toStringAsFixed(1)}px',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              // Opacity slider
              Row(
                children: [
                  Text(
                    'Opacity: ',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: toolState.opacity,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (value) => ref
                          .read(sketchToolsBlockProvider(_blockId).notifier)
                          .setOpacity(value),
                    ),
                  ),
                  Text(
                    '${(toolState.opacity * 100).toStringAsFixed(0)}%',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Canvas - Everforest bg5 (lightest) for drawing area
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AxiomRadius.md),
            ),
          ),
          child: SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AxiomRadius.md),
              ),
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  final toolState = ref.read(
                    sketchToolsBlockProvider(_blockId),
                  );
                  _startStroke(event.localPosition, toolState);
                },
                onPointerMove: (event) {
                  if (!_isDrawing) {
                    return;
                  }
                  final toolState = ref.read(
                    sketchToolsBlockProvider(_blockId),
                  );
                  _updateStroke(event.localPosition, toolState);
                },
                onPointerUp: (event) {
                  final toolState = ref.read(
                    sketchToolsBlockProvider(_blockId),
                  );
                  _endStroke(toolState);
                },
                onPointerCancel: (event) {
                  _isDrawing = false;
                  _currentStroke = [];
                  _currentStrokeNotifier.value = [];
                },
                child: Stack(
                  children: [
                    // Background - Everforest bg5 for sketch canvas
                    Container(color: AxiomColors.bg5),
                    // Canvas - ValueListenableBuilder for low-latency repainting
                    RepaintBoundary(
                      child: ValueListenableBuilder<List<SketchPoint>>(
                        valueListenable: _currentStrokeNotifier,
                        builder: (context, currentStroke, _) {
                          return ValueListenableBuilder<List<SketchStroke>>(
                            valueListenable: _strokesNotifier,
                            builder: (context, strokes, _) {
                              return CustomPaint(
                                painter: _SketchCanvasPainter(
                                  strokes: strokes,
                                  currentStroke: currentStroke,
                                  currentColor: effectiveColor,
                                  currentWidth: toolState.brushSize,
                                  currentTool: toolState.tool,
                                ),
                                size: Size.infinite,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Footer with actions - Everforest styled
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AxiomSpacing.sm + 2,
            vertical: AxiomSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AxiomRadius.md),
            ),
          ),
          child: ValueListenableBuilder<List<SketchStroke>>(
            valueListenable: _strokesNotifier,
            builder: (context, strokes, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${strokes.length} stroke${strokes.length != 1 ? 's' : ''}',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: strokes.isEmpty ? null : _clear,
                    icon: Icon(
                      Icons.clear,
                      size: 18,
                      color: strokes.isEmpty ? cs.outlineVariant : cs.error,
                    ),
                    label: Text(
                      'Clear',
                      style: TextStyle(
                        color: strokes.isEmpty ? cs.outlineVariant : cs.error,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
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

/// Display (non-editable) version of a sketch block.
class SketchBlockDisplay extends StatefulWidget {
  const SketchBlockDisplay({super.key, required this.block});

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
    final cs = Theme.of(context).colorScheme;
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    return GestureDetector(
      onTap: () => debugPrint('Sketch display tapped'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        child: CustomPaint(
          painter: _SketchCanvasPainter(
            strokes: _strokes,
            currentStroke: [],
            currentColor: cs.onSurface,
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
    // Draw completed strokes with their own colors, widths, and tool types
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.width;

      _drawStroke(canvas, paint, stroke.points, stroke.tool);
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

  void _drawStroke(
    Canvas canvas,
    Paint paint,
    List<SketchPoint> points,
    SketchTool tool,
  ) {
    if (points.isEmpty) return;

    // Single point handling
    if (points.length < 2) {
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
      canvas.drawCircle(point.toOffset(), pressureWidth / 2, pressurePaint);
      return;
    }

    // Tool-specific rendering
    switch (tool) {
      case SketchTool.marker:
        _drawMarkerStroke(canvas, paint, points);
        break;
      case SketchTool.brush:
        _drawBrushStroke(canvas, paint, points);
        break;
      case SketchTool.pencil:
        _drawPencilStroke(canvas, paint, points);
        break;
      case SketchTool.pen:
      default:
        _drawPenStroke(canvas, paint, points);
        break;
    }
  }

  /// Pen: Smooth, consistent line
  void _drawPenStroke(Canvas canvas, Paint paint, List<SketchPoint> points) {
    final strokePaint = Paint()
      ..color = paint.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.toOffset().dx, points.first.toOffset().dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].toOffset().dx, points[i].toOffset().dy);
    }

    canvas.drawPath(path, strokePaint);
  }

  /// Marker: Soft, semi-transparent overlapping circles for blended effect
  void _drawMarkerStroke(Canvas canvas, Paint paint, List<SketchPoint> points) {
    // Marker has extra transparency and softer edges
    final markerPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    // Draw overlapping circles for soft blended texture
    final spacing = (paint.strokeWidth * 0.3).clamp(1.0, 10.0);

    for (int i = 0; i < points.length; i++) {
      // Skip some points based on spacing
      if (i > 0 && i < points.length - 1) {
        final dist = (points[i].toOffset() - points[i - 1].toOffset()).distance;
        if (dist < spacing) continue;
      }

      final point = points[i];
      final radius = paint.strokeWidth * 0.6;
      canvas.drawCircle(point.toOffset(), radius, markerPaint);
    }
  }

  /// Brush: Variable-width path with pressure sensitivity and smooth edges
  void _drawBrushStroke(Canvas canvas, Paint paint, List<SketchPoint> points) {
    // Brush has slight transparency and variable width
    final brushPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.85)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw variable-width segments
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      // Vary width based on position in stroke (thicker in middle)
      final progress = i / points.length;
      final widthVariation = (1.0 - (progress - 0.5).abs() * 2) * 0.3 + 0.7;
      final segmentWidth = paint.strokeWidth * widthVariation * p1.pressure;

      // Draw segment with variable width
      final offset1 = p1.toOffset();
      final offset2 = p2.toOffset();

      canvas.drawLine(offset1, offset2, brushPaint..strokeWidth = segmentWidth);
    }
  }

  /// Pencil: Thin line with slight opacity variation for grainy texture
  void _drawPencilStroke(Canvas canvas, Paint paint, List<SketchPoint> points) {
    final basePath = Path();
    basePath.moveTo(points.first.toOffset().dx, points.first.toOffset().dy);

    for (int i = 1; i < points.length; i++) {
      basePath.lineTo(points[i].toOffset().dx, points[i].toOffset().dy);
    }

    // Main pencil stroke
    final pencilPaint = Paint()
      ..color = paint.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(basePath, pencilPaint);

    // Add texture with slightly offset thin lines (grain effect)
    final texturePaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.15)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = paint.strokeWidth * 0.3
      ..style = PaintingStyle.stroke;

    // Sample every few points to add texture variation
    for (int i = 0; i < points.length - 1; i += 3) {
      final p1 = points[i].toOffset();
      final p2 = points[i + 1].toOffset();

      // Slight offset for grain effect
      final offset = Offset(0.3, 0.3);
      canvas.drawLine(p1 + offset, p2 + offset, texturePaint);
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
