import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';

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
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        // Consume double-tap at the down phase to prevent canvas from also handling it
        onDoubleTapDown: (_) {
          // Do nothing - just consume the event
        },
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
            // Match Stitch design: surface-dark color with etched shadow
            color: const Color(0xFF24272C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? colorScheme.primary.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.05),
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              // Dark shadow on bottom-right
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(2, 4),
              ),
              // Glow effect when selected
              if (widget.isSelected)
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 0,
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'Empty node',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Block count indicator with icon
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.node.blocks.length} block${widget.node.blocks.length != 1 ? 's' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
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
