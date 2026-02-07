import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart' hide SearchResult;
import '../services/search_service.dart' as search;
import '../theme/design_tokens.dart';
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: nodesAsync.when(
          loading: () =>
              Center(child: CircularProgressIndicator(color: cs.primary)),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (nodes) {
            return Column(
              children: [
                // Sticky search header
                _buildSearchHeader(context, nodes),
                // Results
                Expanded(
                  child: _searchController.text.isEmpty
                      ? _buildEmptySearchState(cs)
                      : _results.isEmpty
                      ? _buildNoResultsState(cs)
                      : _buildResultsGrid(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, List<IdeaNode> nodes) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AxiomSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(
            color: cs.outlineVariant.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Top row: avatar + settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_rounded,
                  color: cs.onSurfaceVariant.withAlpha(150),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AxiomSpacing.md),

          // Search input (rounded, full-width)
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AxiomRadius.full),
              border: Border.all(
                color: cs.outlineVariant.withAlpha(40),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.search_rounded,
                    color: cs.onSurfaceVariant.withAlpha(120),
                    size: 22,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _performSearch(value, nodes),
                    decoration: InputDecoration(
                      hintText: 'Search your thoughts...',
                      hintStyle: TextStyle(
                        color: cs.onSurfaceVariant.withAlpha(100),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: cs.onSurfaceVariant.withAlpha(100),
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _results = []);
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: AxiomSpacing.md),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStitchFilterChip('All', _selectedFilter == 'All', () {
                  setState(() {
                    _selectedFilter = 'All';
                    _performSearch(_searchController.text, nodes);
                  });
                }),
                const SizedBox(width: AxiomSpacing.sm),
                _buildStitchFilterChip('Text', _selectedFilter == 'Text', () {
                  setState(() {
                    _selectedFilter = 'Text';
                    _performSearch(_searchController.text, nodes);
                  });
                }),
                const SizedBox(width: AxiomSpacing.sm),
                _buildStitchFilterChip('Code', _selectedFilter == 'Code', () {
                  setState(() {
                    _selectedFilter = 'Code';
                    _performSearch(_searchController.text, nodes);
                  });
                }),
                const SizedBox(width: AxiomSpacing.sm),
                _buildStitchFilterChip(
                  'Heading',
                  _selectedFilter == 'Heading',
                  () {
                    setState(() {
                      _selectedFilter = 'Heading';
                      _performSearch(_searchController.text, nodes);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStitchFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? cs.secondary : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
          border: isSelected
              ? null
              : Border.all(color: cs.outlineVariant.withAlpha(80), width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.secondary.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            Text(
              label,
              style: AxiomTypography.labelLarge.copyWith(
                color: isSelected ? Colors.white : cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 48,
            color: cs.onSurfaceVariant.withAlpha(60),
          ),
          const SizedBox(height: AxiomSpacing.md),
          Text(
            'Search your thoughts',
            style: AxiomTypography.heading3.copyWith(
              color: cs.onSurfaceVariant.withAlpha(120),
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          Text(
            'Type to find nodes, blocks, and content',
            style: AxiomTypography.bodySmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: cs.onSurfaceVariant.withAlpha(60),
          ),
          const SizedBox(height: AxiomSpacing.md),
          Text(
            'No results found',
            style: AxiomTypography.heading3.copyWith(
              color: cs.onSurfaceVariant.withAlpha(120),
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          Text(
            'Try different keywords or filters',
            style: AxiomTypography.bodySmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AxiomSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_results.length} results',
                style: AxiomTypography.heading3.copyWith(color: cs.onSurface),
              ),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _results = []);
                },
                child: Text('Clear all', style: TextStyle(color: cs.secondary)),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AxiomSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final result = _results[index];
              return _buildStitchResultCard(context, result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStitchResultCard(
    BuildContext context,
    search.SearchResult result,
  ) {
    final cs = Theme.of(context).colorScheme;
    final blockIcon = _getBlockIcon(result.blockType);
    final blockColor = _getBlockColor(result.blockType, cs);

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AxiomRadius.md),
      elevation: 0.5,
      shadowColor: cs.shadow.withAlpha(15),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(AxiomRadius.md),
        splashColor: cs.primary.withAlpha(15),
        child: Padding(
          padding: const EdgeInsets.all(AxiomSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon + time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: blockColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(blockIcon, color: blockColor, size: 18),
                  ),
                  Text(
                    result.blockType,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant.withAlpha(100),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AxiomSpacing.md),
              // Title
              Text(
                result.node.name.isEmpty
                    ? 'Node ${result.node.id.substring(0, 8)}...'
                    : result.node.name,
                style: AxiomTypography.bodyLarge.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Snippet
              Expanded(
                child: Text(
                  result.matchedContent,
                  style: AxiomTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant.withAlpha(150),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBlockColor(String blockType, ColorScheme cs) {
    return switch (blockType.toLowerCase()) {
      'text' => cs.primary,
      'heading' ||
      'heading h1' ||
      'heading h2' ||
      'heading h3' => const Color(0xFF7C3AED),
      'code' => cs.secondary,
      'quote' => const Color(0xFFF59E0B),
      'math' => cs.tertiary,
      'audio' => const Color(0xFF3B82F6),
      'sketch' => const Color(0xFFEC4899),
      _ => cs.onSurfaceVariant,
    };
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
