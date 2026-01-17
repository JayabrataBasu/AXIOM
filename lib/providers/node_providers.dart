import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../models/node_template.dart';
import '../providers/workspace_state_provider.dart';
import '../repositories/repositories.dart';
import '../services/audio_service.dart';
import '../services/sketch_service.dart';

/// Provider for the NodeRepository singleton.
final nodeRepositoryProvider = Provider<NodeRepository>((ref) {
  return NodeRepository();
});

/// Provider for loading all nodes in the active workspace.
final nodesProvider = FutureProvider<List<IdeaNode>>((ref) async {
  final activeWorkspaceId = ref.watch(activeWorkspaceIdProvider);

  // If no active workspace, return empty list
  if (activeWorkspaceId == null) {
    return [];
  }

  final repository = ref.watch(nodeRepositoryProvider);
  final allNodes = await repository.getAll();
  // Filter nodes by workspace ID
  return allNodes.where((n) => n.workspaceId == activeWorkspaceId).toList();
});

/// Notifier for managing nodes with CRUD operations.
class NodesNotifier extends AsyncNotifier<List<IdeaNode>> {
  late NodeRepository _repository;
  final _uuid = const Uuid();
  final AudioService _audioService = AudioService.instance;
  final SketchService _sketchService = SketchService.instance;

  @override
  Future<List<IdeaNode>> build() async {
    _repository = ref.watch(nodeRepositoryProvider);
    return _repository.getAll();
  }

