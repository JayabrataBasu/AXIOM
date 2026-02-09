import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
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
  bool _hasInitialCentered = false;

  @override
  void dispose() {
    _transformController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Center the viewport on the root node so it's always visible
  void _centerOnRootNode(MindMapGraph map) {
    final rootNode = map.nodes[map.rootNodeId];
    if (rootNode == null) return;

    final size = MediaQuery.of(context).size;
    final appBarH = kToolbarHeight + MediaQuery.of(context).padding.top;
    final viewW = size.width;
    final viewH = size.height - appBarH;

    // The node is rendered at Positioned(left: x-75, top: y-40), size ~150x80
    // We want the node center (x, y) to appear at viewport center
    final nodeScreenX = rootNode.position.x; // center of node in canvas coords
    final nodeScreenY = rootNode.position.y;

    final dx = -nodeScreenX + (viewW / 2);
    final dy = -nodeScreenY + (viewH / 2);

    _transformController.value = Matrix4.translationValues(dx, dy, 0);
  }

  void _centerOnNode(MindMapNode node) {
    final size = MediaQuery.of(context).size;
    final appBarH = kToolbarHeight + MediaQuery.of(context).padding.top;
    final viewW = size.width;
    final viewH = size.height - appBarH;

    final nodeScreenX = node.position.x;
    final nodeScreenY = node.position.y;

    final dx = -nodeScreenX + (viewW / 2);
    final dy = -nodeScreenY + (viewH / 2);

    _transformController.value = Matrix4.translationValues(dx, dy, 0);
  }

  Rect _visibleCanvasRect(Size viewportSize) {
    final inverse = Matrix4.inverted(_transformController.value);
    final topLeft = MatrixUtils.transformPoint(inverse, Offset.zero);
    final topRight = MatrixUtils.transformPoint(
      inverse,
      Offset(viewportSize.width, 0),
    );
    final bottomLeft = MatrixUtils.transformPoint(
      inverse,
      Offset(0, viewportSize.height),
    );
    final bottomRight = MatrixUtils.transformPoint(
      inverse,
      Offset(viewportSize.width, viewportSize.height),
    );

    final minX = [
      topLeft.dx,
      topRight.dx,
      bottomLeft.dx,
      bottomRight.dx,
    ].reduce((a, b) => a < b ? a : b);
    final maxX = [
      topLeft.dx,
      topRight.dx,
      bottomLeft.dx,
      bottomRight.dx,
    ].reduce((a, b) => a > b ? a : b);
    final minY = [
      topLeft.dy,
      topRight.dy,
      bottomLeft.dy,
      bottomRight.dy,
    ].reduce((a, b) => a < b ? a : b);
    final maxY = [
      topLeft.dy,
      topRight.dy,
      bottomLeft.dy,
      bottomRight.dy,
    ].reduce((a, b) => a > b ? a : b);

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  bool _isNodeVisible(MindMapNode node, Rect visibleRect) {
    const nodeHalfWidth = 75.0;
    const nodeHalfHeight = 40.0;
    const visibilityPadding = 200.0;

    final nodeRect = Rect.fromLTRB(
      node.position.x - nodeHalfWidth,
      node.position.y - nodeHalfHeight,
      node.position.x + nodeHalfWidth,
      node.position.y + nodeHalfHeight,
    );

    return visibleRect.inflate(visibilityPadding).overlaps(nodeRect);
  }

  Future<void> _showSearchDialog(MindMapGraph map) async {
    final queryController = TextEditingController();

    final selectedNodeId = await showDialog<String?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final query = queryController.text.trim().toLowerCase();
            final nodes = map.nodes.values.toList()
              ..sort((a, b) => a.text.compareTo(b.text));
            final filtered = query.isEmpty
                ? nodes
                : nodes
                      .where((n) => n.text.toLowerCase().contains(query))
                      .toList();

            return AlertDialog(
              title: const Text('Find Node'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: queryController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Search nodes',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: filtered.isEmpty
                          ? const Center(child: Text('No matches'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final node = filtered[index];
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.account_tree),
                                  title: Text(
                                    node.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => Navigator.pop(context, node.id),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedNodeId == null) return;
    final node = map.nodes[selectedNodeId];
    if (node == null) return;

    setState(() => _selectedNodeId = node.id);
    _centerOnNode(node);
  }

  Future<void> _showExportDialog(MindMapGraph map) async {
    final cs = Theme.of(context).colorScheme;

    final format = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Mind Map'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'png'),
            child: const Text('PNG'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'jpg'),
            child: const Text('JPG'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (format == null) return;

    // Calculate canvas bounds
    if (map.nodes.isEmpty) {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No nodes to export')));
      return;
    }

    // Show loading dialog
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Exporting mind map...'),
            ],
          ),
        ),
      ),
    );

    try {
      await _exportMindMapAsImage(map, format);
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Close loading dialog

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mind map exported as $format'),
          backgroundColor: cs.primaryContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Close loading dialog
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: cs.error),
      );
    }
  }

  Future<void> _exportMindMapAsImage(MindMapGraph map, String format) async {
    final nodes = map.nodes.values.toList();
    if (nodes.isEmpty) throw Exception('No nodes to export');

    // Calculate canvas bounds with padding
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    const nodePadding = 100.0;
    for (final node in nodes) {
      minX = minX > node.position.x - 75 - nodePadding
          ? node.position.x - 75 - nodePadding
          : minX;
      maxX = maxX < node.position.x + 75 + nodePadding
          ? node.position.x + 75 + nodePadding
          : maxX;
      minY = minY > node.position.y - 40 - nodePadding
          ? node.position.y - 40 - nodePadding
          : minY;
      maxY = maxY < node.position.y + 40 + nodePadding
          ? node.position.y + 40 + nodePadding
          : maxY;
    }

    final canvasWidth = (maxX - minX).toInt();
    final canvasHeight = (maxY - minY).toInt();

    // Create image
    final image = img.Image(
      width: canvasWidth.clamp(100, 4000),
      height: canvasHeight.clamp(100, 4000),
    );

    // Fill background (Everforest background light)
    final bgColor = img.ColorRgba8(248, 248, 246, 255);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        image.setPixelRgba(x, y, bgColor.r, bgColor.g, bgColor.b, bgColor.a);
      }
    }

    // Draw connections (lines between parent-child nodes)
    final lineColor = img.ColorRgba8(
      150,
      150,
      150,
      180,
    ); // Gray line for connections

    for (final node in nodes) {
      for (final childId in node.childIds) {
        final child = map.nodes[childId];
        if (child == null) continue;

        final startX = ((node.position.x - minX).toInt()).clamp(
          0,
          image.width - 1,
        );
        final startY = ((node.position.y - minY).toInt()).clamp(
          0,
          image.height - 1,
        );
        final endX = ((child.position.x - minX).toInt()).clamp(
          0,
          image.width - 1,
        );
        final endY = ((child.position.y - minY).toInt()).clamp(
          0,
          image.height - 1,
        );

        // Draw line
        img.drawLine(
          image,
          x1: startX,
          y1: startY,
          x2: endX,
          y2: endY,
          color: lineColor,
        );
      }
    }

    // Draw nodes as circles with text
    for (final node in nodes) {
      final x = ((node.position.x - minX).toInt()).clamp(0, image.width - 1);
      final y = ((node.position.y - minY).toInt()).clamp(0, image.height - 1);

      // Parse node background color (stored as int)
      final bgColorInt = node.style.backgroundColor;
      final r = (bgColorInt >> 16) & 0xFF;
      final g = (bgColorInt >> 8) & 0xFF;
      final b = bgColorInt & 0xFF;
      final nodeColor = img.ColorRgba8(r, g, b, 255);

      // Draw node circle
      img.drawCircle(image, x: x, y: y, radius: 20, color: nodeColor);

      // Border
      img.drawCircle(image, x: x, y: y, radius: 20, color: lineColor);
    }

    // Encode and save
    List<int> encoded;
    if (format == 'png') {
      encoded = img.encodePng(image);
    } else {
      encoded = img.encodeJpg(image, quality: 95);
    }

    // Save to Documents directory (persistent storage)
    Directory directory;
    try {
      directory = await getApplicationDocumentsDirectory();
      // Create AXIOM/Exports subdirectory
      final exportsDir = Directory('${directory.path}/AXIOM/MindMapExports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }
      directory = exportsDir;
    } catch (e) {
      // Fallback to temp directory if Documents not available
      directory = await getTemporaryDirectory();
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = format == 'png' ? 'png' : 'jpg';
    final filepath =
        '${directory.path}/mindmap_${map.name.replaceAll(' ', '_')}_$timestamp.$extension';

    final file = File(filepath);
    await file.writeAsBytes(encoded);
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
            icon: Icon(Icons.search, color: cs.onSurfaceVariant),
            onPressed: () {
              final map = mapAsync.valueOrNull;
              if (map != null) {
                _showSearchDialog(map);
              }
            },
            tooltip: 'Find node',
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: cs.primary),
            onPressed: () => _showAddNodeDialog(context),
            tooltip: 'Add root node',
          ),
          IconButton(
            icon: Icon(Icons.download, color: cs.onSurfaceVariant),
            onPressed: () {
              final map = mapAsync.valueOrNull;
              if (map != null) {
                _showExportDialog(map);
              }
            },
            tooltip: 'Export',
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
              const SizedBox(height: 8),
              Text(
                'Map ID: ${widget.mapId}',
                style: TextStyle(color: cs.onSurface, fontSize: 12),
              ),
            ],
          ),
        ),
        data: (map) {
          // Auto-center viewport on root node on first load
          if (!_hasInitialCentered) {
            _hasInitialCentered = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _centerOnRootNode(map);
            });
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: _transformController,
                builder: (context, _) {
                  final visibleRect = _visibleCanvasRect(constraints.biggest);
                  final visibleNodes = map.nodes.values
                      .where((node) => _isNodeVisible(node, visibleRect))
                      .toList();

                  return InteractiveViewer(
                    transformationController: _transformController,
                    constrained: false,
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
                        onTapDown: (details) =>
                            _handleTap(details.localPosition, map),
                        onLongPressStart: (details) =>
                            _handleLongPress(details.localPosition, map),
                        child: SizedBox(
                          width: 4000,
                          height: 4000,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: visibleNodes.map((node) {
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
                  );
                },
              );
            },
          );
        },
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

    // Priority color (left border accent)
    final priorityColor = _getPriorityColor(node.priority, cs);

    // Use custom painter for different shapes, or standard container for rounded
    if (node.style.shape == 'circle' ||
        node.style.shape == 'diamond' ||
        node.style.shape == 'rectangle') {
      return _buildCustomShapeNode(node, cs, isSelected, isEditing);
    }

    // Default rounded rectangle
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 150,
          padding: EdgeInsets.only(
            left: node.priority != 'none' ? 16 : 12,
            right: 12,
            top: 12,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Color(node.style.backgroundColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? cs.primary : Color(node.style.borderColor),
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
          child: _buildNodeContent(node, cs, isEditing),
        ),
        // Priority indicator overlay
        if (node.priority != 'none')
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build node content (text + emoji + children count)
  Widget _buildNodeContent(MindMapNode node, ColorScheme cs, bool isEditing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji and text row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (node.style.emoji.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  node.style.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            Expanded(
              child: isEditing
                  ? TextField(
                      controller: _textController,
                      autofocus: true,
                      maxLines: null,
                      style: TextStyle(
                        color: Color(node.style.textColor),
                        fontSize: 13,
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
                  : GestureDetector(
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
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),
          ],
        ),
        if (node.childIds.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                node.collapsed ? Icons.expand_more : Icons.expand_less,
                size: 14,
                color: Color(node.style.textColor).withAlpha(150),
              ),
              const SizedBox(width: 2),
              Text(
                '${node.childIds.length}',
                style: TextStyle(
                  color: Color(node.style.textColor).withAlpha(150),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Build node with custom shapes (circle, diamond, rectangle)
  Widget _buildCustomShapeNode(
    MindMapNode node,
    ColorScheme cs,
    bool isSelected,
    bool isEditing,
  ) {
    final priorityColor = _getPriorityColor(node.priority, cs);

    return SizedBox(
      width: 150,
      height: 80,
      child: CustomPaint(
        painter: _NodeShapePainter(
          shape: node.style.shape,
          backgroundColor: Color(node.style.backgroundColor),
          borderColor: isSelected ? cs.primary : Color(node.style.borderColor),
          borderWidth: isSelected ? 3.0 : node.style.borderWidth,
          priorityColor: priorityColor,
          showPriority: node.priority != 'none',
          colorScheme: cs,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _buildNodeContent(node, cs, isEditing),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority, ColorScheme cs) {
    return switch (priority) {
      'low' => const Color(0xFFB4D273), // Everforest light green
      'high' => const Color(0xFFE67E22), // Orange
      'urgent' => const Color(0xFFE66868), // Red
      _ => Colors.transparent,
    };
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
        title: const Text('Add Root Node'),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Node text',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              final mapAsync = ref.watch(
                mindMapNotifierProvider((
                  workspaceId: widget.workspaceId,
                  mapId: widget.mapId,
                )),
              );
              mapAsync.whenOrNull(
                data: (map) {
                  final rootNodeId = map.rootNodeId;
                  if (rootNodeId != null) {
                    final rootNode = map.nodes[rootNodeId];
                    // Position child spread horizontally around root
                    final childCount = rootNode?.childIds.length ?? 0;
                    final spacing = 200.0;
                    final rootX = rootNode?.position.x ?? 2000;
                    final rootY = rootNode?.position.y ?? 2000;
                    final offset =
                        childCount * spacing - (childCount * spacing / 2);
                    final newPos = Position(x: rootX + offset, y: rootY + 180);
                    ref
                        .read(
                          mindMapNotifierProvider((
                            workspaceId: widget.workspaceId,
                            mapId: widget.mapId,
                          )).notifier,
                        )
                        .addChildNode(rootNodeId, value, position: newPos);
                    Navigator.pop(context);
                    _textController.clear();
                  }
                },
              );
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
                final mapAsync = ref.watch(
                  mindMapNotifierProvider((
                    workspaceId: widget.workspaceId,
                    mapId: widget.mapId,
                  )),
                );
                mapAsync.whenOrNull(
                  data: (map) {
                    final rootNodeId = map.rootNodeId;
                    if (rootNodeId != null) {
                      final rootNode = map.nodes[rootNodeId];
                      // Position child spread horizontally around root
                      final childCount = rootNode?.childIds.length ?? 0;
                      final spacing = 200.0;
                      final rootX = rootNode?.position.x ?? 2000;
                      final rootY = rootNode?.position.y ?? 2000;
                      final offset =
                          childCount * spacing - (childCount * spacing / 2);
                      final newPos = Position(
                        x: rootX + offset,
                        y: rootY + 180,
                      );
                      ref
                          .read(
                            mindMapNotifierProvider((
                              workspaceId: widget.workspaceId,
                              mapId: widget.mapId,
                            )).notifier,
                          )
                          .addChildNode(
                            rootNodeId,
                            _textController.text,
                            position: newPos,
                          );
                      Navigator.pop(context);
                      _textController.clear();
                    }
                  },
                );
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
                    // Position child spread horizontally below parent
                    final childCount = parent.childIds.length;
                    final spacing = 200.0;
                    final offset =
                        childCount * spacing - (childCount * spacing / 2);
                    final childPosition = Position(
                      x: parent.position.x + offset,
                      y: parent.position.y + 180,
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
        child: SingleChildScrollView(
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
              const Divider(height: 8),
              // Styling options
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Background color'),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPicker(
                    node.id,
                    'background',
                    Color(node.style.backgroundColor),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text('Border color'),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPicker(
                    node.id,
                    'border',
                    Color(node.style.borderColor),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Text color'),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPicker(
                    node.id,
                    'text',
                    Color(node.style.textColor),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Shape'),
                onTap: () {
                  Navigator.pop(context);
                  _showShapePicker(node.id, node.style.shape);
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('Add emoji'),
                onTap: () {
                  Navigator.pop(context);
                  _showEmojiPicker(node.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Priority'),
                onTap: () {
                  Navigator.pop(context);
                  _showPriorityPicker(node.id, node.priority);
                },
              ),
              const Divider(height: 8),
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
      ),
    );
  }

  // Color picker for node styling
  void _showColorPicker(String nodeId, String type, Color currentColor) {
    final notifier = ref.read(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )).notifier,
    );

    final colors = [
      0xFFFDF6E3, // Everforest light bg
      0xFFFFFFFF, // White
      0xFFFFE8D6, // Peach
      0xFFE67E22, // Orange
      0xFFD4A574, // Brown
      0xFFB4D273, // Light green
      0xFF708238, // Dark green
      0xFF2D5016, // Forest green
      0xFF35A77C, // Teal
      0xFF3A94C5, // Blue
      0xFF7A9FBA, // Slate
      0xFF5D4E60, // Purple
      0xFFD399B3, // Pink
      0xFFE66868, // Red
      0xFF000000, // Black
      0xFF404040, // Dark gray
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose ${type == 'text' ? 'text' : type} color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            final isSelected = color == currentColor.toARGB32();
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                notifier.updateNodeStyle(nodeId, type, color);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(color),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey,
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Shape picker for node styling
  void _showShapePicker(String nodeId, String currentShape) {
    final notifier = ref.read(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )).notifier,
    );

    final shapes = ['rounded', 'rectangle', 'circle', 'diamond'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose node shape'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: shapes.map((shape) {
            final isSelected = shape == currentShape;
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                notifier.updateNodeShape(nodeId, shape);
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: _getShapeDecoration(shape),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  BoxDecoration _getShapeDecoration(String shape) {
    switch (shape) {
      case 'circle':
        return BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
      case 'rectangle':
        return BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.zero,
        );
      case 'diamond':
        return BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(0),
        );
      default:
        return BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }

  // Emoji picker for nodes
  void _showEmojiPicker(String nodeId) {
    final notifier = ref.read(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )).notifier,
    );

    final emojis = [
      '💡',
      '💭',
      '✓',
      '✗',
      '★',
      '⚡',
      '🎯',
      '🔥',
      '📌',
      '🎨',
      '🔧',
      '📊',
      '📝',
      '💡',
      '🚀',
      '⏰',
      '📅',
      '🎓',
      '💼',
      '👥',
      '🌟',
      '❤️',
      '🎉',
      '🔔',
      '📱',
      '💻',
      '🖥️',
      '⚙️',
      '🔐',
      '🌍',
      '📈',
      '📉',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose emoji'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emojis.map((emoji) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                notifier.updateNodeEmoji(nodeId, emoji);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.updateNodeEmoji(nodeId, '');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // Priority picker for nodes
  void _showPriorityPicker(String nodeId, String currentPriority) {
    final notifier = ref.read(
      mindMapNotifierProvider((
        workspaceId: widget.workspaceId,
        mapId: widget.mapId,
      )).notifier,
    );

    final priorities = [
      ('none', 'None', Colors.transparent),
      ('low', 'Low', const Color(0xFFB4D273)),
      ('high', 'High', const Color(0xFFE67E22)),
      ('urgent', 'Urgent', const Color(0xFFE66868)),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: priorities.map((p) {
            final (value, label, color) = p;
            final isSelected = value == currentPriority;
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                notifier.updateNodePriority(nodeId, value);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(label),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Custom painter for rendering different node shapes
class _NodeShapePainter extends CustomPainter {
  _NodeShapePainter({
    required this.shape,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.priorityColor,
    required this.showPriority,
    required this.colorScheme,
  });

  final String shape;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color priorityColor;
  final bool showPriority;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final priorityPaint = Paint()
      ..color = priorityColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - borderWidth;

    switch (shape) {
      case 'circle':
        canvas.drawCircle(center, radius, paint);
        canvas.drawCircle(center, radius, strokePaint);
        if (showPriority) {
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            -90 * (3.14159 / 180),
            30 * (3.14159 / 180),
            true,
            priorityPaint,
          );
        }
      case 'diamond':
        final path = Path();
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy);
        path.close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
      case 'rectangle':
        final rect = Rect.fromCenter(
          center: center,
          width: size.width - borderWidth,
          height: size.height - borderWidth,
        );
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, strokePaint);
        if (showPriority) {
          canvas.drawRect(
            Rect.fromLTWH(rect.left, rect.top, 4, rect.height),
            priorityPaint,
          );
        }
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(_NodeShapePainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor;
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
