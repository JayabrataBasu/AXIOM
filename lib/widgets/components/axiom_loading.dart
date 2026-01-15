/// Loading indicator matching Stitch designs
library;

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class AxiomLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const AxiomLoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AxiomColors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AxiomSpacing.md),
            Text(
              message!,
              style: AxiomTypography.bodyMedium.copyWith(
                color: AxiomColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Progress bar for splash screen
class AxiomProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;

  const AxiomProgressBar({
    super.key,
    required this.value,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AxiomColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AxiomRadius.full),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AxiomColors.primary,
                AxiomColors.primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(AxiomRadius.full),
            boxShadow: [
              BoxShadow(
                color: AxiomColors.primary.withAlpha((0.5 * 255).round()),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
