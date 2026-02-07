import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sketch_tools_provider.dart';
import '../services/settings_service.dart';

/// Floating palette for sketch tools with color picker, brush size, and tool selection.
/// Position is persisted across sessions.
class SketchToolsPalette extends ConsumerStatefulWidget {
  const SketchToolsPalette({super.key});

  @override
  ConsumerState<SketchToolsPalette> createState() => _SketchToolsPaletteState();
}

class _SketchToolsPaletteState extends ConsumerState<SketchToolsPalette> {
  Offset _position = const Offset(1300, 20); // Default position
  final _settingsService = SettingsService.instance;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final saved = await _settingsService.get('sketchPalettePosition');
    if (saved != null && saved is Map) {
      setState(() {
        _position = Offset(
          (saved['x'] as num).toDouble(),
          (saved['y'] as num).toDouble(),
        );
      });
    }
  }

  Future<void> _savePosition() async {
    await _settingsService.set('sketchPalettePosition', {
      'x': _position.dx,
      'y': _position.dy,
    });
  }

  // Expanded color palette with more options
  static const List<Color> _colors = [
    // Neutrals
    Colors.black,
    Colors.white,
    Colors.grey,
    // Reds
    Colors.red,
    Color(0xFFE57373),
    Color(0xFFEF5350),
    // Oranges
    Colors.orange,
    Color(0xFFFFB74D),
    Color(0xFFFFA726),
    // Yellows
    Colors.yellow,
    Color(0xFFFDD835),
    Color(0xFFFFD54F),
    // Greens
    Colors.green,
    Color(0xFF81C784),
    Color(0xFF66BB6A),
    // Blues
    Colors.blue,
    Color(0xFF64B5F6),
    Color(0xFF42A5F5),
    // Purples
    Colors.purple,
    Color(0xFFBA68C8),
    Color(0xFFAB47BC),
    // Pinks
    Colors.pink,
    Color(0xFFF06292),
    Color(0xFFEC407A),
    // Cyans
    Colors.cyan,
    Color(0xFF4DD0E1),
    Color(0xFF26C6DA),
  ];

  @override
  Widget build(BuildContext context) {
    final toolState = ref.watch(sketchToolsProvider);
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: _position.dx.clamp(0, screenSize.width - 280),
      top: _position.dy.clamp(0, screenSize.height - 400),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
          _savePosition();
        },
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 8,
          child: Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with drag handle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.drag_handle,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Sketch',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isExpanded ? Icons.unfold_less : Icons.unfold_more,
                          ),
                          onPressed: () {
                            setState(() => _isExpanded = !_isExpanded);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ),
                  // All sections below header collapse together
                  if (_isExpanded) ...[
                    // Tools section
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tool',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.2,
                            children: [
                              _ToolButton(
                                icon: Icons.edit,
                                label: 'Pen',
                                isSelected: toolState.tool == SketchTool.pen,
                                onPressed: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setTool(SketchTool.pen);
                                },
                              ),
                              _ToolButton(
                                icon: Icons.brush,
                                label: 'Brush',
                                isSelected: toolState.tool == SketchTool.brush,
                                onPressed: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setTool(SketchTool.brush);
                                },
                              ),
                              _ToolButton(
                                icon: Icons.border_color,
                                label: 'Marker',
                                isSelected: toolState.tool == SketchTool.marker,
                                onPressed: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setTool(SketchTool.marker);
                                },
                              ),
                              _ToolButton(
                                icon: Icons.edit_outlined,
                                label: 'Pencil',
                                isSelected: toolState.tool == SketchTool.pencil,
                                onPressed: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setTool(SketchTool.pencil);
                                },
                              ),
                              _ToolButton(
                                icon: Icons.cleaning_services,
                                label: 'Eraser',
                                isSelected: toolState.tool == SketchTool.eraser,
                                onPressed: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setTool(SketchTool.eraser);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  // Color palette — also collapses
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            crossAxisCount: 6,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: _colors.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .read(sketchToolsProvider.notifier)
                                      .setColor(color);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: toolState.color == color
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: toolState.color == color ? 2 : 0,
                                    ),
                                    boxShadow: toolState.color == color
                                        ? [
                                            BoxShadow(
                                              color: color.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: toolState.color == color
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  if (_isExpanded) const Divider(height: 1),

                  // Brush size slider — also collapses
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Brush Size',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${toolState.brushSize.toStringAsFixed(1)}px',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: toolState.brushSize,
                            min: 1.0,
                            max: 50.0,
                            divisions: 49,
                            onChanged: (value) {
                              ref
                                  .read(sketchToolsProvider.notifier)
                                  .setBrushSize(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  if (_isExpanded) const Divider(height: 1),

                  // Opacity slider — also collapses
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Opacity',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${(toolState.opacity * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: toolState.opacity,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            onChanged: (value) {
                              ref
                                  .read(sketchToolsProvider.notifier)
                                  .setOpacity(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  if (_isExpanded) const Divider(height: 1),

                  // Footer — compact when collapsed
                  if (_isExpanded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Drag to move palette',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual tool button for the palette.
class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                  ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
