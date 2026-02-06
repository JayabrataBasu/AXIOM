/// Design tokens for AXIOM — Everforest Light + Material 3
///
/// A warm, nature-inspired design system with soft contrast,
/// rounded shapes, and generous spacing for a premium, inviting feel.
///
/// Typography: Inter (UI) + JetBrains Mono (code)
/// Colors: Everforest light palette mapped to M3 roles
library;

import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════
// COLORS
// ════════════════════════════════════════════════════════════════════

/// Everforest Light color palette — warm, nature-inspired.
class AxiomColors {
  AxiomColors._();

  // ── EVERFOREST LIGHT BASE ──
  static const Color bg0 = Color(0xFFFDF6E3); // Warm parchment — screen bg
  static const Color bg1 = Color(0xFFF4F0D9); // Slightly deeper — cards
  static const Color bg2 = Color(0xFFEFEBD4); // Elevated surfaces
  static const Color bg3 = Color(0xFFE6E2CC); // Input fields, hover
  static const Color bg4 = Color(0xFFDDD8C0); // Active states, pressed
  static const Color bg5 = Color(0xFFD3CEB4); // Strong emphasis bg

  // Foreground / Text
  static const Color fg = Color(0xFF5C6A72);   // Primary text
  static const Color grey0 = Color(0xFF829181); // Secondary text
  static const Color grey1 = Color(0xFF999F93); // Tertiary / muted
  static const Color grey2 = Color(0xFFB0B6AA); // Placeholder / disabled

  // Accent colors
  static const Color red = Color(0xFFE66868);
  static const Color orange = Color(0xFFE69C50);
  static const Color yellow = Color(0xFFDDA93F);
  static const Color green = Color(0xFF8DA101);
  static const Color aqua = Color(0xFF35A77C);
  static const Color blue = Color(0xFF3A94C5);
  static const Color purple = Color(0xFFDF69BA);

  // ── MATERIAL 3 SEMANTIC ROLES ──
  static const Color primary = Color(0xFF708238);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE8F0C8);
  static const Color onPrimaryContainer = Color(0xFF3B4A14);

  static const Color secondary = Color(0xFF35A77C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCCEEDF);
  static const Color onSecondaryContainer = Color(0xFF1A5A40);

  static const Color tertiary = Color(0xFF3A94C5);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFCCE5F5);
  static const Color onTertiaryContainer = Color(0xFF1A4A65);

  static const Color surface = Color(0xFFFDF6E3);
  static const Color onSurface = Color(0xFF5C6A72);
  static const Color surfaceVariant = Color(0xFFEFEBD4);
  static const Color onSurfaceVariant = Color(0xFF829181);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFAF4DE);
  static const Color surfaceContainer = Color(0xFFF4F0D9);
  static const Color surfaceContainerHigh = Color(0xFFEFEBD4);
  static const Color surfaceContainerHighest = Color(0xFFE6E2CC);

  static const Color outline = Color(0xFFBFC5B3);
  static const Color outlineVariant = Color(0xFFD8D5C4);

  static const Color error = Color(0xFFE66868);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFCE4E4);
  static const Color onErrorContainer = Color(0xFF8B2020);

  static const Color inverseSurface = Color(0xFF3D484D);
  static const Color inverseOnSurface = Color(0xFFF4F0D9);
  static const Color inversePrimary = Color(0xFFA7C080);

  // ── DARK THEME (Everforest Dark) ──
  static const Color darkBg0 = Color(0xFF272E33);
  static const Color darkBg1 = Color(0xFF2E383C);
  static const Color darkBg2 = Color(0xFF374145);
  static const Color darkBg3 = Color(0xFF414B50);
  static const Color darkBg4 = Color(0xFF495156);
  static const Color darkFg = Color(0xFFD3C6AA);
  static const Color darkGrey0 = Color(0xFF7A8478);
  static const Color darkGrey1 = Color(0xFF859289);
  static const Color darkGreen = Color(0xFFA7C080);
  static const Color darkAqua = Color(0xFF83C092);
  static const Color darkBlue = Color(0xFF7FBBB3);
  static const Color darkRed = Color(0xFFE67E80);
  static const Color darkOrange = Color(0xFFE69875);
  static const Color darkYellow = Color(0xFFDBBC7F);
  static const Color darkPurple = Color(0xFFD699B6);

  // ── ALIASES ──
  static const Color success = green;
  static const Color warning = orange;
  static const Color info = blue;
  static const Color gridDot = Color(0xFFD8D5C4);
  static const Color surfaceDark = bg2;
  static const Color borderDark = outlineVariant;
  static const Color textMuted = grey1;
  static const Color textSecondary = grey0;
  static const Color accentTeal = aqua;
  static const Color primaryLight = aqua;
  static const Color primaryCanvas = blue;
  static const Color backgroundLight = bg0;
  static const Color backgroundDark = darkBg0;
  static const Color backgroundDarkAlt = darkBg1;
  static const Color surfaceDarkAlt = darkBg3;
  static const Color surfaceCanvas = bg1;
}

