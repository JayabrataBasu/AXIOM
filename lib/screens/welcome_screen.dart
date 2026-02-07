import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_tokens.dart';
import '../models/node_template.dart';
import '../providers/workspace_providers.dart';
import '../providers/workspace_state_provider.dart';

/// Modern workspace creation screen matching create_workspace_entry_point design
/// Updated for Everforest dark theme with Material 3 Expressive styling.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateFromScratch() async {
    // Show dialog to get workspace name
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _CreateWorkspaceDialog(
        onNameChanged: (value) => _nameController.text = value,
      ),
    );

    if (name == null || name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final workspaceId = await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .createSession(label: name, workspaceType: 'canvas', template: null);

      await ref
          .read(activeWorkspaceIdProvider.notifier)
          .setActiveWorkspace(workspaceId.id);

      if (mounted) {
        context.go('/workspace/${workspaceId.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleTemplateSelect(NodeTemplate template) async {
    // Show dialog to get workspace name
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _CreateWorkspaceDialog(
        templateName: template.name,
        onNameChanged: (value) => _nameController.text = value,
      ),
    );

    if (name == null || name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final workspaceId = await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .createSession(
            label: name,
            workspaceType: 'canvas',
            template: template,
          );

      await ref
          .read(activeWorkspaceIdProvider.notifier)
          .setActiveWorkspace(workspaceId.id);

      if (mounted) {
        context.go('/workspace/${workspaceId.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleViewExisting() async {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // Warm gradient background - Stitch-style organic glow
          Positioned(
            top: -120,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cs.secondary.withAlpha(18),
                    cs.secondary.withAlpha(5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [cs.primary.withAlpha(12), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Stitch-style floating top bar
                Padding(
                  padding: const EdgeInsets.all(AxiomSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh.withAlpha(120),
                          borderRadius: BorderRadius.circular(AxiomRadius.full),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: cs.onSurface,
                            size: 20,
                          ),
                          onPressed: () => context.go('/dashboard'),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Create Workspace',
                          textAlign: TextAlign.center,
                          style: AxiomTypography.labelLarge.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 36), // Balance the back button
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AxiomSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AxiomSpacing.lg),

                        // Create from scratch card - Stitch-style prominent action
                        _GlassCard(
                          onTap: _isLoading ? null : _handleCreateFromScratch,
                          isHighlighted: true,
                          child: Padding(
                            padding: const EdgeInsets.all(AxiomSpacing.xl),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        cs.secondary,
                                        cs.secondary.withAlpha(200),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AxiomRadius.md,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cs.secondary.withAlpha(40),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: AxiomSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Create From Scratch',
                                        style: TextStyle(
                                          color: cs.onSurface,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Start with a blank canvas',
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: cs.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AxiomSpacing.xl),

                        // Templates section header
                        Text(
                          'Templates',
                          style: AxiomTypography.heading3.copyWith(
                            color: cs.onSurface,
                          ),
                        ),

                        const SizedBox(height: AxiomSpacing.md),

                        // Template cards
                        ...NodeTemplate.templates.map(
                          (template) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AxiomSpacing.sm,
                            ),
                            child: _TemplateCard(
                              template: template,
                              onTap: _isLoading
                                  ? null
                                  : () => _handleTemplateSelect(template),
                            ),
                          ),
                        ),

                        const SizedBox(height: AxiomSpacing.xl),

                        // View existing workspaces button - Stitch outline style
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _handleViewExisting,
                          icon: Icon(
                            Icons.folder_open_rounded,
                            color: cs.secondary,
                            size: 18,
                          ),
                          label: Text(
                            'View Existing Workspaces',
                            style: TextStyle(
                              color: cs.secondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AxiomRadius.full,
                              ),
                            ),
                            side: BorderSide(color: cs.secondary.withAlpha(80)),
                          ),
                        ),

                        const SizedBox(height: AxiomSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: cs.surface.withAlpha(200),
              child: Center(
                child: CircularProgressIndicator(color: cs.primary),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stitch-inspired glass card with warm surface and soft shadow
class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.onTap,
    this.isHighlighted = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        splashColor: cs.secondary.withAlpha(15),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AxiomRadius.lg),
            border: Border.all(
              color: isHighlighted
                  ? cs.secondary.withAlpha(40)
                  : cs.outlineVariant.withAlpha(40),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHighlighted
                    ? cs.secondary.withAlpha(12)
                    : cs.shadow.withAlpha(8),
                blurRadius: isHighlighted ? 20 : 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, this.onTap});

  final NodeTemplate template;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _GlassCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AxiomSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(AxiomRadius.md),
              ),
              child: Center(
                child: Text(
                  template.icon,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: AxiomSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: AxiomTypography.bodyLarge.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    template.description,
                    style: AxiomTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant.withAlpha(120),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateWorkspaceDialog extends StatefulWidget {
  const _CreateWorkspaceDialog({
    required this.onNameChanged,
    this.templateName,
  });

  final ValueChanged<String> onNameChanged;
  final String? templateName;

  @override
  State<_CreateWorkspaceDialog> createState() => _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends State<_CreateWorkspaceDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
      ),
      title: Text(
        widget.templateName != null
            ? 'Name your ${widget.templateName} workspace'
            : 'Name your workspace',
        style: TextStyle(color: cs.onSurface),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'My Workspace',
          hintStyle: TextStyle(color: cs.onSurfaceVariant),
          filled: true,
          fillColor: cs.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            widget.onNameChanged(value.trim());
            Navigator.of(context).pop(value.trim());
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: cs.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              widget.onNameChanged(name);
              Navigator.of(context).pop(name);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.surface,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
