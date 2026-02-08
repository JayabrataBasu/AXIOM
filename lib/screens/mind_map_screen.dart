import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mind_map.dart';
import '../models/position.dart';
import '../providers/mind_map_provider.dart';
import '../theme/design_tokens.dart';

/// Full-screen mind map editor with touch gestures
class MindMapScreen extends ConsumerStatefulWidget {
  const MindMapScreen({
    super.key,
    required this.workspaceId,
    required this.mapId,
  });

  final String workspaceId;
  final String mapId;

  @override
  ConsumerState<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends ConsumerState<MindMapScreen> {
  final TransformationController _transformController =
      TransformationController();
  String? _selectedNodeId;
  String? _editingNodeId;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _transformController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapAsync = ref.watch(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )),
    );
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: mapAsync.whenOrNull(
          data: (map) => Text(
            map.name,
            style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: cs.primary),
            onPressed: () => _showAddNodeDialog(context),
            tooltip: 'Add root node',
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: cs.onSurfaceVariant),
            onPressed: () {
              ref
                  .read(
                    mindMapNotifierProvider((
                      workspaceId: widget.workspaceId,
                      mapId: widget.mapId,
                    )).notifier,
                  )
                  .reload();
            },
            tooltip: 'Reload',
          ),
        ],
      ),
      body: mapAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: cs.primary)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: 16),
              Text('Error: $error', style: TextStyle(color: cs.error)),
            ],
          ),
        ),
        data: (map) => InteractiveViewer(
          transformationController: _transformController,
          boundaryMargin: const EdgeInsets.all(2000),
          minScale: 0.1,
          maxScale: 4.0,
          child: CustomPaint(
            painter: _MindMapPainter(
              map: map,
              selectedNodeId: _selectedNodeId,
              colorScheme: cs,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => _handleTap(details.localPosition, map),
              onLongPressStart: (details) =>
                  _handleLongPress(details.localPosition, map),
              child: SizedBox(
                width: 4000,
                height: 4000,
                child: Stack(
                  children: map.nodes.values.map((node) {
                    return Positioned(
                      left: node.position.x - 75,
                      top: node.position.y - 40,
                      child: GestureDetector(
                        onTap: () => _selectNode(node.id),
                        onLongPress: () => _showNodeContextMenu(node),
                        onPanUpdate: (details) =>
                            _handleNodeDrag(node.id, details.delta),
                        child: _buildNodeWidget(node, cs),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedNodeId != null
          ? FloatingActionButton(
              backgroundColor: cs.secondary,
              onPressed: () => _addChildToSelected(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildNodeWidget(MindMapNode node, ColorScheme cs) {
    final isSelected = node.id == _selectedNodeId;
    final isEditing = node.id == _editingNodeId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(node.style.backgroundColor),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? cs.primary
              : Color(node.style.borderColor).withAlpha(100),
          width: isSelected ? 3 : node.style.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withAlpha(isSelected ? 60 : 30),
            blurRadius: isSelected ? 12 : 8,
            offset: Offset(0, isSelected ? 4 : 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEditing)
            TextField(
              controller: _textController,
              autofocus: true,
              maxLines: null,
              style: TextStyle(
                color: Color(node.style.textColor),
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                ref
                    .read(
                      mindMapNotifierProvider((
                        workspaceId: widget.workspaceId,
                        mapId: widget.mapId,
                      )).notifier,
                    )
                    .updateNodeText(node.id, value);
                setState(() => _editingNodeId = null);
              },
            )
          else
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _editingNodeId = node.id;
                  _textController.text = node.text;
                });
              },
              child: Text(
                node.text,
                style: TextStyle(
                  color: Color(node.style.textColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (node.childIds.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  node.collapsed ? Icons.expand_more : Icons.expand_less,
                  size: 16,
                  color: Color(node.style.textColor).withAlpha(150),
                ),
                const SizedBox(width: 4),
                Text(
                  '${node.childIds.length}',
                  style: TextStyle(
                    color: Color(node.style.textColor).withAlpha(150),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handleTap(Offset position, MindMapGraph map) {
    // Check if tapped on a node
    for (final node in map.nodes.values) {
      final nodeBounds = Rect.fromCenter(
        center: Offset(node.position.x, node.position.y),
        width: 150,
        height: 80,
      );
      if (nodeBounds.contains(position)) {
        return; // Node tap handled by GestureDetector on node widget
      }
    }
    // Tapped on empty space - deselect
    setState(() => _selectedNodeId = null);
  }

  void _handleLongPress(Offset position, MindMapGraph map) {
    // Check if long-pressed on a node
    for (final node in map.nodes.values) {
      final nodeBounds = Rect.fromCenter(
        center: Offset(node.position.x, node.position.y),
        width: 150,
        height: 80,
      );
      if (nodeBounds.contains(position)) {
        _showNodeContextMenu(node);
        return;
      }
    }
  }

  void _selectNode(String nodeId) {
    setState(() => _selectedNodeId = nodeId);
  }

  void _handleNodeDrag(String nodeId, Offset delta) {
    final mapAsync = ref.read(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )),
    );

    mapAsync.whenData((map) {
      final node = map.nodes[nodeId];
      if (node != null) {
        final matrix = _transformController.value;
        final scale = matrix.getMaxScaleOnAxis();
        final adjustedDelta = delta / scale;

        ref
            .read(
              mindMapNotifierProvider((
                workspaceId: widget.workspaceId,
                mapId: widget.mapId,
              )).notifier,
            )
            .updateNodePosition(
              nodeId,
              Position(
                x: node.position.x + adjustedDelta.dx,
                y: node.position.y + adjustedDelta.dy,
              ),
            );
      }
    });
  }

  void _addChildToSelected() {
    if (_selectedNodeId == null) return;
    _showAddChildDialog(_selectedNodeId!);
  }

  void _showAddNodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Node'),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Node text',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              // Add as root node at center
              ref
                  .read(
                    mindMapNotifierProvider((
                      workspaceId: widget.workspaceId,
                      mapId: widget.mapId,
                    )).notifier,
                  )
                  .addChildNode(
                    widget.mapId,
                    value,
                    position: const Position(x: 0, y: 0),
                  );
              Navigator.pop(context);
              _textController.clear();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                ref
                    .read(
                      mindMapNotifierProvider((
                        workspaceId: widget.workspaceId,
                        mapId: widget.mapId,
                      )).notifier,
                    )
                    .addChildNode(
                      widget.mapId,
                      _textController.text,
                      position: const Position(x: 0, y: 0),
                    );
                Navigator.pop(context);
                _textController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog(String parentId) {
    _textController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Child Node'),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Node text',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                final mapAsync = ref.read(
                  mindMapNotifierProvider((
                    workspaceId: widget.workspaceId,
                    mapId: widget.mapId,
                  )),
                );

                mapAsync.whenData((map) {
                  final parent = map.nodes[parentId];
                  if (parent != null) {
                    // Position child node relative to parent
                    final childPosition = Position(
                      x: parent.position.x + 200,
                      y: parent.position.y + (parent.childIds.length * 100),
                    );

                    ref
                        .read(
                          mindMapNotifierProvider((
                            workspaceId: widget.workspaceId,
                            mapId: widget.mapId,
                          )).notifier,
                        )
                        .addChildNode(
                          parentId,
                          _textController.text,
                          position: childPosition,
                        );
                  }
                });

                Navigator.pop(context);
                _textController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showNodeContextMenu(MindMapNode node) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add, color: cs.primary),
              title: const Text('Add child'),
              onTap: () {
                Navigator.pop(context);
                _showAddChildDialog(node.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: cs.secondary),
              title: const Text('Edit text'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _editingNodeId = node.id;
                  _textController.text = node.text;
                });
              },
            ),
            if (node.childIds.isNotEmpty)
              ListTile(
                leading: Icon(
                  node.collapsed ? Icons.expand_more : Icons.expand_less,
                  color: cs.tertiary,
                ),
                title: Text(node.collapsed ? 'Expand' : 'Collapse'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(
                        mindMapNotifierProvider((
                          workspaceId: widget.workspaceId,
                          mapId: widget.mapId,
                        )).notifier,
                      )
                      .toggleNodeCollapsed(node.id);
                },
              ),
            if (node.parentId != null)
              ListTile(
                leading: Icon(Icons.delete, color: cs.error),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(
                        mindMapNotifierProvider((
                          workspaceId: widget.workspaceId,
                          mapId: widget.mapId,
                        )).notifier,
                      )
                      .deleteNode(node.id);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for drawing connections between nodes
class _MindMapPainter extends CustomPainter {
  _MindMapPainter({
    required this.map,
    required this.selectedNodeId,
    required this.colorScheme,
  });

  final MindMapGraph map;
  final String? selectedNodeId;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline.withAlpha(100)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connections from parent to children
    for (final node in map.nodes.values) {
      if (node.collapsed) continue; // Skip collapsed nodes

      for (final childId in node.childIds) {
        final child = map.nodes[childId];
        if (child == null) continue;

        final start = Offset(node.position.x, node.position.y);
        final end = Offset(child.position.x, child.position.y);

        // Draw curved line
        final path = Path();
        path.moveTo(start.dx, start.dy);

        final controlPoint1 = Offset(
          start.dx + (end.dx - start.dx) * 0.5,
          start.dy,
        );
        final controlPoint2 = Offset(
          start.dx + (end.dx - start.dx) * 0.5,
          end.dy,
        );

        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          end.dx,
          end.dy,
        );

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_MindMapPainter oldDelegate) {
    return oldDelegate.map != map ||
        oldDelegate.selectedNodeId != selectedNodeId;
  }
}
