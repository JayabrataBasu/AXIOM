import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/spacing.dart';
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
        ).showSnackBar(
          SnackBar(content: Text('Forked as "${forked.label}"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(content: Text('Error forking workspace: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionsAsync = ref.watch(workspaceSessionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Sessions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.m),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search workspaces...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          final filteredSessions = _searchQuery.isEmpty
              ? sessions
              : sessions.where((s) {
                  final labelLower = s.label.toLowerCase();
                  final typeLower = s.workspaceType.toString().toLowerCase();
                  return labelLower.contains(_searchQuery) ||
                      typeLower.contains(_searchQuery);
                }).toList();

          if (filteredSessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty ? Icons.workspaces : Icons.search_off,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: Spacing.m),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No workspace sessions yet'
                        : 'No workspaces match your search',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.m),
            itemCount: filteredSessions.length,
            itemBuilder: (context, index) {
              final session = filteredSessions[index];
              final icon = _getWorkspaceIcon(session.workspaceType);
              final theme = Theme.of(context);

              return Card(
                margin: const EdgeInsets.only(bottom: Spacing.m),
                child: InkWell(
                  onTap: () => _openSession(session),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        // Main content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(icon, size: 32),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.label.isNotEmpty
                                            ? session.label
                                            : 'Untitled',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        session.workspaceType,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Top-right buttons
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Delete button (red)
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: theme.colorScheme.error,
                                tooltip: 'Delete',
                                onPressed: () => _deleteSession(session),
                              ),
                              // 3-dot menu
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'open',
                                    child: ListTile(
                                      leading: Icon(Icons.open_in_new),
                                      title: Text('Open'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'fork',
                                    child: ListTile(
                                      leading: Icon(Icons.call_split),
                                      title: Text('Fork'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'rename',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Rename'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'clone',
                                    child: ListTile(
                                      leading: Icon(Icons.content_copy),
                                      title: Text('Clone'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  switch (value) {
                                    case 'open':
                                      _openSession(session);
                                      break;
                                    case 'fork':
                                      _forkSession(session);
                                      break;
                                    case 'rename':
                                      _renameSession(session);
                                      break;
                                    case 'clone':
                                      _cloneSession(session);
                                      break;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: Spacing.m),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
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
        return Icons.workspaces;
    }
  }
}
