/// Empty state widget matching Stitch designs
library;

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class AxiomEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AxiomEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AxiomSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with soft themed background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(AxiomRadius.full),
              ),
              child: Icon(icon, size: 40, color: cs.secondary),
            ),
            const SizedBox(height: AxiomSpacing.xl),

            // Title
            Text(
              title,
              style: AxiomTypography.heading2.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AxiomSpacing.sm),

            // Message
            Text(
              message,
              style: AxiomTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),

            // Optional action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AxiomSpacing.xl),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: cs.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AxiomRadius.full),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
