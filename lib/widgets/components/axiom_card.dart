/// Reusable card component matching Stitch designs
library;

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class AxiomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AxiomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AxiomColors.surfaceDark,
        borderRadius: borderRadius ?? BorderRadius.circular(AxiomRadius.lg),
        border: Border.all(
          color: AxiomColors.borderDark,
          width: 1,
        ),
        boxShadow: elevated ? AxiomElevation.card : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AxiomRadius.lg),
        child: card,
      );
    }

    return card;
  }
}

/// Glass panel effect from Stitch designs
class AxiomGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AxiomGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: AxiomColors.primary.withAlpha((0.1 * 255).round()),
        borderRadius: borderRadius ?? BorderRadius.circular(AxiomRadius.lg),
        border: Border.all(
          color: Colors.white.withAlpha((0.05 * 255).round()),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
