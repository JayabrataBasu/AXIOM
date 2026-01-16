import 'package:flutter/material.dart';

/// Model for a doodle stroke drawn on the canvas
class DoodleStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final DateTime createdAt;

  DoodleStroke({
    required this.points,
    required this.color,
    required this.width,
    required this.createdAt,
  });
}

/// Painter for rendering doodle strokes on the canvas
class DoodleCanvasPainter extends CustomPainter {
  final List<DoodleStroke> strokes;
  final List<Offset> currentStroke;
  final Color currentColor;
  final double currentWidth;

  DoodleCanvasPainter({
    required this.strokes,
    required this.currentStroke,
    required this.currentColor,
    required this.currentWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all completed strokes using paths for better performance
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        // Single point - draw a circle
        canvas.drawCircle(stroke.points[0], stroke.width / 2, paint);
      } else {
        // Multiple points - draw as path
        final path = Path();
        path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

        for (int i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }

        canvas.drawPath(path, paint);
      }
    }

    // Draw current stroke being drawn
    if (currentStroke.isNotEmpty) {
      final paint = Paint()
        ..color = currentColor
        ..strokeWidth = currentWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (currentStroke.length == 1) {
        canvas.drawCircle(currentStroke[0], currentWidth / 2, paint);
      } else {
        final path = Path();
        path.moveTo(currentStroke[0].dx, currentStroke[0].dy);

        for (int i = 1; i < currentStroke.length; i++) {
          path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DoodleCanvasPainter oldDelegate) {
    return oldDelegate.strokes.length != strokes.length ||
        oldDelegate.currentStroke.length != currentStroke.length;
  }
}

/// Floating doodle toolbar for the canvas
class DoodleToolbar extends StatefulWidget {
  const DoodleToolbar({
    super.key,
    required this.isEnabled,
    required this.onEnableToggle,
    required this.onColorChanged,
    required this.onWidthChanged,
    required this.onClear,
    required this.color,
    required this.width,
  });

  final bool isEnabled;
  final VoidCallback onEnableToggle;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onWidthChanged;
  final VoidCallback onClear;
  final Color color;
  final double width;

  @override
  State<DoodleToolbar> createState() => _DoodleToolbarState();
}

class _DoodleToolbarState extends State<DoodleToolbar> {
  bool _showColorPicker = false;
  bool _showWidthPicker = false;

  final List<Color> _colorOptions = [
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 24,
      left: 24,
      child: AnimatedOpacity(
        opacity: widget.isEnabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle button
                Tooltip(
                  message: widget.isEnabled
                      ? 'Disable doodling'
                      : 'Enable doodling',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: widget.onEnableToggle,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.isEnabled
                              ? theme.colorScheme.primary.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.isEnabled
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.5,
                                  )
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          Icons.draw,
                          color: widget.isEnabled
                              ? theme.colorScheme.primary
                              : Colors.white.withValues(alpha: 0.4),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Color picker button
                Tooltip(
                  message: 'Change color',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: widget.isEnabled
                          ? () => setState(
                              () => _showColorPicker = !_showColorPicker,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: widget.color,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showColorPicker) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _colorOptions.map((color) {
                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            widget.onColorChanged(color);
                            setState(() => _showColorPicker = false);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: widget.color == color
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.2),
                                width: widget.color == color ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 8),
                // Width picker button
                Tooltip(
                  message: 'Change brush size',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: widget.isEnabled
                          ? () => setState(
                              () => _showWidthPicker = !_showWidthPicker,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.brush,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showWidthPicker) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 44,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.width.toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              value: widget.width,
                              min: 1,
                              max: 20,
                              onChanged: widget.isEnabled
                                  ? widget.onWidthChanged
                                  : null,
                              activeColor: theme.colorScheme.primary,
                              inactiveColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Clear button
                Tooltip(
                  message: 'Clear doodles',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: widget.isEnabled ? widget.onClear : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
