/// FAB variants — uses theme, no hardcoded colors
library;

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class AxiomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final bool extended;

  const AxiomFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.extended = false,
  });

  const AxiomFAB.extended({
    super.key,
    required this.onPressed,
    required this.icon,
    required String this.label,
  }) : extended = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (extended && label != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AxiomRadius.full),
          boxShadow: [
            BoxShadow(
              color: cs.secondary.withAlpha(50),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: cs.secondary,
          foregroundColor: Colors.white,
          icon: Icon(icon, size: 22),
          label: Text(
            label!,
            style: AxiomTypography.labelLarge.copyWith(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.full),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AxiomRadius.full),
        boxShadow: [
          BoxShadow(
            color: cs.secondary.withAlpha(60),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: cs.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.full),
        ),
        child: Icon(icon, size: 26),
      ),
    );
  }
}

/// Large FAB for primary actions (64x64)
class AxiomLargeFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const AxiomLargeFAB({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: FloatingActionButton.large(
        onPressed: onPressed,
        child: Icon(icon, size: 30),
      ),
    );
  }
}
