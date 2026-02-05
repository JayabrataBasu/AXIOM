import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../theme/design_tokens.dart';

/// Visual card representation of an IdeaNode on the canvas.
/// Uses Everforest palette: bg1 surface, green accent for selection,
/// warm cream text (fg), muted grey for metadata.
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
    final highlightActive = widget.isHighlighted;

    // Everforest color scheme for node states
    final borderColor = widget.isSelected
        ? AxiomColors.green.withAlpha(200)
        : highlightActive
        ? AxiomColors.aqua.withAlpha(150)
        : AxiomColors.bg3.withAlpha(100);
    final borderWidth = widget.isSelected
        ? 1.5
        : highlightActive
        ? 1.3
        : 1.0;

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
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: highlightActive && !_isDragging ? 1.03 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(
              minWidth: 180,
              maxWidth: 280,
              minHeight: 60,
            ),
            decoration: BoxDecoration(
              // Everforest bg1 - slightly elevated from canvas bg0
              color: AxiomColors.bg1,
              borderRadius: BorderRadius.circular(AxiomRadius.md),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: [
                // Soft dark shadow (Everforest etched look)
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 6,
                  offset: const Offset(1, 3),
                ),
                // Glow effect when selected or highlighted
                if (widget.isSelected)
                  BoxShadow(
                    color: AxiomColors.green.withAlpha(50),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                else if (highlightActive)
                  BoxShadow(
                    color: AxiomColors.aqua.withAlpha(40),
                    blurRadius: 14,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(AxiomSpacing.sm + 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node preview content
                    if (widget.node.previewText.isNotEmpty)
                      Text(
                        widget.node.previewText,
                        style: AxiomTypography.bodySmall.copyWith(
                          color: AxiomColors.fg,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'Empty node',
                        style: AxiomTypography.labelSmall.copyWith(
                          color: AxiomColors.grey1,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: AxiomSpacing.xs),
                    // Block count indicator with icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 12,
                          color: AxiomColors.grey1,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.node.blocks.length} block${widget.node.blocks.length != 1 ? 's' : ''}',
                          style: AxiomTypography.labelSmall.copyWith(
                            color: AxiomColors.grey1,
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
