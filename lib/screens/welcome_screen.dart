import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_tokens.dart';
import '../models/node_template.dart';
import '../providers/workspace_providers.dart';
import '../providers/workspace_state_provider.dart';

/// Modern workspace creation screen matching create_workspace_entry_point design
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
      backgroundColor: AxiomColors.backgroundDark,
      body: Stack(
        children: [
          // Subtle gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    AxiomColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const Expanded(
                        child: Text(
                          'Create Workspace',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),

                        // Create from scratch card
                        _GlassCard(
                          onTap: _isLoading ? null : _handleCreateFromScratch,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AxiomColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AxiomColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Create From Scratch',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Start with a blank canvas',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Templates section header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Templates',
                              style: AxiomTypography.h3.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Template cards
                        ...NodeTemplate.templates.map(
                          (template) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TemplateCard(
                              template: template,
                              onTap: _isLoading
                                  ? null
                                  : () => _handleTemplateSelect(template),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // View existing workspaces button
                        TextButton(
                          onPressed: _isLoading ? null : _handleViewExisting,
                          child: Text(
                            'View Existing Workspaces',
                            style: TextStyle(
                              color: AxiomColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
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
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1c1f26), Color(0xFF111318)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
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
    return _GlassCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AxiomColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  template.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3),
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
      backgroundColor: AxiomColors.surfaceDark,
      title: Text(
        widget.templateName != null
            ? 'Name your ${widget.templateName} workspace'
            : 'Name your workspace',
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'My Workspace',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AxiomColors.primary),
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              widget.onNameChanged(name);
              Navigator.of(context).pop(name);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AxiomColors.primary,
            foregroundColor: Colors.black,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
