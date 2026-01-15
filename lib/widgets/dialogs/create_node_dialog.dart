import 'package:flutter/material.dart';
import '../../constants/spacing.dart';
import '../../models/node_template.dart';

/// Dialog for creating a new node with a name and template.
class CreateNodeDialog extends StatefulWidget {
  const CreateNodeDialog({super.key});

  @override
  State<CreateNodeDialog> createState() => _CreateNodeDialogState();
}

class _CreateNodeDialogState extends State<CreateNodeDialog> {
  final _nameController = TextEditingController();
  NodeTemplate? _selectedTemplate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    Navigator.of(
      context,
    ).pop({'name': _nameController.text.trim(), 'template': _selectedTemplate});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: MaxWidths.dialog),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text('Create New Node', style: theme.textTheme.headlineSmall),
              const SizedBox(height: Spacing.l),

              // Name field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Node Name',
                  hintText: 'Enter a name for this node',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                onSubmitted: (_) => _handleCreate(),
              ),
              const SizedBox(height: Spacing.l),

              // Template selector
              Text('Choose Template', style: theme.textTheme.titleMedium),
              const SizedBox(height: Spacing.m),

              // Template grid
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: Spacing.m,
                            mainAxisSpacing: Spacing.m,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: NodeTemplate.templates.length,
                      itemBuilder: (context, index) {
                        final template = NodeTemplate.templates[index];
                        final isSelected = _selectedTemplate == template;

                        return Card(
                          elevation: isSelected ? 4 : 1,
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surface,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTemplate = template;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    template.icon,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 2),
                                  Flexible(
                                    child: Text(
                                      template.name,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: isSelected
                                                ? colorScheme.onPrimaryContainer
                                                : colorScheme.onSurface,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.l),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: Spacing.m),
                  FilledButton(
                    onPressed: _handleCreate,
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
