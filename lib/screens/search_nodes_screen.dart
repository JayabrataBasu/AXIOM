import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart' hide SearchResult;
import '../services/search_service.dart' as search;
import 'node_editor_screen.dart';

/// Screen for searching and navigating to nodes.
class SearchNodesScreen extends ConsumerStatefulWidget {
  const SearchNodesScreen({super.key});

  @override
  ConsumerState<SearchNodesScreen> createState() => _SearchNodesScreenState();
}

class _SearchNodesScreenState extends ConsumerState<SearchNodesScreen> {
  late TextEditingController _searchController;
  List<search.SearchResult> _results = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query, List<IdeaNode> nodes) {
    final results = search.SearchService.search(nodes, query);

    List<search.SearchResult> filtered = results;
    if (_selectedFilter != 'All') {
      filtered = search.SearchService.filterByBlockType(
        results,
        _selectedFilter,
      );
    }

    setState(() => _results = filtered);
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Nodes'), elevation: 0),
      body: nodesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (nodes) {
          return Column(
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _performSearch(value, nodes),
                  decoration: InputDecoration(
                    hintText: 'Search nodes, blocks, content...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _results = []);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              // Filter chips
              if (_searchController.text.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip(
                        'All',
                        _selectedFilter == 'All',
                        () => setState(() {
                          _selectedFilter = 'All';
                          _performSearch(_searchController.text, nodes);
                        }),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Text',
                        _selectedFilter == 'Text',
                        () => setState(() {
                          _selectedFilter = 'Text';
                          _performSearch(_searchController.text, nodes);
                        }),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Code',
                        _selectedFilter == 'Code',
                        () => setState(() {
                          _selectedFilter = 'Code';
                          _performSearch(_searchController.text, nodes);
                        }),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Heading',
                        _selectedFilter == 'Heading',
                        () => setState(() {
                          _selectedFilter = 'Heading';
                          _performSearch(_searchController.text, nodes);
                        }),
                      ),
                    ],
                  ),
                ),
              // Results
              Expanded(
                child: _searchController.text.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start typing to search',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.not_interested_rounded,
                              size: 48,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final result = _results[index];
                          return _buildResultCard(context, result, theme);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    search.SearchResult result,
    ThemeData theme,
  ) {
    final scorePercentage = (result.score * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          _getBlockIcon(result.blockType),
          color: theme.colorScheme.primary,
        ),
        title: Text(
          result.node.name.isEmpty
              ? 'Node ${result.node.id.substring(0, 8)}...'
              : result.node.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result.blockType,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.matchedContent,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: result.score, minHeight: 2),
          ],
        ),
        trailing: Text(
          '$scorePercentage%',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        onTap: () => Navigator.pop(
          context,
          search.SearchNavigation(
            nodeId: result.node.id,
            blockId: result.blockId,
          ),
        ),
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NodeEditorScreen(
                nodeId: result.node.id,
                highlightBlockId: result.blockId,
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getBlockIcon(String blockType) {
    return switch (blockType.toLowerCase()) {
      'text' => Icons.text_fields,
      'heading' => Icons.title,
      'heading h1' || 'heading h2' || 'heading h3' => Icons.title,
      'code' => Icons.code,
      'quote' => Icons.format_quote,
      'math' => Icons.functions,
      'list' => Icons.format_list_bulleted,
      'audio' => Icons.mic,
      'sketch' => Icons.gesture,
      'node name' => Icons.note_outlined,
      _ => Icons.circle,
    };
  }
}
