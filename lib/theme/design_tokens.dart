/// Design tokens extracted from Stitch UI designs
/// These tokens define the visual language of AXIOM
///
/// Color system based on Everforest dark palette mapped to Material 3 roles.
/// Everforest is a warm, nature-inspired theme with soft contrast.
library;

import 'package:flutter/material.dart';

/// Everforest-inspired color palette mapped to Material 3 color roles.
///
/// Design principles:
/// - Warm, olive/green-tinted dark surfaces (no pure black)
/// - Muted, natural accent colors (no neon)
/// - Soft contrast for reduced eye strain
class AxiomColors {
  AxiomColors._();

  // ============================================================
  // EVERFOREST BASE PALETTE
  // ============================================================

  // Background layers (darkest to lightest)
  static const Color bg0 = Color(0xFF232A2E); // Deepest background
  static const Color bg1 = Color(0xFF2D353B); // Primary background
  static const Color bg2 = Color(0xFF343F44); // Elevated surfaces
  static const Color bg3 = Color(0xFF3D484D); // Cards, dialogs
  static const Color bg4 = Color(0xFF475258); // Hover states
  static const Color bg5 = Color(0xFF4F585E); // Active states

  // Foreground / Text
  static const Color fg = Color(0xFFD3C6AA); // Primary text (warm cream)
  static const Color grey0 = Color(0xFF7A8478); // Muted text
  static const Color grey1 = Color(0xFF859289); // Secondary text
  static const Color grey2 = Color(0xFF9DA9A0); // Tertiary text

  // Accent colors (muted, natural)
  static const Color red = Color(0xFFE67E80); // Errors, destructive
  static const Color orange = Color(0xFFE69875); // Warnings
  static const Color yellow = Color(0xFFDBBC7F); // Highlights
  static const Color green = Color(0xFFA7C080); // Success, primary accent
  static const Color aqua = Color(0xFF83C092); // Secondary accent
  static const Color blue = Color(0xFF7FBBB3); // Info, links
  static const Color purple = Color(0xFFD699B6); // Special, tertiary accent

  // ============================================================
  // MATERIAL 3 SEMANTIC ROLES (mapped from Everforest)
  // ============================================================

  // Primary (using Everforest green as main brand color)
  static const Color primary = Color(0xFFA7C080);
  static const Color onPrimary = Color(0xFF232A2E);
  static const Color primaryContainer = Color(0xFF3D5A3D);
  static const Color onPrimaryContainer = Color(0xFFD3E8C0);

  // Secondary (using Everforest aqua)
  static const Color secondary = Color(0xFF83C092);
  static const Color onSecondary = Color(0xFF232A2E);
  static const Color secondaryContainer = Color(0xFF3A5245);
  static const Color onSecondaryContainer = Color(0xFFC8E6CF);

  // Tertiary (using Everforest blue)
  static const Color tertiary = Color(0xFF7FBBB3);
  static const Color onTertiary = Color(0xFF232A2E);
  static const Color tertiaryContainer = Color(0xFF3A5250);
  static const Color onTertiaryContainer = Color(0xFFC0E0DC);

  // Surface colors
  static const Color surface = Color(0xFF2D353B);
  static const Color onSurface = Color(0xFFD3C6AA);
  static const Color surfaceVariant = Color(0xFF3D484D);
  static const Color onSurfaceVariant = Color(0xFF9DA9A0);
  static const Color surfaceContainerLowest = Color(0xFF232A2E);
  static const Color surfaceContainerLow = Color(0xFF2D353B);
  static const Color surfaceContainer = Color(0xFF343F44);
  static const Color surfaceContainerHigh = Color(0xFF3D484D);
  static const Color surfaceContainerHighest = Color(0xFF475258);

  // Outline
  static const Color outline = Color(0xFF5C6A5E);
  static const Color outlineVariant = Color(0xFF475258);

