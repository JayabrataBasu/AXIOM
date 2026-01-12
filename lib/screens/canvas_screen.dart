import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'node_editor_screen.dart';

/// The main canvas screen - the primary thinking surface.
class CanvasScreen extends ConsumerStatefulWidget {
  const CanvasScreen({super.key});

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  final _canvasKey = GlobalKey<InfiniteCanvasState>();
  final _focusNode = FocusNode();
  double _currentZoom = 1.0;
  Offset _originInScene = Offset.zero;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final viewState = ref.watch(canvasViewProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // Canvas
            nodesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(nodesNotifierProvider.notifier).reload();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (nodes) => InfiniteCanvas(
                key: _canvasKey,
                onScaleChanged: (scale) {
                  setState(() => _currentZoom = scale);
                },
                child: CanvasContent(
                  nodes: nodes,
                  selectedNodeId: viewState.selectedNodeId,
                  onNodeTap: _onNodeTap,
                  onNodeDoubleTap: _onNodeDoubleTap,
                  onNodeDragEnd: _onNodeDragEnd,
                  onCanvasTap: _onCanvasTap,
                  onCanvasDoubleTap: _onCanvasDoubleTap,
                  onCanvasInfoChanged: (origin) {
                    _originInScene = origin;
                  },
                ),
              ),
            ),
            // Top toolbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildToolbar(context, theme),
            ),
            // Zoom indicator
            Positioned(
              bottom: 16,
              right: 16,
              child: _buildZoomIndicator(theme),
            ),
            // Help hint
            Positioned(
              bottom: 16,
              left: 16,
              child: _buildHelpHint(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo/Title
            Text(
              'Axiom',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Center on origin
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              tooltip: 'Center on origin',
              onPressed: () {
                _canvasKey.currentState?.centerOn(_originInScene);
              },
            ),
            // Zoom controls
            IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Zoom out',
              onPressed: () {
                final newZoom = (_currentZoom * 0.8).clamp(0.1, 4.0);
                _canvasKey.currentState?.setZoom(newZoom);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Zoom in',
              onPressed: () {
                final newZoom = (_currentZoom * 1.25).clamp(0.1, 4.0);
                _canvasKey.currentState?.setZoom(newZoom);
              },
            ),
            const SizedBox(width: 8),
            // Debug menu (temporary)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More options',
              onSelected: (value) {
                if (value == 'debug') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const _DebugScreenWrapper(),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'debug',
                  child: Row(
                    children: [
                      Icon(Icons.bug_report),
                      SizedBox(width: 8),
                      Text('Debug View'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        '${(_currentZoom * 100).round()}%',
        style: theme.textTheme.labelMedium,
      ),
    );
  }

  Widget _buildHelpHint(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        'Right-click to create • Drag to move • Double-click node to edit',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Escape to deselect
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(canvasViewProvider.notifier).clearSelection();
      }
      // Delete selected node
      if (event.logicalKey == LogicalKeyboardKey.delete ||
          event.logicalKey == LogicalKeyboardKey.backspace) {
        final selectedId = ref.read(canvasViewProvider).selectedNodeId;
        if (selectedId != null) {
          _confirmDeleteNode(selectedId);
        }
      }
    }
  }

  void _onNodeTap(String nodeId) {
    ref.read(canvasViewProvider.notifier).selectNode(nodeId);
  }

  void _onNodeDoubleTap(String nodeId) {
    _openNodeEditor(nodeId);
  }

  void _onNodeDragEnd(String nodeId, Offset delta) async {
    final nodes = ref.read(nodesNotifierProvider).valueOrNull ?? [];
    final node = nodes.firstWhere((n) => n.id == nodeId);
    final newPosition = Position(
      x: node.position.x + delta.dx,
      y: node.position.y + delta.dy,
    );
    await ref.read(nodesNotifierProvider.notifier).updateNodePosition(
          nodeId,
          newPosition,
        );
  }

  void _onCanvasTap() {
    ref.read(canvasViewProvider.notifier).clearSelection();
  }

  void _onCanvasDoubleTap(Offset canvasPosition) async {
    // Create new node at the tapped position
    final position = Position(x: canvasPosition.dx, y: canvasPosition.dy);
    final node = await ref.read(nodesNotifierProvider.notifier).createNode(
          position: position,
        );
    // Select the new node
    ref.read(canvasViewProvider.notifier).selectNode(node.id);
  }

  void _openNodeEditor(String nodeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NodeEditorScreen(nodeId: nodeId),
      ),
    );
  }

  Future<void> _confirmDeleteNode(String nodeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Node?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(canvasViewProvider.notifier).clearSelection();
      await ref.read(nodesNotifierProvider.notifier).deleteNode(nodeId);
    }
  }
}

/// Wrapper for the debug screen to maintain navigation.
class _DebugScreenWrapper extends StatelessWidget {
  const _DebugScreenWrapper();

  @override
  Widget build(BuildContext context) {
    // Import dynamically to avoid circular dependency
    return const _DebugScreenPlaceholder();
  }
}

class _DebugScreenPlaceholder extends ConsumerWidget {
  const _DebugScreenPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-use the debug screen from screens
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug View'),
      ),
      body: const Center(
        child: Text('Debug view - use back button to return to canvas'),
      ),
    );
  }
}
