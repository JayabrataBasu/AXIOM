import 'package:flutter/material.dart';
import '../../models/content_block.dart';
import '../../models/maths.dart';
import '../../services/maths_service.dart';
import '../../theme/design_tokens.dart';
import 'block_editors.dart';

/// Editor widget for displaying and managing maths reference blocks
class MathsRefBlockEditor extends StatefulWidget {
  const MathsRefBlockEditor({
    super.key,
    required this.block,
    required this.mathsService,
    required this.workspaceId,
    required this.dragIndex,
    required this.onDelete,
  });

  final MathsRefBlock block;
  final MathsService mathsService;
  final String workspaceId;
  final int dragIndex;
  final VoidCallback onDelete;

  @override
  State<MathsRefBlockEditor> createState() => _MathsRefBlockEditorState();
}

class _MathsRefBlockEditorState extends State<MathsRefBlockEditor> {
  late Future<MathsObject?> _mathsObjectFuture;

  @override
  void initState() {
    super.initState();
    _mathsObjectFuture = widget.mathsService.loadMathsObject(
      workspaceId: widget.workspaceId,
      objectId: widget.block.mathsObjectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlockEditorCard(
      key: ValueKey(widget.block.id),
      blockType: 'Maths',
      dragIndex: widget.dragIndex,
      onDelete: widget.onDelete,
      child: FutureBuilder<MathsObject?>(
        future: _mathsObjectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 60,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(cs.primary),
                    ),
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.error.withAlpha(25),
                borderRadius: BorderRadius.circular(AxiomRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: cs.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Maths object not found',
                          style: TextStyle(color: cs.error, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${widget.block.mathsObjectId.substring(0, 8)}...',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            );
          }

          final mathsObject = snapshot.data!;
          return _buildMathsDisplay(context, mathsObject, cs);
        },
      ),
    );
  }

  Widget _buildMathsDisplay(
    BuildContext context,
    MathsObject mathsObject,
    ColorScheme cs,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to full maths screen (placeholder - will implement later)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maths editor coming soon')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with type and title
            Row(
              children: [
                _getTypeIcon(mathsObject.type, cs),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mathsObject.name,
                        style: AxiomTypography.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        mathsObject.type == MathsObjectType.matrix
                            ? 'Matrix'
                            : 'Graph',
                        style: AxiomTypography.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_outward, size: 16, color: cs.primary),
              ],
            ),
            const SizedBox(height: 8),
            // Preview content
            _buildPreview(mathsObject, cs),
            const SizedBox(height: 8),
            // Last modified date
            Text(
              'Modified ${_formatDate(mathsObject.updatedAt)}',
              style: AxiomTypography.labelSmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(MathsObject mathsObject, ColorScheme cs) {
    return switch (mathsObject) {
      MatrixObject(:final data) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AxiomRadius.xs),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Matrix ${data.rows}×${data.cols}',
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            _buildMatrixPreview(data, cs),
          ],
        ),
      ),
      GraphObject(:final data) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AxiomRadius.xs),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Graph',
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            if (data.equations.isNotEmpty)
              Text(
                data.equations.first,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: cs.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                '(No equations)',
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
      _ => SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Unknown maths object',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
      ),
    };
  }

  Widget _buildMatrixPreview(MatrixData data, ColorScheme cs) {
    final preview = data.values.take(3).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: preview.map((row) {
        final displayRow = row.take(3).toList();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: displayRow.map((val) {
            return Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant, width: 0.5),
              ),
              child: Text(
                val.toStringAsFixed(0),
                style: TextStyle(fontSize: 8, color: cs.onSurface),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _getTypeIcon(MathsObjectType type, ColorScheme cs) {
    final icon = type == MathsObjectType.matrix
        ? Icons.table_chart_outlined
        : Icons.show_chart_outlined;
    final color = AxiomColors.yellow;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AxiomColors.yellow.withAlpha(25),
        borderRadius: BorderRadius.circular(AxiomRadius.sm),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
