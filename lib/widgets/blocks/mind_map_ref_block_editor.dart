import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/design_tokens.dart';
import '../../models/models.dart';
import '../../services/mind_map_service.dart';
import '../../screens/mind_map_screen.dart';

/// Editor for MindMapRefBlock - displays a reference to a mind map with navigation.
class MindMapRefBlockEditor extends ConsumerStatefulWidget {
  const MindMapRefBlockEditor({
    super.key,
    required this.block,
    required this.dragIndex,
    required this.onDelete,
    required this.workspaceId,
  });

  final ContentBlock block;
  final int dragIndex;
  final VoidCallback onDelete;
  final String workspaceId;

  @override
  ConsumerState<MindMapRefBlockEditor> createState() =>
      _MindMapRefBlockEditorState();
}

class _MindMapRefBlockEditorState extends ConsumerState<MindMapRefBlockEditor> {
  final MindMapService _mindMapService = MindMapService.instance;
  bool _isLoading = true;
  MindMapGraph? _mindMap;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMindMap();
  }

  Future<void> _loadMindMap() async {
    if (widget.block is! MindMapRefBlock) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid block type';
      });
      return;
    }

    final block = widget.block as MindMapRefBlock;
    try {
      final mindMap = await _mindMapService.loadMindMap(
        widget.workspaceId,
        block.mapId,
      );
      if (mounted) {
        setState(() {
          _mindMap = mindMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Mind map not found';
          _isLoading = false;
        });
      }
    }
  }

  void _openMindMap() {
    if (_mindMap == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MindMapScreen(
          workspaceId: _mindMap!.workspaceId,
          mapId: _mindMap!.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final block = widget.block as MindMapRefBlock;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AxiomSpacing.xs),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AxiomRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AxiomSpacing.sm + 2,
              vertical: AxiomSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
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
                    color: AxiomColors.purple.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MIND MAP',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
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
          // Content
          InkWell(
            onTap: _isLoading || _errorMessage != null ? null : _openMindMap,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AxiomRadius.md),
            ),
            child: Container(
              padding: EdgeInsets.all(AxiomSpacing.md),
              child: _isLoading
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: cs.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : _errorMessage != null
                  ? Row(
                      children: [
                        Icon(Icons.error_outline, color: cs.error, size: 24),
                        SizedBox(width: AxiomSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AxiomTypography.bodyMedium.copyWith(
                              color: cs.error,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        // Mind map icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AxiomColors.purple.withAlpha(25),
                            borderRadius: BorderRadius.circular(AxiomRadius.sm),
                            border: Border.all(
                              color: AxiomColors.purple.withAlpha(100),
                            ),
                          ),
                          child: Icon(
                            Icons.account_tree,
                            color: AxiomColors.purple,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: AxiomSpacing.md),
                        // Mind map info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _mindMap?.name ?? block.label,
                                style: AxiomTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: AxiomSpacing.xs / 2),
                              Text(
                                '${_mindMap?.nodes.length ?? 0} nodes',
                                style: AxiomTypography.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AxiomSpacing.sm),
                        // Open button
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Display (non-editable) version of a mind map ref block.
class MindMapRefBlockDisplay extends ConsumerStatefulWidget {
  const MindMapRefBlockDisplay({super.key, required this.block});

  final ContentBlock block;

  @override
  ConsumerState<MindMapRefBlockDisplay> createState() =>
      _MindMapRefBlockDisplayState();
}

class _MindMapRefBlockDisplayState
    extends ConsumerState<MindMapRefBlockDisplay> {
  bool _isLoading = true;
  MindMapGraph? _mindMap;

  @override
  void initState() {
    super.initState();
    _loadMindMap();
  }

  Future<void> _loadMindMap() async {
    if (widget.block is! MindMapRefBlock) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // We need workspaceId to load the mind map
      // For display blocks, we can't easily access it, so just show the label
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openMindMap() {
    if (_mindMap == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MindMapScreen(
          workspaceId: _mindMap!.workspaceId,
          mapId: _mindMap!.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final block = widget.block as MindMapRefBlock;

    return InkWell(
      onTap: _isLoading || _mindMap == null ? null : _openMindMap,
      borderRadius: BorderRadius.circular(AxiomRadius.sm),
      child: Container(
        padding: EdgeInsets.all(AxiomSpacing.sm),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: _isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: cs.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: AxiomSpacing.sm),
                  Text(
                    'Loading...',
                    style: AxiomTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_tree, color: AxiomColors.purple, size: 20),
                  SizedBox(width: AxiomSpacing.sm),
                  Text(
                    _mindMap?.name ?? block.label,
                    style: AxiomTypography.bodySmall.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
