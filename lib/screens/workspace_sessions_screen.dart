import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_tokens.dart';
import '../models/workspace_session.dart';
import '../providers/workspace_providers.dart';
import '../providers/workspace_state_provider.dart';

/// Screen for browsing and managing workspace sessions.
class WorkspaceSessionsScreen extends ConsumerStatefulWidget {
  const WorkspaceSessionsScreen({super.key});

  @override
  ConsumerState<WorkspaceSessionsScreen> createState() =>
      _WorkspaceSessionsScreenState();
}

class _WorkspaceSessionsScreenState
    extends ConsumerState<WorkspaceSessionsScreen> {
  String _searchQuery = '';

  Future<void> _openSession(WorkspaceSession session) async {
    try {
      // ignore: avoid_print
      print('WORKSPACES: opening workspace -> ${session.id}');

      // Navigate FIRST to avoid router rebuild from state change
      if (mounted) {
        context.push('/workspace/${session.id}');

        // THEN set active workspace in post-frame callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(activeWorkspaceIdProvider.notifier)
              .setActiveWorkspace(session.id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening workspace: $e')));
      }
    }
  }

  Future<void> _renameSession(WorkspaceSession session) async {
    final controller = TextEditingController(text: session.label);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Workspace Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != session.label) {
      await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .updateSession(session.copyWith(label: result));

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Renamed to "$result"')));
      }
    }
  }

  Future<void> _cloneSession(WorkspaceSession session) async {
    final controller = TextEditingController(text: '${session.label} (Copy)');

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clone Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Workspace Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Clone'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .cloneSession(session.id, newName: result);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cloned as "$result"')));
      }
    }
  }

  Future<void> _deleteSession(WorkspaceSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: Text('Are you sure you want to delete "${session.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .deleteSession(session.id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workspace deleted')));
      }
    }
  }

  Future<void> _forkSession(WorkspaceSession session) async {
    try {
      final forked = await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .forkSession(session.id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Forked as "${forked.label}"')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error forking workspace: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sessionsAsync = ref.watch(workspaceSessionsNotifierProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spacer for status bar
            const SizedBox(height: AxiomSpacing.md),

            // Header section with title + search + chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AxiomSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'My Workspaces',
                    style: AxiomTypography.display.copyWith(
                      color: cs.onSurface,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AxiomSpacing.lg),

                  // Search bar (rounded, full-width)
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AxiomRadius.full),
                      border: Border.all(
                        color: cs.outlineVariant.withAlpha(60),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withAlpha(6),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.search_rounded,
                            color: cs.onSurfaceVariant.withAlpha(120),
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search workspaces...',
                              hintStyle: TextStyle(
                                color: cs.onSurfaceVariant.withAlpha(100),
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AxiomSpacing.md),

                  // Filter chips (horizontal scroll)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected: true,
                          onTap: () {},
                        ),
                        const SizedBox(width: AxiomSpacing.sm),
                        _FilterChip(
                          label: 'Recent',
                          isSelected: false,
                          onTap: () {},
                        ),
                        const SizedBox(width: AxiomSpacing.sm),
                        _FilterChip(
                          label: 'Pinned',
                          isSelected: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AxiomSpacing.md),

            // Workspace list
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                  final filteredSessions = _searchQuery.isEmpty
                      ? sessions
                      : sessions.where((s) {
                          final labelLower = s.label.toLowerCase();
                          final typeLower = s.workspaceType
                              .toString()
                              .toLowerCase();
                          return labelLower.contains(_searchQuery) ||
                              typeLower.contains(_searchQuery);
                        }).toList();

                  if (filteredSessions.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AxiomSpacing.lg,
                    ),
                    itemCount: filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = filteredSessions[index];
                      return _buildWorkspaceCard(context, session);
                    },
                  );
                },
                loading: () =>
                    Center(child: CircularProgressIndicator(color: cs.primary)),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: cs.error),
                      const SizedBox(height: AxiomSpacing.md),
                      Text('Error: $error', style: TextStyle(color: cs.error)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/welcome'),
        backgroundColor: cs.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.lg),
        ),
        elevation: 6,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty
                ? Icons.folder_open_rounded
                : Icons.search_off_rounded,
            size: 56,
            color: cs.onSurfaceVariant.withAlpha(80),
          ),
          const SizedBox(height: AxiomSpacing.md),
          Text(
            _searchQuery.isEmpty
                ? 'No workspaces yet'
                : 'No workspaces match your search',
            style: AxiomTypography.heading3.copyWith(
              color: cs.onSurfaceVariant.withAlpha(150),
            ),
          ),
          const SizedBox(height: AxiomSpacing.sm),
          Text(
            'Create your first workspace to start thinking',
            style: AxiomTypography.bodySmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(100),
            ),
          ),
          const SizedBox(height: AxiomSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.push('/welcome'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Workspace'),
            style: FilledButton.styleFrom(
              backgroundColor: cs.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AxiomSpacing.xl,
                vertical: AxiomSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.full),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceCard(BuildContext context, WorkspaceSession session) {
    final cs = Theme.of(context).colorScheme;
    final icon = _getWorkspaceIcon(session.workspaceType);

    return Container(
      margin: const EdgeInsets.only(bottom: AxiomSpacing.md),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        elevation: 1,
        shadowColor: cs.shadow.withAlpha(20),
        child: InkWell(
          onTap: () => _openSession(session),
          borderRadius: BorderRadius.circular(AxiomRadius.lg),
          splashColor: cs.primary.withAlpha(15),
          child: Padding(
            padding: const EdgeInsets.all(AxiomSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: icon + more button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: cs.primary, size: 20),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: cs.onSurfaceVariant.withAlpha(100),
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AxiomRadius.md),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Open'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'rename',
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Rename'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'fork',
                          child: Row(
                            children: [
                              Icon(Icons.call_split_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Fork'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'clone',
                          child: Row(
                            children: [
                              Icon(Icons.content_copy_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Clone'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                                color: cs.error,
                              ),
                              const SizedBox(width: 12),
                              Text('Delete', style: TextStyle(color: cs.error)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'open':
                            _openSession(session);
                          case 'fork':
                            _forkSession(session);
                          case 'rename':
                            _renameSession(session);
                          case 'clone':
                            _cloneSession(session);
                          case 'delete':
                            _deleteSession(session);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AxiomSpacing.xxl),

                // Title
                Text(
                  session.label.isNotEmpty ? session.label : 'Untitled',
                  style: AxiomTypography.heading3.copyWith(
                    color: cs.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Timestamp
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: cs.onSurfaceVariant.withAlpha(120),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last opened ${_formatDate(session.updatedAt)}',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(120),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 5) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getWorkspaceIcon(String type) {
    switch (type) {
      case 'calculator':
        return Icons.calculate;
      case 'matrix_calculator':
        return Icons.grid_on;
      case 'text_analysis':
        return Icons.text_fields;
      case 'code_editor':
        return Icons.code;
      default:
        return Icons.science_rounded;
    }
  }
}

/// Filter chip matching Stitch design (rounded, active state)
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? cs.secondary : cs.surfaceContainer,
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
        child: Text(
          label,
          style: AxiomTypography.labelLarge.copyWith(
            color: isSelected ? Colors.white : cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
