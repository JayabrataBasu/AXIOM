import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/workspace_providers.dart';
import '../workspaces/matrix_calculator/matrix_workspace.dart';

/// Shell screen that loads a workspace session and renders the appropriate workspace UI.
class WorkspaceShell extends ConsumerWidget {
  const WorkspaceShell({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(workspaceSessionProvider(sessionId));

    return sessionAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Workspace')),
        body: Center(child: Text('Error: $err')),
      ),
      data: (session) {
        if (session == null) {
          return const Scaffold(body: Center(child: Text('Session not found')));
        }

        switch (session.workspaceType) {
          case 'matrix_calculator':
            return MatrixWorkspaceShell(session: session);
          default:
            return Scaffold(
              appBar: AppBar(title: const Text('Workspace')),
              body: const Center(child: Text('Unsupported workspace type')),
            );
        }
      },
    );
  }
}

/// Matrix workspace shell that wires session updates to repository.
class MatrixWorkspaceShell extends ConsumerStatefulWidget {
  const MatrixWorkspaceShell({super.key, required this.session});

  final WorkspaceSession session;

  @override
  ConsumerState<MatrixWorkspaceShell> createState() =>
      _MatrixWorkspaceShellState();
}

class _MatrixWorkspaceShellState extends ConsumerState<MatrixWorkspaceShell> {
  late WorkspaceSession _session;
  bool _hasBeenModified = false;
  bool _isForking = false;
  bool _forkOnModifyEnabled = true; // Default: enabled

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  void _showWorkspaceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workspace Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Fork on Modify'),
                subtitle: const Text(
                  'Automatically preserve original when making changes',
                ),
                value: _forkOnModifyEnabled,
                onChanged: (value) {
                  setModalState(() => _forkOnModifyEnabled = value);
                  setState(() => _forkOnModifyEnabled = value);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Fork-on-modify: automatically fork on first modification to preserve original.
  Future<void> _saveSession(WorkspaceSession updated) async {
    // If fork-on-modify is enabled and this is the first modification
    if (_forkOnModifyEnabled && !_hasBeenModified && !_isForking) {
      _hasBeenModified = true;
      _isForking = true;

      try {
        // Fork the original session to preserve it
        final forked = await ref
            .read(workspaceSessionsNotifierProvider.notifier)
            .forkSession(_session.id);

        // Update the forked session with the new data
        final updatedFork = forked.copyWith(
          data: updated.data,
          updatedAt: DateTime.now(),
        );

        setState(() {
          _session = updatedFork;
          _isForking = false;
        });

        await ref
            .read(workspaceSessionsNotifierProvider.notifier)
            .updateSession(updatedFork);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session forked - original preserved'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        setState(() => _isForking = false);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fork failed: $e')));
        }
      }
    } else {
      // Subsequent modifications or fork disabled - just update the session
      _session = updated;
      await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .updateSession(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MatrixWorkspace(
      session: _session,
      onSessionChanged: _saveSession,
      onShowSettings: _showWorkspaceSettings,
    );
  }
}
