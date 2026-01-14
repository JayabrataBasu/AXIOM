import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/spacing.dart';
import '../models/node_template.dart';
import '../providers/workspace_providers.dart';
import '../providers/workspace_state_provider.dart';

/// Welcome screen shown on app first launch
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _nameController = TextEditingController();
  NodeTemplate? _selectedTemplate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateWorkspace() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workspace name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create workspace session first
      final workspaceId = await ref
          .read(workspaceSessionsNotifierProvider.notifier)
          .createSession(
            label: name,
            workspaceType: 'canvas',
            template: _selectedTemplate,
          );

      // Set as active workspace
      await ref
          .read(activeWorkspaceIdProvider.notifier)
          .setActiveWorkspace(workspaceId.id);

      if (mounted) {
        // Navigation will be handled by app shell listening to activeWorkspaceId
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDefer() async {
    // Create a default workspace but don't set as active yet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You can create a workspace later')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? Spacing.m : Spacing.xl,
              vertical: Spacing.l,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branding
                Center(
                  child: Column(
                    children: [
                      // Logo/Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '💭',
                            style: theme.textTheme.displayLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.m),
                      // App Title
                      Text(
                        'Axiom',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.s),
                      // Tagline
                      Text(
                        'Organize your thoughts. Calculate everything.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // Description
                Container(
                  padding: const EdgeInsets.all(Spacing.m),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Getting Started',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Spacing.s),
                      Text(
                        'Create your first workspace to start capturing ideas and performing calculations. You can create multiple workspaces and switch between them anytime.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // Workspace Name Input
                TextField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Workspace Name',
                    hintText: 'My First Workspace',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.workspaces),
                  ),
                ),
                const SizedBox(height: Spacing.l),

                // Template Selection
                Text(
                  'Choose a Starting Template (Optional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.m),

                // Template Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmallScreen ? 2 : 3,
                    crossAxisSpacing: Spacing.m,
                    mainAxisSpacing: Spacing.m,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: NodeTemplate.templates.length,
                  itemBuilder: (context, index) {
                    final template = NodeTemplate.templates[index];
                    final isSelected = _selectedTemplate == template;

                    return GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedTemplate =
                                    isSelected ? null : template;
                              });
                            },
                      child: Card(
                        elevation: isSelected ? 4 : 1,
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(Spacing.s),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                template.icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                template.name,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.xl),

                // Action Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.add),
                      label: Text(
                        _isLoading
                            ? 'Creating Workspace...'
                            : 'Create Workspace',
                      ),
                      onPressed: _isLoading ? null : _handleCreateWorkspace,
                    ),
                    const SizedBox(height: Spacing.m),
                    OutlinedButton(
                      onPressed: _isLoading ? null : _handleDefer,
                      child: const Text('Skip for Now'),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),

                // Footer hint
                Center(
                  child: Text(
                    'Workspaces are saved locally on your device',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
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
