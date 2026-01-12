import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// Visual card representation of an IdeaNode on the canvas.
class IdeaNodeCard extends ConsumerStatefulWidget {
  const IdeaNodeCard({
    super.key,
    required this.node,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
    required this.onDragEnd,
  });

  final IdeaNode node;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final ValueChanged<Offset> onDragEnd;

  @override
  ConsumerState<IdeaNodeCard> createState() => _IdeaNodeCardState();
}

class _IdeaNodeCardState extends ConsumerState<IdeaNodeCard> {
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Transform.translate(
      offset: _isDragging ? _dragOffset : Offset.zero,
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onPanStart: (_) {
          setState(() {
            _isDragging = true;
            _dragOffset = Offset.zero;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _dragOffset += details.delta;
          });
        },
        onPanEnd: (_) {
          final finalOffset = _dragOffset;
          setState(() {
            _isDragging = false;
            _dragOffset = Offset.zero;
          });
          widget.onDragEnd(finalOffset);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(
            minWidth: 180,
            maxWidth: 280,
            minHeight: 60,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isDragging ? 0.2 : 0.08),
                blurRadius: _isDragging ? 12 : 6,
                offset: Offset(0, _isDragging ? 6 : 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Node preview content
                  if (widget.node.previewText.isNotEmpty)
                    Text(
                      widget.node.previewText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'Empty node',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Block count indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 14,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.node.blocks.length} block${widget.node.blocks.length != 1 ? 's' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
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
