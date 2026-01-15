/// Primary FAB matching Stitch designs
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
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label!, style: AxiomTypography.labelLarge),
        backgroundColor: AxiomColors.primary,
        foregroundColor: AxiomColors.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AxiomColors.primary,
      foregroundColor: AxiomColors.onPrimary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
      ),
      child: Icon(icon, size: 28),
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
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AxiomColors.primary,
        foregroundColor: AxiomColors.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
        child: Icon(icon, size: 32),
      ),
    );
  }
}
