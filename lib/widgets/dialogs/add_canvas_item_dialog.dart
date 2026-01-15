import 'package:flutter/material.dart';

enum CanvasItemType {
  container,
  textBlock,
  mathBlock,
  codeBlock,
  sketchBlock,
  audioBlock,
}

/// Dialog to choose what type of item to add to the canvas
class AddCanvasItemDialog extends StatelessWidget {
  const AddCanvasItemDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                'Add to Canvas',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            // Items list
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Choose what to add:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ItemCard(
                      icon: Icons.folder_outlined,
                      title: 'Container Node',
                      description: 'Group multiple blocks together',
                      color: Colors.blue,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.container),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Or add a standalone block:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ItemCard(
                      icon: Icons.text_fields,
                      title: 'Text Block',
                      description: 'Rich text content',
                      color: Colors.green,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.textBlock),
                    ),
                    const SizedBox(height: 8),
                    _ItemCard(
                      icon: Icons.functions,
                      title: 'Math Block',
                      description: 'LaTeX equations',
                      color: Colors.purple,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.mathBlock),
                    ),
                    const SizedBox(height: 8),
                    _ItemCard(
                      icon: Icons.code,
                      title: 'Code Block',
                      description: 'Syntax highlighted code',
                      color: Colors.orange,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.codeBlock),
                    ),
                    const SizedBox(height: 8),
                    _ItemCard(
                      icon: Icons.brush,
                      title: 'Sketch Block',
                      description: 'Hand-drawn sketches',
                      color: Colors.red,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.sketchBlock),
                    ),
                    const SizedBox(height: 8),
                    _ItemCard(
                      icon: Icons.mic,
                      title: 'Audio Block',
                      description: 'Voice recordings',
                      color: Colors.teal,
                      onTap: () =>
                          Navigator.pop(context, CanvasItemType.audioBlock),
                    ),
                  ],
                ),
              ),
            ),
            // Cancel button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
