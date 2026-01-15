/// Design tokens extracted from Stitch UI designs
/// These tokens define the visual language of AXIOM
library;

import 'package:flutter/material.dart';

/// Color palette from Stitch designs
class AxiomColors {
  AxiomColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1A4751);
  static const Color primaryLight = Color(0xFF2A6A78);
  static const Color primaryCanvas = Color(0xFF247D8F);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF2F5F7);
  static const Color backgroundDark = Color(0xFF0D162B);
  static const Color backgroundDarkAlt = Color(0xFF181A1B);

  // Surface Colors
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceDarkAlt = Color(0xFF1D2425);
  static const Color surfaceVariant = Color(0xFF252D30);
  static const Color surfaceCanvas = Color(0xFF24272C);

  // Border Colors
  static const Color borderDark = Color(0xFF334155);
  static const Color outline = Color(0xFF3F494A);

  // Text Colors
  static const Color textMuted = Color(0xFFA2B0B3);
  static const Color textSecondary = Color(0xFF55696D);

  // Canvas Grid
  static const Color gridDot = Color(0xFF2D3839);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
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