  /// Create a new node at the specified position.
  Future<IdeaNode> createNode({
    Position position = const Position(),
    String? name,
    NodeTemplate? template,
  }) async {
    final now = DateTime.now();
    final activeWorkspaceId = ref.read(activeWorkspaceIdProvider);

    // Generate blocks from template or create default text block
    final blocks = template != null
        ? template.createBlocks(_uuid, now)
        : [ContentBlock.text(id: _uuid.v4(), content: '', createdAt: now)];

    final node = IdeaNode(
      id: _uuid.v4(),
      name: name ?? '',
      workspaceId: activeWorkspaceId ?? '',
      createdAt: now,
      updatedAt: now,
      position: position,
      blocks: blocks,
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

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Add a heading block to a node.
  Future<void> addHeadingBlock(
    String nodeId, {
    int level = 1,
    String content = '',
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.heading(
      id: _uuid.v4(),
      content: content,
      level: level,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Add a bullet list block to a node.
  Future<void> addBulletListBlock(String nodeId, {List<String>? items}) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.bulletList(
      id: _uuid.v4(),
      items: items ?? [''],
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Add a code block to a node.
  Future<void> addCodeBlock(
    String nodeId, {
    String language = '',
    String content = '',
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.code(
      id: _uuid.v4(),
      content: content,
      language: language,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Add a quote block to a node.
  Future<void> addQuoteBlock(
    String nodeId, {
    String content = '',
    String attribution = '',
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.quote(
      id: _uuid.v4(),
      content: content,
      attribution: attribution,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Add a sketch block to a node.
  Future<void> addSketchBlock(String nodeId) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final blockId = _uuid.v4();
    final strokeFile = await _sketchService.ensureStrokeFile(blockId);
    final thumbnailFile = await _sketchService.thumbnailFilePath(blockId);

    final newBlock = ContentBlock.sketch(
      id: blockId,
      strokeFile: strokeFile,
      thumbnailFile: thumbnailFile,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Update a block's content (supports all block types).
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
      if (block.id != blockId) return block;

      return switch (block) {
        TextBlock() => block.copyWith(content: content),
        HeadingBlock() => block.copyWith(content: content),
        CodeBlock() => block.copyWith(content: content),
        QuoteBlock() => block.copyWith(content: content),
        BulletListBlock() => block, // Use updateBulletListItems instead
        SketchBlock() => block, // Use SketchService for strokes
        MathBlock() => block, // Use updateBlockLatex instead
        AudioBlock() => block, // Audio is read-only after creation
        WorkspaceRefBlock() => block, // Read-only workspace references
        ToolBlock() =>
          block, // Tool results are computed, use updateToolBlockOutput
      };
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Update a heading block's level.
  Future<void> updateHeadingLevel(
    String nodeId,
    String blockId,
    int level,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is HeadingBlock) {
        return block.copyWith(level: level.clamp(1, 3));
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Update a bullet list block's items.
  Future<void> updateBulletListItems(
    String nodeId,
    String blockId,
    List<String> items,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is BulletListBlock) {
        return block.copyWith(items: items);
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Add a workspace reference block pointing to a session.
  Future<void> addWorkspaceRefBlock(
    String nodeId, {
    required String sessionId,
    String label = '',
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final now = DateTime.now();
    final newBlock = ContentBlock.workspaceRef(
      id: _uuid.v4(),
      sessionId: sessionId,
      label: label,
      createdAt: now,
    );

    final node = currentNodes[nodeIndex];
    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Update a code block's language.
  Future<void> updateCodeLanguage(
    String nodeId,
    String blockId,
    String language,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is CodeBlock) {
        return block.copyWith(language: language);
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Update a quote block's attribution.
  Future<void> updateQuoteAttribution(
    String nodeId,
    String blockId,
    String attribution,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is QuoteBlock) {
        return block.copyWith(attribution: attribution);
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Add a math block to a node (Stage 4).
  Future<void> addMathBlock(String nodeId, {String latex = ''}) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.math(
      id: _uuid.v4(),
      latex: latex,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Update a math block's LaTeX content.
  Future<void> updateBlockLatex(
    String nodeId,
    String blockId,
    String latex,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedBlocks = node.blocks.map((block) {
      if (block.id == blockId && block is MathBlock) {
        return block.copyWith(latex: latex);
      }
      return block;
    }).toList();

    final updated = node.copyWith(blocks: updatedBlocks);
    await updateNode(updated);
  }

  /// Add an audio block to a node (Stage 6).
  Future<void> addAudioBlock(
    String nodeId, {
    required String audioFile,
    int durationMs = 0,
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newBlock = ContentBlock.audio(
      id: _uuid.v4(),
      audioFile: audioFile,
      durationMs: durationMs,
      createdAt: now,
    );

    final updated = node.copyWith(blocks: [...node.blocks, newBlock]);
    await updateNode(updated);
  }

  /// Delete a block from a node.
  Future<void> deleteBlock(String nodeId, String blockId) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final block = node.blocks.firstWhere((b) => b.id == blockId);

    switch (block) {
      case SketchBlock(:final strokeFile, :final thumbnailFile):
        await _sketchService.deleteSketchAssets(
          blockId: block.id,
          strokeFile: strokeFile,
          thumbnailFile: thumbnailFile.isNotEmpty ? thumbnailFile : null,
        );
      case AudioBlock(:final audioFile):
        if (audioFile.isNotEmpty) {
          await _audioService.deleteRecording(audioFile);
        }
      default:
        break;
    }

    final updated = node.copyWith(
      blocks: node.blocks.where((b) => b.id != blockId).toList(),
    );
    await updateNode(updated);
  }

  /// Add a link to another node.
  Future<void> addLink(
    String nodeId,
    String targetNodeId, {
    String label = '',
  }) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final now = DateTime.now();
    final newLink = NodeLink(
      targetNodeId: targetNodeId,
      label: label,
      createdAt: now,
    );

    final updated = node.copyWith(links: [...node.links, newLink]);
    await updateNode(updated);
  }

  /// Remove a link to another node.
  Future<void> removeLink(String nodeId, String targetNodeId) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updated = node.copyWith(
      links: node.links
          .where((link) => link.targetNodeId != targetNodeId)
          .toList(),
    );
    await updateNode(updated);
  }

  /// Update a link's label.
  Future<void> updateLinkLabel(
    String nodeId,
    String targetNodeId,
    String label,
  ) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    final node = currentNodes[nodeIndex];
    final updatedLinks = node.links.map((link) {
      if (link.targetNodeId == targetNodeId) {
        return link.copyWith(label: label);
      }
      return link;
    }).toList();

    final updated = node.copyWith(links: updatedLinks);
    await updateNode(updated);
  }

  /// Touch a node to bump updatedAt when external assets change.
  Future<void> touchNode(String nodeId) async {
    final currentNodes = state.valueOrNull ?? [];
    final nodeIndex = currentNodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return;

    await updateNode(currentNodes[nodeIndex]);
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