  // Error
  static const Color error = Color(0xFFE67E80);
  static const Color onError = Color(0xFF232A2E);
  static const Color errorContainer = Color(0xFF5C3A3B);
  static const Color onErrorContainer = Color(0xFFF5C8C8);

  // Inverse
  static const Color inverseSurface = Color(0xFFD3C6AA);
  static const Color inverseOnSurface = Color(0xFF2D353B);
  static const Color inversePrimary = Color(0xFF5A7052);

  // ============================================================
  // LEGACY ALIASES (for backward compatibility)
  // ============================================================

  // Primary Colors (legacy)
  static const Color primaryLight = aqua;
  static const Color primaryCanvas = blue;

  // Background Colors (legacy)
  static const Color backgroundLight = Color(0xFFF2F5F0); // Warm light bg
  static const Color backgroundDark = bg0;
  static const Color backgroundDarkAlt = bg1;

  // Surface Colors (legacy)
  static const Color surfaceDark = bg2;
  static const Color surfaceDarkAlt = bg3;
  static const Color surfaceCanvas = bg1;

  // Border Colors (legacy)
  static const Color borderDark = outlineVariant;

  // Text Colors (legacy)
  static const Color textMuted = grey1;
  static const Color textSecondary = grey0;

  // Canvas Grid
  static const Color gridDot = Color(0xFF3D484D);

  // Accent Colors (legacy)
  static const Color accentTeal = aqua;

  // Status Colors (using Everforest accents)
  static const Color success = green;
  static const Color warning = orange;
  static const Color info = blue;
}

/// Typography tokens from Stitch designs
class AxiomTypography {
  AxiomTypography._();

  // Font Families
  // NOTE: Update these to actual font names once fonts are added to assets
  // For now using system fonts that fallback gracefully
  static const String fontDisplay = 'Roboto';
  static const String fontBody = 'Roboto';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Display Text (Hero sections)
  static const TextStyle display = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 48,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 32,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.25,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: -0.25,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: 0,
  );

  // Alias styles for common use
  static const TextStyle h1 = display;
  static const TextStyle h3 = heading3;
  static const TextStyle button = labelLarge;
  static const TextStyle body1 = bodyLarge;

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 17,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 15,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 11,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // Monospace (for code and technical text)
  static const TextStyle code = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );
}

/// Spacing tokens from Stitch designs
class AxiomSpacing {
  AxiomSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius tokens from Stitch designs
class AxiomRadius {
  AxiomRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double large = 16.0; // Alias for lg
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;
}

/// Elevation (shadow) tokens from Stitch designs
class AxiomElevation {
  AxiomElevation._();

  // Material Design 3 elevation levels
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x4D000000), // 30% opacity
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 3,
    ),
    BoxShadow(
      color: Color(0x4D000000), // 30% opacity
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  // Glow effect for primary elements
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x4D1A4751), // Primary color with 30% opacity
      offset: Offset(0, 0),
      blurRadius: 20,
      spreadRadius: -5,
    ),
  ];

  // Card shadow
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x4D000000), // 30% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
}

/// Animation duration tokens
class AxiomDurations {
  AxiomDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration splash = Duration(milliseconds: 2000);
}

/// Responsive breakpoints for adaptive layouts
class AxiomBreakpoints {
  AxiomBreakpoints._();

  /// Mobile screens (phones in portrait) - max width
  static const double mobile = 600.0;

  /// Tablet screens - max width
  static const double tablet = 1200.0;

  /// Desktop screens - max width
  static const double desktop = 1800.0;

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}

/// Responsive builder widget for adaptive layouts
class AxiomResponsive extends StatelessWidget {
  const AxiomResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Widget to show on mobile (<600px)
  final Widget mobile;

  /// Widget to show on tablet (600px - 1200px), defaults to mobile
  final Widget? tablet;

  /// Widget to show on desktop (>1200px), defaults to tablet or mobile
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AxiomBreakpoints.tablet) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AxiomBreakpoints.mobile) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
