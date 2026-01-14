import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'node_providers.dart';

/// Search result for a node
class SearchResult {
  final IdeaNode node;
  final List<SearchMatch> matches;
  final double relevance;

  SearchResult({
    required this.node,
    required this.matches,
    required this.relevance,
  });
}

/// A single search match in a node
class SearchMatch {
  final String blockId;
  final String blockType;
  final String content;
  final int startIndex;
  final int endIndex;

  SearchMatch({
    required this.blockId,
    required this.blockType,
    required this.content,
    required this.startIndex,
    required this.endIndex,
  });
}

/// Search provider for finding nodes by text content
final searchProvider =
    StateNotifierProvider<SearchNotifier, List<SearchResult>>(
      (ref) => SearchNotifier(ref),
    );

/// Notifier for managing search state
class SearchNotifier extends StateNotifier<List<SearchResult>> {
  final Ref ref;

  SearchNotifier(this.ref) : super([]);

  /// Search for nodes matching the query
  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = [];
      return;
    }

    final nodes = await ref.read(nodesNotifierProvider.future);
    final queryLower = query.toLowerCase();
    final results = <SearchResult>[];

    for (final node in nodes) {
      final matches = <SearchMatch>[];
      var totalMatches = 0;

      // Search in node name
      if (node.name.isNotEmpty) {
        final nameLower = node.name.toLowerCase();
        var index = 0;
        while (true) {
          index = nameLower.indexOf(queryLower, index);
          if (index == -1) break;
          matches.add(
            SearchMatch(
              blockId: 'name',
              blockType: 'name',
              content: node.name,
              startIndex: index,
              endIndex: index + query.length,
            ),
          );
          totalMatches++;
          index += query.length;
        }
      }

      // Search in blocks
      for (final block in node.blocks) {
        String content = '';
        String blockType = 'unknown';

        if (block is TextBlock) {
          content = block.content;
          blockType = 'text';
        } else if (block is HeadingBlock) {
          content = block.content;
          blockType = 'heading';
        } else if (block is BulletListBlock) {
          content = block.items.join('\n');
          blockType = 'bulletList';
        } else if (block is CodeBlock) {
          content = block.content;
          blockType = 'code';
        } else if (block is QuoteBlock) {
          content = block.content;
          blockType = 'quote';
        }

        if (content.isEmpty) continue;

        final contentLower = content.toLowerCase();
        var index = 0;
        while (true) {
          index = contentLower.indexOf(queryLower, index);
          if (index == -1) break;
          matches.add(
            SearchMatch(
              blockId: block.id,
              blockType: blockType,
              content: content,
              startIndex: index,
              endIndex: index + query.length,
            ),
          );
          totalMatches++;
          index += query.length;
        }
      }

      if (matches.isNotEmpty) {
        // Calculate relevance (more recent and more matches = higher relevance)
        final ageInDays = DateTime.now()
            .difference(node.updatedAt)
            .inDays
            .toDouble();
        final recencyScore =
            1.0 / (1.0 + (ageInDays / 30)); // Decay over 30 days
        final matchScore = (totalMatches * 10).toDouble();
        final relevance = (matchScore * recencyScore).clamp(0.0, 100.0);

        results.add(
          SearchResult(node: node, matches: matches, relevance: relevance),
        );
      }
    }

    // Sort by relevance
    results.sort((a, b) => b.relevance.compareTo(a.relevance));
    state = results;
  }

  /// Clear search results
  void clear() {
    state = [];
  }
}

/// Get the current search results
final searchResultsProvider = Provider<List<SearchResult>>((ref) {
  return ref.watch(searchProvider);
});