// ════════════════════════════════════════════════════════════════════
// TYPOGRAPHY
// ════════════════════════════════════════════════════════════════════

class AxiomTypography {
  AxiomTypography._();

  static const String fontDisplay = 'Inter';
  static const String fontBody = 'Inter';
  static const String fontCode = 'JetBrains Mono';

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Display
  static const TextStyle display = TextStyle(
    fontFamily: fontDisplay, fontSize: 44, fontWeight: bold,
    height: 1.12, letterSpacing: -0.5,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay, fontSize: 32, fontWeight: bold,
    height: 1.15, letterSpacing: -0.25,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontDisplay, fontSize: 26, fontWeight: semiBold,
    height: 1.2, letterSpacing: -0.15,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontDisplay, fontSize: 22, fontWeight: semiBold,
    height: 1.3, letterSpacing: -0.2,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontDisplay, fontSize: 18, fontWeight: semiBold,
    height: 1.35, letterSpacing: -0.1,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontDisplay, fontSize: 16, fontWeight: semiBold,
    height: 1.4, letterSpacing: 0,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody, fontSize: 16, fontWeight: regular,
    height: 1.55, letterSpacing: 0.1,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody, fontSize: 14, fontWeight: regular,
    height: 1.5, letterSpacing: 0.15,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontBody, fontSize: 12, fontWeight: regular,
    height: 1.5, letterSpacing: 0.2,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontBody, fontSize: 14, fontWeight: medium,
    height: 1.4, letterSpacing: 0.1,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontBody, fontSize: 12, fontWeight: medium,
    height: 1.4, letterSpacing: 0.3,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontBody, fontSize: 11, fontWeight: medium,
    height: 1.4, letterSpacing: 0.3,
  );

  // Code
  static const TextStyle code = TextStyle(
    fontFamily: fontCode, fontSize: 13, fontWeight: regular,
    height: 1.6, letterSpacing: 0,
  );

  // Aliases
  static const TextStyle h1 = display;
  static const TextStyle h3 = heading3;
  static const TextStyle button = labelLarge;
  static const TextStyle body1 = bodyLarge;
}

// ════════════════════════════════════════════════════════════════════
// SPACING
// ════════════════════════════════════════════════════════════════════

class AxiomSpacing {
  AxiomSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// ════════════════════════════════════════════════════════════════════
// BORDER RADIUS — rounded and friendly
// ════════════════════════════════════════════════════════════════════

class AxiomRadius {
  AxiomRadius._();

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double large = 18.0;
  static const double xl = 24.0;
  static const double xxl = 30.0;
  static const double full = 9999.0;
}

// ════════════════════════════════════════════════════════════════════
// ELEVATION — soft warm shadows
// ════════════════════════════════════════════════════════════════════

class AxiomElevation {
  AxiomElevation._();

  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x0F5C6A72), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0A5C6A72), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x145C6A72), offset: Offset(0, 2), blurRadius: 6),
    BoxShadow(color: Color(0x0A5C6A72), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const List<BoxShadow> level3 = [
    BoxShadow(color: Color(0x1A5C6A72), offset: Offset(0, 4), blurRadius: 12),
    BoxShadow(color: Color(0x0A5C6A72), offset: Offset(0, 2), blurRadius: 4),
  ];
  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x30708238), blurRadius: 16, spreadRadius: -2),
  ];
  static const List<BoxShadow> card = level1;
}

// ════════════════════════════════════════════════════════════════════
// ANIMATION
// ════════════════════════════════════════════════════════════════════

class AxiomDurations {
  AxiomDurations._();

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration splash = Duration(milliseconds: 2000);
}

class AxiomCurves {
  AxiomCurves._();
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}

// ════════════════════════════════════════════════════════════════════
// RESPONSIVE BREAKPOINTS
// ════════════════════════════════════════════════════════════════════

class AxiomBreakpoints {
  AxiomBreakpoints._();

  static const double mobile = 600.0;
  static const double tablet = 1200.0;
  static const double desktop = 1800.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static EdgeInsets screenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.xxl, vertical: AxiomSpacing.lg);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.lg, vertical: AxiomSpacing.md);
    }
    return const EdgeInsets.all(AxiomSpacing.md);
  }
}

class AxiomResponsive extends StatelessWidget {
  const AxiomResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
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
