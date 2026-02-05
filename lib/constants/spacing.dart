/// Design system spacing constants for consistent UI layout.
///
/// DEPRECATED: Use AxiomSpacing from 'package:axiom/theme/design_tokens.dart' instead.
/// This file is kept for backward compatibility and re-exports AxiomSpacing values.
library spacing;

// Re-export AxiomSpacing for backward compatibility
export 'package:axiom/theme/design_tokens.dart' show AxiomSpacing;

/// Legacy spacing class - DEPRECATED
/// Use AxiomSpacing instead for consistent spacing across the app.
@Deprecated('Use AxiomSpacing from theme/design_tokens.dart instead')
class Spacing {
  Spacing._();

  /// Extra small spacing - 4px (use AxiomSpacing.xs)
  static const double xs = 4.0;

  /// Small spacing - 8px (use AxiomSpacing.sm)
  static const double s = 8.0;

  /// Medium spacing - 12px (between AxiomSpacing.sm and md)
  static const double m = 12.0;

  /// Large spacing - 16px (use AxiomSpacing.md)
  static const double l = 16.0;

  /// Extra large spacing - 24px (use AxiomSpacing.lg)
  static const double xl = 24.0;

  /// Extra extra large spacing - 32px (use AxiomSpacing.xl)
  static const double xxl = 32.0;
}

/// Responsive breakpoints for adaptive layouts.
class Breakpoints {
  Breakpoints._();

  /// Mobile screens (portrait phones)
  static const double mobile = 600.0;

  /// Tablet screens
  static const double tablet = 1200.0;

  /// Desktop screens
  static const double desktop = 1800.0;
}

/// Maximum content widths for readable layouts.
class MaxWidths {
  MaxWidths._();

  /// Node editor max width for comfortable reading
  static const double nodeEditor = 800.0;

  /// Dialog max width
  static const double dialog = 600.0;

  /// Search results panel
  static const double searchPanel = 400.0;
}
