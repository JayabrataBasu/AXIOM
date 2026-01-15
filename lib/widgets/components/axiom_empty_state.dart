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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AxiomSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with gradient background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AxiomColors.primary.withAlpha((0.2 * 255).round()),
                    AxiomColors.primaryLight.withAlpha((0.1 * 255).round()),
                  ],
                ),
                borderRadius: BorderRadius.circular(AxiomRadius.xl),
                border: Border.all(color: AxiomColors.borderDark, width: 1),
              ),
              child: Icon(icon, size: 40, color: AxiomColors.textMuted),
            ),
            const SizedBox(height: AxiomSpacing.lg),

            // Title
            Text(
              title,
              style: AxiomTypography.heading2.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AxiomSpacing.sm),

            // Message
            Text(
              message,
              style: AxiomTypography.bodyMedium.copyWith(
                color: AxiomColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AxiomSpacing.xl),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
