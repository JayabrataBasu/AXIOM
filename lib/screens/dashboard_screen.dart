/// Dashboard/Home screen - entry point after onboarding
/// Based on Stitch design: axiom_home_dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';
import '../widgets/components/axiom_card.dart';
import '../providers/workspace_providers.dart';
import '../providers/workspace_state_provider.dart';
import '../models/workspace_session.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(workspaceSessionsNotifierProvider);

    return Scaffold(
      backgroundColor: AxiomColors.backgroundDark,
      appBar: _buildAppBar(context, ref),
      drawer: _buildNavigationDrawer(context, ref),
      body: sessionsAsync.when(
        data: (sessions) => _buildContent(context, ref, sessions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/welcome'),
        icon: const Icon(Icons.add),
        label: const Text('New Workspace'),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AxiomColors.backgroundDark.withAlpha(
        (0.9 * 255).round(),
      ),
      elevation: 0,
      title: Row(
        children: [
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AxiomColors.primary, AxiomColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(AxiomRadius.md),
              boxShadow: AxiomElevation.glow,
            ),
            child: const Icon(Icons.api, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AxiomSpacing.sm),
          Text(
            'AXIOM',
            style: AxiomTypography.heading2.copyWith(
              fontWeight: AxiomTypography.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implement search
          },
        ),
        const SizedBox(width: AxiomSpacing.sm),
        // Profile button
        Padding(
          padding: const EdgeInsets.only(right: AxiomSpacing.md),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AxiomColors.surfaceVariant,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AxiomColors.surfaceDark,
      child: Column(
        children: [
          // Drawer header
          Container(
            padding: const EdgeInsets.all(AxiomSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AxiomColors.primary.withAlpha((0.2 * 255).round()),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AxiomSpacing.xl),
                Text(
                  'AXIOM',
                  style: AxiomTypography.displayMedium.copyWith(
                    fontWeight: AxiomTypography.bold,
                  ),
                ),
                const SizedBox(height: AxiomSpacing.xs),
                Text(
                  'Thinking System',
                  style: AxiomTypography.bodySmall.copyWith(
                    color: AxiomColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AxiomSpacing.sm),
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  selected: true,
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Workspaces'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/workspaces');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Show help
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<WorkspaceSession> sessions,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AxiomSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section
          _buildHeroSection(context),
          const SizedBox(height: AxiomSpacing.xl),

          // Recent workspaces
          _buildRecentWorkspaces(context, ref, sessions),
          const SizedBox(height: AxiomSpacing.xl),

          // Quick stats
          _buildQuickStats(context, sessions),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: AxiomTypography.displayMedium.copyWith(height: 1.1),
        ),
        Text(
          'Commander.',
          style: AxiomTypography.displayMedium.copyWith(
            color: AxiomColors.primaryLight,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AxiomSpacing.md),

        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.md,
            vertical: AxiomSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AxiomColors.surfaceDark,
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            border: Border.all(color: AxiomColors.borderDark, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AxiomColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AxiomColors.success.withAlpha((0.5 * 255).round()),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              Text(
                'All systems operational',
                style: AxiomTypography.labelSmall.copyWith(
                  color: AxiomColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkspaces(
    BuildContext context,
    WidgetRef ref,
    List<WorkspaceSession> sessions,
  ) {
    final recentSessions = sessions.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Workspaces', style: AxiomTypography.heading2),
            TextButton(
              onPressed: () => context.push('/workspaces'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AxiomSpacing.md),

        if (recentSessions.isEmpty)
          AxiomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AxiomSpacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: AxiomColors.textMuted,
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'No workspaces yet',
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: AxiomColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
              crossAxisSpacing: AxiomSpacing.md,
              mainAxisSpacing: AxiomSpacing.md,
              childAspectRatio: 1.2,
            ),
            itemCount: recentSessions.length,
            itemBuilder: (context, index) {
              final session = recentSessions[index];
              return _buildWorkspaceCard(context, ref, session);
            },
          ),
      ],
    );
  }

  Widget _buildWorkspaceCard(
    BuildContext context,
    WidgetRef ref,
    WorkspaceSession session,
  ) {
    return AxiomCard(
      elevated: true,
      onTap: () {
        ref
            .read(activeWorkspaceIdProvider.notifier)
            .setActiveWorkspace(session.id);
        context.go('/workspace/${session.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AxiomColors.primary.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(AxiomRadius.md),
                ),
                child: Icon(
                  _getWorkspaceIcon(session.workspaceType),
                  color: AxiomColors.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.label.isNotEmpty ? session.label : 'Untitled Workspace',
                style: AxiomTypography.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AxiomSpacing.xs),
              Text(
                _formatDate(session.updatedAt),
                style: AxiomTypography.labelSmall.copyWith(
                  color: AxiomColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    List<WorkspaceSession> sessions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Stats', style: AxiomTypography.heading2),
        const SizedBox(height: AxiomSpacing.md),
        Row(
          children: [
            Expanded(
              child: AxiomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sessions.length}',
                      style: AxiomTypography.displaySmall.copyWith(
                        color: AxiomColors.primary,
                      ),
                    ),
                    Text('Workspaces', style: AxiomTypography.labelMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AxiomSpacing.md),
            Expanded(
              child: AxiomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0',
                      style: AxiomTypography.displaySmall.copyWith(
                        color: AxiomColors.primary,
                      ),
                    ),
                    Text('Nodes', style: AxiomTypography.labelMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getWorkspaceIcon(String type) {
    switch (type) {
      case 'matrix_calculator':
        return Icons.calculate;
      case 'canvas':
      default:
        return Icons.grid_on;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
