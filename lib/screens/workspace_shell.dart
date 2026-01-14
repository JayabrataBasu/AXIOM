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

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  Future<void> _saveSession(WorkspaceSession updated) async {
    _session = updated;
    await ref
        .read(workspaceSessionsNotifierProvider.notifier)
        .updateSession(updated);
  }

  @override
  Widget build(BuildContext context) {
    return MatrixWorkspace(session: _session, onSessionChanged: _saveSession);
  }
}
