/// Dashboard/Home screen - entry point after onboarding
/// Based on Stitch design: axiom_home_dashboard
/// Updated for Everforest dark theme with Material 3 Expressive styling.
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
    final sessionsAsync = ref.watch(workspaceSessionsNotifierProvider);

    return Scaffold(
      backgroundColor: AxiomColors.bg0,
      appBar: _buildAppBar(context, ref),
      drawer: _buildNavigationDrawer(context, ref),
      body: sessionsAsync.when(
        data: (sessions) => _buildContent(context, ref, sessions),
        loading: () =>
            Center(child: CircularProgressIndicator(color: AxiomColors.green)),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(color: AxiomColors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/welcome'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Workspace'),
        backgroundColor: AxiomColors.primaryContainer,
        foregroundColor: AxiomColors.onPrimaryContainer,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AxiomColors.bg0,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: AxiomColors.green,
      title: Row(
        children: [
          // Logo - using Everforest green accent
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AxiomColors.green, AxiomColors.aqua],
              ),
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: AxiomColors.green.withAlpha(50),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(Icons.api, color: AxiomColors.bg0, size: 18),
          ),
          const SizedBox(width: AxiomSpacing.sm),
          Text(
            'AXIOM',
            style: AxiomTypography.heading2.copyWith(
              color: AxiomColors.fg,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: AxiomColors.grey1),
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
            backgroundColor: AxiomColors.bg3,
            child: Icon(
              Icons.person_rounded,
              color: AxiomColors.grey1,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AxiomColors.surfaceContainerLow,
      child: Column(
        children: [
          // Drawer header with warm gradient
          Container(
            padding: const EdgeInsets.all(AxiomSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AxiomColors.green.withAlpha(20), Colors.transparent],
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
                      color: AxiomColors.fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AxiomSpacing.xs),
                  Text(
                    'A Thinking System',
                    style: AxiomTypography.bodySmall.copyWith(
                      color: AxiomColors.grey1,
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
                Divider(color: AxiomColors.outlineVariant, height: 32),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: AxiomTypography.displayMedium.copyWith(
            color: AxiomColors.fg,
            height: 1.1,
          ),
        ),
        Text(
          'Commander.',
          style: AxiomTypography.displayMedium.copyWith(
            color: AxiomColors.green,
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
            color: AxiomColors.bg2,
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            border: Border.all(color: AxiomColors.outlineVariant, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AxiomColors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AxiomColors.green.withAlpha(100),
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
                  color: AxiomColors.grey1,
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
            Text(
              'Recent Workspaces',
              style: AxiomTypography.heading2.copyWith(color: AxiomColors.fg),
            ),
            TextButton(
              onPressed: () => context.push('/workspaces'),
              child: Text(
                'View All',
                style: TextStyle(color: AxiomColors.aqua),
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
                      color: AxiomColors.grey0,
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'No workspaces yet',
                      style: AxiomTypography.bodyMedium.copyWith(
                        color: AxiomColors.grey1,
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
                  color: AxiomColors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(AxiomRadius.md),
                ),
                child: Icon(
                  _getWorkspaceIcon(session.workspaceType),
                  color: AxiomColors.green,
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
                style: AxiomTypography.heading3.copyWith(color: AxiomColors.fg),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AxiomSpacing.xs),
              Text(
                _formatDate(session.updatedAt),
                style: AxiomTypography.labelSmall.copyWith(
                  color: AxiomColors.grey0,
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
        Text(
          'Quick Stats',
          style: AxiomTypography.heading2.copyWith(color: AxiomColors.fg),
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
                        color: AxiomColors.green,
                      ),
                    ),
                    Text(
                      'Workspaces',
                      style: AxiomTypography.labelMedium.copyWith(
                        color: AxiomColors.grey1,
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
                        color: AxiomColors.aqua,
                      ),
                    ),
                    Text(
                      'Nodes',
                      style: AxiomTypography.labelMedium.copyWith(
                        color: AxiomColors.grey1,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? AxiomColors.secondaryContainer : Colors.transparent,
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
                      ? AxiomColors.onSecondaryContainer
                      : AxiomColors.onSurfaceVariant,
                ),
                const SizedBox(width: AxiomSpacing.md),
                Text(
                  label,
                  style: AxiomTypography.labelLarge.copyWith(
                    color: selected
                        ? AxiomColors.onSecondaryContainer
                        : AxiomColors.onSurface,
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
