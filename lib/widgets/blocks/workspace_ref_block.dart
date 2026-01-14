import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workspace_providers.dart';
import '../../screens/workspace_shell.dart';

/// Display widget for workspace reference blocks.
class WorkspaceRefBlockDisplay extends ConsumerWidget {
  const WorkspaceRefBlockDisplay({
    super.key,
    required this.sessionId,
    required this.label,
  });

  final String sessionId;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(workspaceSessionProvider(sessionId));

    final title = sessionAsync.maybeWhen(
      data: (session) => session?.label.isNotEmpty == true
          ? session!.label
          : (label.isNotEmpty
                ? label
                : session?.preview ?? 'Workspace Session'),
      orElse: () => label.isNotEmpty ? label : 'Workspace Session',
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.widgets, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${sessionId.substring(0, 8)}...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openSession(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Session'),
            ),
          ),
        ],
      ),
    );
  }

  void _openSession(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WorkspaceShell(sessionId: sessionId)),
    );
  }
}
