import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../theme/design_tokens.dart';

/// Visual card representation of an IdeaNode on the canvas.
/// Theme-aware: uses ColorScheme for automatic light/dark adaptation.
class IdeaNodeCard extends ConsumerStatefulWidget {
  const IdeaNodeCard({
    super.key,
    required this.node,
    required this.isSelected,
    required this.isHighlighted,
    required this.onTap,
    required this.onDoubleTap,
    required this.onDragEnd,
  });

  final IdeaNode node;
  final bool isSelected;
  final bool isHighlighted;
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
    final cs = Theme.of(context).colorScheme;
    final highlightActive = widget.isHighlighted;

    final borderColor = widget.isSelected
        ? cs.primary.withAlpha(200)
        : highlightActive
            ? cs.secondary.withAlpha(150)
            : cs.outlineVariant.withAlpha(80);
    final borderWidth = widget.isSelected
        ? 2.0
        : highlightActive
            ? 1.5
            : 1.0;

    return Transform.translate(
      offset: _isDragging ? _dragOffset : Offset.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onDoubleTapDown: (_) {},
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
        child: AnimatedScale(
          duration: AxiomDurations.fast,
          scale: highlightActive && !_isDragging ? 1.03 : 1.0,
          child: AnimatedContainer(
            duration: AxiomDurations.fast,
            constraints: const BoxConstraints(
              minWidth: 180,
              maxWidth: 280,
              minHeight: 60,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AxiomRadius.lg),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withAlpha(30),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
                if (widget.isSelected)
                  BoxShadow(
                    color: cs.primary.withAlpha(30),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                else if (highlightActive)
                  BoxShadow(
                    color: cs.secondary.withAlpha(25),
                    blurRadius: 14,
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(AxiomSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node preview content
                    if (widget.node.previewText.isNotEmpty)
                      Text(
                        widget.node.previewText,
                        style: AxiomTypography.bodySmall.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'Empty node',
                        style: AxiomTypography.labelSmall.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(150),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: AxiomSpacing.sm),
                    // Block count indicator
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 12,
                          color: cs.onSurfaceVariant.withAlpha(150),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.node.blocks.length} block${widget.node.blocks.length != 1 ? 's' : ''}',
                          style: AxiomTypography.labelSmall.copyWith(
                            color: cs.onSurfaceVariant.withAlpha(150),
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
      ),
    );
  }
}
