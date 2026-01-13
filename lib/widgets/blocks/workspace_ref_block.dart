import 'package:flutter/material.dart';

/// Display widget for workspace reference blocks.
class WorkspaceRefBlockDisplay extends StatefulWidget {
  const WorkspaceRefBlockDisplay({
    super.key,
    required this.sessionId,
    required this.label,
  });

  final String sessionId;
  final String label;

  @override
  State<WorkspaceRefBlockDisplay> createState() => _WorkspaceRefBlockDisplayState();
}

class _WorkspaceRefBlockDisplayState extends State<WorkspaceRefBlockDisplay> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      widget.label.isNotEmpty ? widget.label : 'Workspace Session',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ID: ${widget.sessionId.substring(0, 8)}...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
              onPressed: _openSession,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Session'),
            ),
          ),
        ],
      ),
    );
  }

  void _openSession() {
    // TODO: Implement session opening logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening session...')),
    );
  }
}
