import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// Provider for the NodeRepository singleton.
final nodeRepositoryProvider = Provider<NodeRepository>((ref) {
  return NodeRepository();
});

/// Provider for loading all nodes.
final nodesProvider = FutureProvider<List<IdeaNode>>((ref) async {
  final repository = ref.watch(nodeRepositoryProvider);
  return repository.getAll();
});

/// Notifier for managing nodes with CRUD operations.
class NodesNotifier extends AsyncNotifier<List<IdeaNode>> {
  late NodeRepository _repository;
  final _uuid = const Uuid();

  @override
  Future<List<IdeaNode>> build() async {
    _repository = ref.watch(nodeRepositoryProvider);
    return _repository.getAll();
  }

  /// Create a new node at the specified position.
  Future<IdeaNode> createNode({Position position = const Position()}) async {
    final now = DateTime.now();
    final node = IdeaNode(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      position: position,
      blocks: [
        ContentBlock.text(
          id: _uuid.v4(),
          content: '',
          createdAt: now,
        ),
      ],
    );

    await _repository.create(node);

    // Update state
    final currentNodes = state.valueOrNull ?? [];
    state = AsyncData([...currentNodes, node]);

    return node;
  }

  /// Update an existing node.
  Future<void> updateNode(IdeaNode node) async {
    await _repository.update(node);

    // Update state
    final currentNodes = state.valueOrNull ?? [];
    state = AsyncData(
      currentNodes.map((n) => n.id == node.id ? node : n).toList(),
    );
  }

  /// Delete a node by ID.
  Future<void> deleteNode(String id) async {
    await _repository.delete(id);

    // Update state
    final currentNodes = state.valueOrNull ?? [];
    state = AsyncData(currentNodes.where((n) => n.id != id).toList());
  }

  /// Update node position.
  Future<void> updateNodePosition(String id, Position position) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == id);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updated = node.copyWith(position: position);
    await updateNode(updated);
  }

  /// Add a text block to a node.
  Future<void> addTextBlock(String nodeId, {String content = ''}) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.text(
      id: _uuid.v4(),
      content: content,
      createdAt: now,
    );

    final updated = node.copyWith(
      blocks: [...node.blocks, newBlock],
    );
    await updateNode(updated);
  }

  /// Update a block's content.
  Future<void> updateBlockContent(
    String nodeId,
    String blockId,
    String content,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is TextBlock) {
        return block.copyWith(content: content);
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Delete a block from a node.
  Future<void> deleteBlock(String nodeId, String blockId) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updated = node.copyWith(
      blocks: node.blocks.where((b) => b.id != blockId).toList(),
    );
    await updateNode(updated);
  }

  /// Reload all nodes from disk.
  Future<void> reload() async {
    state = const AsyncLoading();
    await _repository.reload();
    state = AsyncData(await _repository.getAll());
  }
}

/// Provider for the NodesNotifier.
final nodesNotifierProvider =
    AsyncNotifierProvider<NodesNotifier, List<IdeaNode>>(() {
  return NodesNotifier();
});
