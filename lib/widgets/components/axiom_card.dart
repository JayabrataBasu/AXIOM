/// Reusable card component — theme-aware, Everforest styled
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
    final cs = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(AxiomRadius.lg);

    final card = AnimatedContainer(
      duration: AxiomDurations.fast,
      padding: padding ?? const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerLowest,
        borderRadius: radius,
        border: Border.all(color: cs.outlineVariant.withAlpha(40), width: 0.5),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: cs.shadow.withAlpha(10),
                  blurRadius: 16,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: cs.shadow.withAlpha(5),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: cs.secondary.withAlpha(15),
          highlightColor: cs.secondary.withAlpha(8),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Glass panel — frosted glass effect
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(220),
        borderRadius: borderRadius ?? BorderRadius.circular(AxiomRadius.lg),
        border: Border.all(color: cs.outlineVariant.withAlpha(60), width: 1),
      ),
      child: child,
    );
  }
}
