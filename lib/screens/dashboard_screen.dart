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
import '../models/mind_map.dart';
import '../models/maths.dart';
import '../services/mind_map_service.dart';
import '../services/maths_service.dart';
import 'mind_map_screen.dart';
import 'maths_screen.dart';

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
          child: Text('Error: $error', style: TextStyle(color: cs.error)),
        ),
      ),
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
          icon: Icon(
            Icons.search_rounded,
            color: cs.onSurfaceVariant.withAlpha(150),
          ),
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

          // Mind maps section
          _buildMindMapsSection(context, ref),
          const SizedBox(height: AxiomSpacing.xxl),

          // Maths Corner section
          _buildMathsCornerSection(context, ref),
          const SizedBox(height: AxiomSpacing.xxl),

          // Quick stats
          _buildQuickStats(context, sessions),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date / greeting label
          Text(
            greeting.toUpperCase(),
            style: AxiomTypography.labelSmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(180),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Main heading
          Text(
            'Ready to explore\nnew ideas?',
            style: AxiomTypography.displayMedium.copyWith(
              color: cs.onSurface,
              height: 1.15,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
              child: Text('View All', style: TextStyle(color: cs.secondary)),
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
          // Top row: icon + 3-dot menu (Stitch design)
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
                child: Icon(
                  _getWorkspaceIcon(session.workspaceType),
                  color: cs.primary,
                  size: 20,
                ),
              ),
              Icon(
                Icons.more_vert_rounded,
                color: cs.onSurfaceVariant.withAlpha(100),
                size: 20,
              ),
            ],
          ),
          // Bottom: title + timestamp (Stitch design)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.label.isNotEmpty ? session.label : 'Untitled Workspace',
                style: AxiomTypography.heading3.copyWith(
                  color: cs.onSurface,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant.withAlpha(120),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Last opened ${_formatDate(session.updatedAt)}',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(120),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapsSection(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final workspaceId = ref.watch(activeWorkspaceIdProvider) ?? '';
    final mindMapService = MindMapService.instance;

    return FutureBuilder<List<MindMapGraph>>(
      future: mindMapService.listMindMaps(workspaceId),
      builder: (context, snapshot) {
        final mindMaps = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mind Maps',
                  style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
                ),
                TextButton.icon(
                  onPressed: () => _createNewMindMap(context, ref),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New'),
                ),
              ],
            ),
            const SizedBox(height: AxiomSpacing.md),

            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (mindMaps.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AxiomSpacing.xl),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AxiomRadius.md),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_tree_outlined,
                      size: 48,
                      color: cs.onSurfaceVariant.withAlpha(100),
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'No mind maps yet',
                      style: AxiomTypography.heading3.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.xs),
                    Text(
                      'Create your first mind map to visualize ideas',
                      style: AxiomTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AxiomSpacing.md,
                  mainAxisSpacing: AxiomSpacing.md,
                  childAspectRatio: 1.2,
                ),
                itemCount: mindMaps.length,
                itemBuilder: (context, index) {
                  final mindMap = mindMaps[index];
                  return _buildMindMapCard(context, ref, mindMap);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildMindMapCard(
    BuildContext context,
    WidgetRef ref,
    MindMapGraph mindMap,
  ) {
    final cs = Theme.of(context).colorScheme;
    return AxiomCard(
      elevated: true,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MindMapScreen(
              workspaceId: mindMap.workspaceId,
              mapId: mindMap.id,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row: icon + node count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AxiomColors.purple.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_tree,
                  color: AxiomColors.purple,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AxiomRadius.xs),
                ),
                child: Text(
                  '${mindMap.nodes.length} nodes',
                  style: AxiomTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          // Bottom: title + timestamp
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mindMap.name,
                style: AxiomTypography.heading3.copyWith(
                  color: cs.onSurface,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant.withAlpha(120),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Updated ${_formatDate(mindMap.updatedAt)}',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(120),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createNewMindMap(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();

    final result = await showDialog<_MindMapCreateChoice?>(
      context: context,
      builder: (context) {
        String selectedTemplateId = MindMapService.templates.first.id;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Create Mind Map'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Mind map name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedTemplateId,
                  decoration: const InputDecoration(
                    labelText: 'Template',
                    border: OutlineInputBorder(),
                  ),
                  items: MindMapService.templates
                      .map(
                        (template) => DropdownMenuItem<String>(
                          value: template.id,
                          child: Text(template.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedTemplateId = value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    Navigator.pop(
                      context,
                      _MindMapCreateChoice(name, selectedTemplateId),
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );

    if (result == null || !context.mounted) return;

    final workspaceId = ref.read(activeWorkspaceIdProvider) ?? '';
    final mindMapService = MindMapService.instance;

    final newMap = await mindMapService.createMindMapWithTemplate(
      workspaceId: workspaceId,
      name: result.name,
      templateId: result.templateId,
    );

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MindMapScreen(workspaceId: newMap.workspaceId, mapId: newMap.id),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // MATHS CORNER SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMathsCornerSection(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final workspaceId = ref.watch(activeWorkspaceIdProvider) ?? '';
    final mathsService = MathsService.instance;

    return FutureBuilder<List<MathsObject>>(
      future: mathsService.listMathsObjects(workspaceId),
      builder: (context, snapshot) {
        final objects = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maths Corner',
                  style: AxiomTypography.heading2.copyWith(color: cs.onSurface),
                ),
                TextButton.icon(
                  onPressed: () => _createNewMathsObject(context, ref),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New'),
                ),
              ],
            ),
            const SizedBox(height: AxiomSpacing.md),

            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (objects.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AxiomSpacing.xl),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AxiomRadius.md),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      size: 48,
                      color: cs.onSurfaceVariant.withAlpha(100),
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    Text(
                      'No maths objects yet',
                      style: AxiomTypography.heading3.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.xs),
                    Text(
                      'Create matrices or graphs for computation',
                      style: AxiomTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant.withAlpha(150),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AxiomSpacing.md,
                  mainAxisSpacing: AxiomSpacing.md,
                  childAspectRatio: 1.2,
                ),
                itemCount: objects.length,
                itemBuilder: (context, index) {
                  final obj = objects[index];
                  return _buildMathsCard(context, ref, obj);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildMathsCard(BuildContext context, WidgetRef ref, MathsObject obj) {
    final cs = Theme.of(context).colorScheme;
    final isMatrix = obj is MatrixObject;
    final String subtitle;
    if (obj is MatrixObject) {
      subtitle = '${obj.data.rows}×${obj.data.cols} matrix';
    } else if (obj is GraphObject) {
      subtitle = '${obj.data.equations.length} equations';
    } else {
      subtitle = 'unknown';
    }
    final accentColor = isMatrix ? AxiomColors.aqua : AxiomColors.orange;

    return AxiomCard(
      elevated: true,
      onTap: () {
        final workspaceId = ref.read(activeWorkspaceIdProvider) ?? '';
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MathsScreen(workspaceId: workspaceId, mathsObjectId: obj.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row: icon + type badge + delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMatrix ? Icons.grid_on : Icons.show_chart,
                  color: accentColor,
                  size: 20,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AxiomRadius.xs),
                    ),
                    child: Text(
                      subtitle,
                      style: AxiomTypography.labelSmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _deleteMathsObject(context, ref, obj),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: cs.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Bottom: title + timestamp
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                obj.name,
                style: AxiomTypography.heading3.copyWith(
                  color: cs.onSurface,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: cs.onSurfaceVariant.withAlpha(100),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    obj.updatedAt.toLocal().toIso8601String().split('T').first,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant.withAlpha(100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createNewMathsObject(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final nameController = TextEditingController();
    String selectedType = 'matrix';
    int rows = 3;
    int cols = 3;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('New Maths Object'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'matrix', child: Text('Matrix')),
                      DropdownMenuItem(value: 'graph', child: Text('Graph')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => selectedType = v);
                    },
                  ),
                  if (selectedType == 'matrix') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: rows,
                            decoration: const InputDecoration(
                              labelText: 'Rows',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              8,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => rows = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: cols,
                            decoration: const InputDecoration(
                              labelText: 'Cols',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              8,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => cols = v);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(ctx, {
                      'name': name,
                      'type': selectedType,
                      'rows': rows,
                      'cols': cols,
                    });
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;
    if (!context.mounted) return;

    final workspaceId = ref.read(activeWorkspaceIdProvider) ?? '';
    final mathsService = MathsService.instance;

    late MathsObject newObj;
    if (result['type'] == 'graph') {
      newObj = await mathsService.createGraph(
        workspaceId: workspaceId,
        name: result['name'] as String,
      );
    } else {
      newObj = await mathsService.createMatrix(
        workspaceId: workspaceId,
        name: result['name'] as String,
        rows: result['rows'] as int,
        cols: result['cols'] as int,
      );
    }

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MathsScreen(workspaceId: workspaceId, mathsObjectId: newObj.id),
      ),
    );
  }

  Future<void> _deleteMathsObject(
    BuildContext context,
    WidgetRef ref,
    MathsObject obj,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Maths Object'),
        content: Text(
          'Are you sure you want to delete "${obj.name}"?\n\n'
          'Any node blocks referencing this object will show as broken references.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AxiomColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final workspaceId = ref.read(activeWorkspaceIdProvider) ?? '';
    await MathsService.instance.deleteMathsObject(
      workspaceId: workspaceId,
      objectId: obj.id,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('"${obj.name}" deleted')));
    // Force rebuild by invalidating
    ref.invalidate(activeWorkspaceIdProvider);
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
        // 2-column stat cards matching Stitch design
        Row(
          children: [
            Expanded(
              child: _StitchStatCard(
                icon: Icons.lightbulb_outlined,
                iconColor: cs.primary,
                count: '0',
                label: 'Ideas Created',
                countColor: cs.primary,
              ),
            ),
            const SizedBox(width: AxiomSpacing.md),
            Expanded(
              child: _StitchStatCard(
                icon: Icons.grid_view_rounded,
                iconColor: cs.secondary,
                count: '${sessions.length}',
                label: 'Workspaces',
                countColor: cs.secondary,
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

/// Stitch-design stat card — icon + count + label with elevated container
class _StitchStatCard extends StatelessWidget {
  const _StitchStatCard({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
    required this.countColor,
  });

  final IconData icon;
  final Color iconColor;
  final String count;
  final String label;
  final Color countColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: icon + arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Transform.rotate(
                angle: -0.785398, // -45 degrees
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: cs.onSurfaceVariant.withAlpha(80),
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: AxiomSpacing.sm),
          // Bottom: count + label
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: countColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AxiomTypography.labelSmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

class _MindMapCreateChoice {
  const _MindMapCreateChoice(this.name, this.templateId);
  final String name;
  final String templateId;
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
                    color: selected ? cs.onSecondaryContainer : cs.onSurface,
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
