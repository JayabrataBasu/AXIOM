import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/node_providers.dart';

/// State for the canvas view, including selection.
class CanvasViewState {
  const CanvasViewState({
    this.selectedNodeId,
    this.isLoading = false,
  });

  final String? selectedNodeId;
  final bool isLoading;

  CanvasViewState copyWith({
    String? selectedNodeId,
    bool? isLoading,
    bool clearSelection = false,
  }) {
    return CanvasViewState(
      selectedNodeId: clearSelection ? null : (selectedNodeId ?? this.selectedNodeId),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for canvas view state.
class CanvasViewNotifier extends Notifier<CanvasViewState> {
  @override
  CanvasViewState build() {
    return const CanvasViewState();
  }

  /// Select a node by ID.
  void selectNode(String nodeId) {
    state = state.copyWith(selectedNodeId: nodeId);
  }

  /// Clear selection.
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// Toggle selection for a node.
  void toggleSelection(String nodeId) {
    if (state.selectedNodeId == nodeId) {
      clearSelection();
    } else {
      selectNode(nodeId);
    }
  }

  /// Set loading state.
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

/// Provider for canvas view state.
final canvasViewProvider =
    NotifierProvider<CanvasViewNotifier, CanvasViewState>(() {
  return CanvasViewNotifier();
});

/// Provider for the currently selected node.
final selectedNodeProvider = Provider<IdeaNode?>((ref) {
  final viewState = ref.watch(canvasViewProvider);
  final nodesAsync = ref.watch(nodesNotifierProvider);

  if (viewState.selectedNodeId == null) return null;

  return nodesAsync.whenOrNull(
    data: (nodes) => nodes
        .where((n) => n.id == viewState.selectedNodeId)
        .firstOrNull,
  );
});
