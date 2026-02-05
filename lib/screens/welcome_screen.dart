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
    return Scaffold(
      backgroundColor: AxiomColors.bg0,
      body: Stack(
        children: [
          // Subtle gradient background - warm Everforest glow
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    AxiomColors.green.withAlpha(20),
                    AxiomColors.aqua.withAlpha(8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar - M3 style
                Padding(
                  padding: const EdgeInsets.all(AxiomSpacing.md),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AxiomColors.grey1,
                        ),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Expanded(
                        child: Text(
                          'Create Workspace',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AxiomColors.fg,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
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

                        // Create from scratch card - prominent action
                        _GlassCard(
                          onTap: _isLoading ? null : _handleCreateFromScratch,
                          isHighlighted: true,
                          child: Padding(
                            padding: const EdgeInsets.all(AxiomSpacing.lg),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AxiomColors.green.withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                      AxiomRadius.md,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: AxiomColors.green,
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
                                          color: AxiomColors.fg,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Start with a blank canvas',
                                        style: TextStyle(
                                          color: AxiomColors.grey1,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AxiomColors.grey0,
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
                            color: AxiomColors.fg,
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

                        // View existing workspaces button
                        TextButton(
                          onPressed: _isLoading ? null : _handleViewExisting,
                          child: Text(
                            'View Existing Workspaces',
                            style: TextStyle(
                              color: AxiomColors.aqua,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
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
              color: AxiomColors.bg0.withAlpha(200),
              child: Center(
                child: CircularProgressIndicator(color: AxiomColors.green),
              ),
            ),
        ],
      ),
    );
  }
}

/// Glass-morphism style card for Everforest theme
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            color: AxiomColors.bg2,
            borderRadius: BorderRadius.circular(AxiomRadius.lg),
            border: Border.all(
              color: isHighlighted
                  ? AxiomColors.green.withAlpha(40)
                  : AxiomColors.outlineVariant,
              width: 1,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AxiomColors.green.withAlpha(15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
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
                color: AxiomColors.bg3,
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
                    style: TextStyle(
                      color: AxiomColors.fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    template.description,
                    style: TextStyle(color: AxiomColors.grey1, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AxiomColors.grey0,
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
    return AlertDialog(
      backgroundColor: AxiomColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
      ),
      title: Text(
        widget.templateName != null
            ? 'Name your ${widget.templateName} workspace'
            : 'Name your workspace',
        style: TextStyle(color: AxiomColors.fg),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(color: AxiomColors.fg),
        decoration: InputDecoration(
          hintText: 'My Workspace',
          hintStyle: TextStyle(color: AxiomColors.grey0),
          filled: true,
          fillColor: AxiomColors.surfaceContainerHighest,
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
            borderSide: BorderSide(color: AxiomColors.primary, width: 2),
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
          child: Text('Cancel', style: TextStyle(color: AxiomColors.grey1)),
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
            backgroundColor: AxiomColors.green,
            foregroundColor: AxiomColors.bg0,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
