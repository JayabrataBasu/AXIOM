import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/design_tokens.dart';
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
    final sessionAsync = ref.watch(workspaceSessionProvider(sessionId));

    final title = sessionAsync.maybeWhen(
      data: (session) => session?.label.isNotEmpty == true
          ? session!.label
          : (label.isNotEmpty
                ? label
                : session?.preview ?? 'Workspace Session'),
      orElse: () => label.isNotEmpty ? label : 'Workspace Session',
    );

    // Everforest styled workspace reference card
    return Container(
      padding: EdgeInsets.all(AxiomSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AxiomColors.bg2,
        borderRadius: BorderRadius.circular(AxiomRadius.sm),
        border: Border.all(color: AxiomColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.widgets, color: AxiomColors.yellow),
              SizedBox(width: AxiomSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AxiomTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AxiomColors.fg,
                      ),
                    ),
                    Text(
                      'ID: ${sessionId.substring(0, 8)}...',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: AxiomColors.grey1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AxiomSpacing.sm + 2),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openSession(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Session'),
              style: FilledButton.styleFrom(
                backgroundColor: AxiomColors.yellow,
                foregroundColor: AxiomColors.bg0,
              ),
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
