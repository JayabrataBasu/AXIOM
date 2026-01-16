import '../models/models.dart';

/// Navigation payload from search result to canvas and editor.
class SearchNavigation {
  const SearchNavigation({required this.nodeId, required this.blockId});

  final String nodeId;
  final String blockId; // Empty string if no specific block
}

/// Search result containing a matching node and preview of matching content.
class SearchResult {
  SearchResult({
    required this.node,
    required this.matchedContent,
    required this.blockId,
    required this.blockType,
    required this.score,
  });

  final IdeaNode node;
  final String matchedContent;
  final String blockId;
  final String blockType;
  final double score; // Relevance score 0.0-1.0
}

/// Service for searching across nodes and their blocks.
class SearchService {
  /// Search for nodes matching a query string.
  ///
  /// Returns a list of [SearchResult] sorted by relevance score (highest first).
  static List<SearchResult> search(List<IdeaNode> nodes, String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];

    for (final node in nodes) {
      // Search node name
      double nameScore = _calculateScore(node.name, lowerQuery);
      if (nameScore > 0) {
        results.add(
          SearchResult(
            node: node,
            matchedContent: node.name,
            blockId: '',
            blockType: 'Node Name',
            score: nameScore * 1.5, // Boost node name matches
          ),
        );
      }

      // Search blocks
      for (final block in node.blocks) {
        final blockMatch = _searchBlock(block, lowerQuery);
        if (blockMatch != null) {
          results.add(
            SearchResult(
              node: node,
              matchedContent: blockMatch['content'] as String,
              blockId: block.id,
              blockType: blockMatch['type'] as String,
              score: blockMatch['score'] as double,
            ),
          );
        }
      }
    }

    // Sort by relevance score (highest first)
    results.sort((a, b) => b.score.compareTo(a.score));

    // Group results by node to avoid duplicates
    return _deduplicateResults(results);
  }

  /// Filter results by block type.
  static List<SearchResult> filterByBlockType(
    List<SearchResult> results,
    String blockType,
  ) {
    return results
        .where((r) => r.blockType.toLowerCase() == blockType.toLowerCase())
        .toList();
  }

  /// Search a single block and return match info.
  static Map<String, dynamic>? _searchBlock(ContentBlock block, String query) {
    String? content;
    String blockType = 'Unknown';

    switch (block) {
      case TextBlock():
        content = block.content;
        blockType = 'Text';
        break;
      case HeadingBlock():
        content = block.content;
        blockType = 'Heading H${block.level}';
        break;
      case BulletListBlock():
        content = block.items.join(' ');
        blockType = 'List';
        break;
      case CodeBlock():
        content = block.content;
        blockType =
            'Code (${block.language.isEmpty ? 'Plain' : block.language})';
        break;
      case QuoteBlock():
        content = '${block.content} ${block.attribution}';
        blockType = 'Quote';
        break;
      case MathBlock():
        content = block.latex;
        blockType = 'Math';
        break;
      case SketchBlock():
        // Sketches don't have searchable text
        return null;
      case AudioBlock():
        // Audio blocks don't have searchable text (could add metadata later)
        return null;
      case WorkspaceRefBlock():
        content = block.label;
        blockType = 'Workspace Reference';
        break;
      case ToolBlock():
        return null;
    }

    if (content.isEmpty) return null;

    final score = _calculateScore(content, query);
    if (score <= 0) return null;

    return {
      'content': _extractPreview(content, query),
      'type': blockType,
      'score': score,
    };
  }

  /// Calculate relevance score (0.0-1.0) for a text matching a query.
  static double _calculateScore(String text, String query) {
    final lowerText = text.toLowerCase();

    if (lowerText == query) return 1.0; // Exact match
    if (lowerText.startsWith(query)) return 0.9; // Starts with match
    if (lowerText.contains(query)) return 0.7; // Contains match

    // Fuzzy matching - check for all characters in order
    int queryIndex = 0;
    int textIndex = 0;
    int matchCount = 0;

    while (textIndex < lowerText.length && queryIndex < query.length) {
      if (lowerText[textIndex] == query[queryIndex]) {
        matchCount++;
        queryIndex++;
      }
      textIndex++;
    }

    if (queryIndex == query.length) {
      // All query characters found in order
      final coverage = matchCount / query.length;
      return coverage * 0.5; // Fuzzy matches score lower
    }

    return 0.0; // No match
  }

  /// Extract a preview snippet around the matching text.
  static String _extractPreview(String text, String query) {
    final lowerText = text.toLowerCase();
    final index = lowerText.indexOf(query);

    if (index < 0) return text.length > 100 ? text.substring(0, 100) : text;

    const contextLength = 40;
    final start = (index - contextLength).clamp(0, text.length);
    final end = (index + query.length + contextLength).clamp(0, text.length);

    String preview = text.substring(start, end);
    if (start > 0) preview = '...$preview';
    if (end < text.length) preview = '$preview...';

    return preview;
  }

  /// Remove duplicate results pointing to the same node.
  static List<SearchResult> _deduplicateResults(List<SearchResult> results) {
    final seen = <String, SearchResult>{};

    for (final result in results) {
      final key = result.node.id;
      if (!seen.containsKey(key) || result.score > seen[key]!.score) {
        seen[key] = result;
      }
    }

    return seen.values.toList();
  }
}
