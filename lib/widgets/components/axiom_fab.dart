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
    // Let the theme handle colors via FloatingActionButtonThemeData
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(label!, style: AxiomTypography.labelLarge),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon, size: 26),
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
