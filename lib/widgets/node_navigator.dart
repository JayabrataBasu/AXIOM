import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Floating panel to navigate and locate nodes on the infinite canvas
class NodeNavigator extends ConsumerStatefulWidget {
  const NodeNavigator({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    required this.onNodeSelect,
  });

  final List<IdeaNode> nodes;
  final String? selectedNodeId;
  final ValueChanged<String> onNodeSelect;

  @override
  ConsumerState<NodeNavigator> createState() => _NodeNavigatorState();
}

class _NodeNavigatorState extends ConsumerState<NodeNavigator> {
  bool _isExpanded = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredNodes = widget.nodes
        .where(
          (node) =>
              node.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              node.previewText.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: 80,
      left: 16,
      width: _isExpanded ? 320 : 56,
      height: _isExpanded ? 500 : 56,
      child: _isExpanded
          ? _buildExpandedPanel(theme, filteredNodes)
          : _buildMinimizedButton(theme),
    );
  }

  Widget _buildMinimizedButton(ThemeData theme) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = true),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Icon(Icons.map, color: Colors.white, size: 24)),
      ),
    );
  }

  Widget _buildExpandedPanel(ThemeData theme, List<IdeaNode> filteredNodes) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 72) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () =>
                                setState(() => _isExpanded = false),
                            padding: EdgeInsets.zero,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      );
                    }

                    final isCompact = constraints.maxWidth < 180;

                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!isCompact)
                          Icon(
                            Icons.map,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        if (!isCompact) const SizedBox(width: 8),
                        if (!isCompact)
                          Expanded(
                            child: Text(
                              'Nodes (${filteredNodes.length})',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          const Spacer(),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () =>
                                setState(() => _isExpanded = false),
                            padding: EdgeInsets.zero,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search nodes...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              // Node list
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 350, // Limit height so it's scrollable
              ),
              child: filteredNodes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No nodes found',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        itemCount: filteredNodes.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final node = filteredNodes[index];
                          final isSelected = node.id == widget.selectedNodeId;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () {
                                    // Trigger centering callback
                                    widget.onNodeSelect(node.id);
                                    // Keep panel open briefly so user sees selection
                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        if (mounted) {
                                          setState(() => _isExpanded = false);
                                        }
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints: const BoxConstraints(
                                      minHeight: 48,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                                .withValues(alpha: 0.2)
                                          : Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.5)
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          node.name.isEmpty
                                              ? 'Untitled Node'
                                              : node.name,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (node.previewText.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            node.previewText,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.6,
                                              ),
                                              fontSize: 11,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}
