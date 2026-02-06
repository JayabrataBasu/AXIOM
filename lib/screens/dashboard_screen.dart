/// Dashboard/Home screen - entry point after onboarding
/// Based on Stitch design: axiom_home_dashboard
/// Theme-aware Material 3 Expressive styling.
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

  void _showFeatureHint(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final sessionsAsync = ref.watch(workspaceSessionsNotifierProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context, ref),
      drawer: _buildNavigationDrawer(context, ref),
      body: sessionsAsync.when(
        data: (sessions) => _buildContent(context, ref, sessions),
        loading: () =>
            Center(child: CircularProgressIndicator(color: cs.primary)),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(color: cs.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/welcome'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Workspace'),
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: cs.primary,
      title: Row(
        children: [
          // Logo - using primary/secondary accent
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.secondary],
              ),
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withAlpha(50),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(Icons.api_rounded, color: cs.surface, size: 18),
          ),
          const SizedBox(width: AxiomSpacing.sm),
          Text(
            'AXIOM',
            style: AxiomTypography.heading2.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant.withAlpha(150)),
          onPressed: () {
            _showFeatureHint(context, 'Global search coming soon.');
          },
        ),
        const SizedBox(width: AxiomSpacing.xs),
        // Profile button
        Padding(
          padding: const EdgeInsets.only(right: AxiomSpacing.md),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: cs.surfaceContainerHigh,
            child: Icon(
              Icons.person_rounded,
              color: cs.onSurfaceVariant.withAlpha(150),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationDrawer(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: cs.surfaceContainerLow,
      child: Column(
        children: [
          // Drawer header with warm gradient
          Container(
            padding: const EdgeInsets.all(AxiomSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary.withAlpha(20), Colors.transparent],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AxiomSpacing.md),
                  Text(
                    'AXIOM',
                    style: AxiomTypography.displayMedium.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AxiomSpacing.xs),
                  Text(
                    'A Thinking System',
                    style: AxiomTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AxiomSpacing.sm),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  selected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.folder_rounded,
                  label: 'Workspaces',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/workspaces');
                  },
                ),
                Divider(color: cs.outlineVariant, height: 32),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureHint(context, 'Settings coming soon.');
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureHint(context, 'Help center coming soon.');
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
          const SizedBox(height: AxiomSpacing.xxl),

          // Recent workspaces
          _buildRecentWorkspaces(context, ref, sessions),
          const SizedBox(height: AxiomSpacing.xxl),

          // Quick stats
          _buildQuickStats(context, sessions),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: AxiomTypography.displayMedium.copyWith(
            color: cs.onSurface,
            height: 1.1,
          ),
        ),
        Text(
          'Commander.',
          style: AxiomTypography.displayMedium.copyWith(
            color: cs.primary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AxiomSpacing.lg),

        // Status indicator - M3 chip style
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.md,
            vertical: AxiomSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withAlpha(100),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              Text(
                'All systems operational',
                style: AxiomTypography.labelSmall.copyWith(
                  color: cs.onSurfaceVariant.withAlpha(150),
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
    final cs = Theme.of(context).colorScheme;
    final recentSessions = sessions.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Workspaces',
              style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
            ),
            TextButton(
              onPressed: () => context.push('/workspaces'),
              child: Text(
                'View All',
                style: TextStyle(color: cs.secondary),
              ),
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
                      Icons.folder_open_rounded,
                      size: 48,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'No workspaces yet',
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
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
    final cs = Theme.of(context).colorScheme;
    return AxiomCard(
      elevated: true,
      onTap: () {
        // ignore: avoid_print
        print('DASHBOARD: workspace card tapped -> ${session.id}');

        // Navigate FIRST to avoid router rebuild from state change
        context.push('/workspace/${session.id}');

        // THEN set active workspace in post-frame callback
        // This ensures state change happens AFTER navigation starts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(activeWorkspaceIdProvider.notifier)
              .setActiveWorkspace(session.id);
        });
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
                  color: cs.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AxiomRadius.md),
                ),
                child: Icon(
                  _getWorkspaceIcon(session.workspaceType),
                  color: cs.primary,
                  size: 22,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.label.isNotEmpty ? session.label : 'Untitled Workspace',
                style: AxiomTypography.heading3.copyWith(color: cs.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AxiomSpacing.xs),
              Text(
                _formatDate(session.updatedAt),
                style: AxiomTypography.labelSmall.copyWith(
                  color: cs.onSurfaceVariant,
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
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
        ),
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
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      'Workspaces',
                      style: AxiomTypography.labelMedium.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
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
                        color: cs.secondary,
                      ),
                    ),
                    Text(
                      'Nodes',
                      style: AxiomTypography.labelMedium.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
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
        return Icons.calculate_rounded;
      case 'canvas':
      default:
        return Icons.grid_view_rounded;
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

/// M3 styled drawer item
class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? cs.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AxiomRadius.full),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AxiomRadius.full),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AxiomSpacing.md,
              vertical: AxiomSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? cs.onSecondaryContainer
                      : cs.onSurfaceVariant,
                ),
                const SizedBox(width: AxiomSpacing.md),
                Text(
                  label,
                  style: AxiomTypography.labelLarge.copyWith(
                    color: selected
                        ? cs.onSecondaryContainer
                        : cs.onSurface,
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
