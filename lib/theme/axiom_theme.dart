/// Main theme configuration for AXIOM
/// Everforest Light (primary) + Everforest Dark with Material 3
///
/// Design philosophy:
/// - Warm parchment surfaces (no pure white or pure black)
/// - Muted, natural accent colors — olive green, emerald, sage
/// - Generous rounded corners for a friendly, inviting feel
/// - Soft shadows and clear elevation hierarchy
/// - Inter font for readability, JetBrains Mono for code
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

class AxiomTheme {
  AxiomTheme._();

  // ════════════════════════════════════════════════════════════════
  // LIGHT THEME — Everforest Light (PRIMARY)
  // ════════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AxiomColors.primary,
      onPrimary: AxiomColors.onPrimary,
      primaryContainer: AxiomColors.primaryContainer,
      onPrimaryContainer: AxiomColors.onPrimaryContainer,
      secondary: AxiomColors.secondary,
      onSecondary: AxiomColors.onSecondary,
      secondaryContainer: AxiomColors.secondaryContainer,
      onSecondaryContainer: AxiomColors.onSecondaryContainer,
      tertiary: AxiomColors.tertiary,
      onTertiary: AxiomColors.onTertiary,
      tertiaryContainer: AxiomColors.tertiaryContainer,
      onTertiaryContainer: AxiomColors.onTertiaryContainer,
      error: AxiomColors.error,
      onError: AxiomColors.onError,
      errorContainer: AxiomColors.errorContainer,
      onErrorContainer: AxiomColors.onErrorContainer,
      surface: AxiomColors.surface,
      onSurface: AxiomColors.onSurface,
      surfaceContainerLowest: AxiomColors.surfaceContainerLowest,
      surfaceContainerLow: AxiomColors.surfaceContainerLow,
      surfaceContainer: AxiomColors.surfaceContainer,
      surfaceContainerHigh: AxiomColors.surfaceContainerHigh,
      surfaceContainerHighest: AxiomColors.surfaceContainerHighest,
      onSurfaceVariant: AxiomColors.onSurfaceVariant,
      outline: AxiomColors.outline,
      outlineVariant: AxiomColors.outlineVariant,
      inverseSurface: AxiomColors.inverseSurface,
      onInverseSurface: AxiomColors.inverseOnSurface,
      inversePrimary: AxiomColors.inversePrimary,
      shadow: const Color(0x1A5C6A72),
      scrim: const Color(0x335C6A72),
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ════════════════════════════════════════════════════════════════
  // DARK THEME — Everforest Dark
  // ════════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AxiomColors.darkGreen,
      onPrimary: AxiomColors.darkBg0,
      primaryContainer: const Color(0xFF3D5A3D),
      onPrimaryContainer: const Color(0xFFD3E8C0),
      secondary: AxiomColors.darkAqua,
      onSecondary: AxiomColors.darkBg0,
      secondaryContainer: const Color(0xFF3A5245),
      onSecondaryContainer: const Color(0xFFC8E6CF),
      tertiary: AxiomColors.darkBlue,
      onTertiary: AxiomColors.darkBg0,
      tertiaryContainer: const Color(0xFF3A5250),
      onTertiaryContainer: const Color(0xFFC0E0DC),
      error: AxiomColors.darkRed,
      onError: AxiomColors.darkBg0,
      errorContainer: const Color(0xFF5C3A3B),
      onErrorContainer: const Color(0xFFF5C8C8),
      surface: AxiomColors.darkBg1,
      onSurface: AxiomColors.darkFg,
      surfaceContainerLowest: AxiomColors.darkBg0,
      surfaceContainerLow: AxiomColors.darkBg1,
      surfaceContainer: AxiomColors.darkBg2,
      surfaceContainerHigh: AxiomColors.darkBg3,
      surfaceContainerHighest: AxiomColors.darkBg4,
      onSurfaceVariant: AxiomColors.darkGrey1,
      outline: const Color(0xFF5C6A5E),
      outlineVariant: AxiomColors.darkBg4,
      inverseSurface: AxiomColors.darkFg,
      onInverseSurface: AxiomColors.darkBg1,
      inversePrimary: const Color(0xFF5A7052),
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ════════════════════════════════════════════════════════════════
  // SHARED BUILDER
  // ════════════════════════════════════════════════════════════════

  static ThemeData _buildTheme(ColorScheme cs, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      fontFamily: 'Inter',

      // Scaffold
      scaffoldBackgroundColor: cs.surface,

      // App Bar — clean, flat, with subtle scroll shadow
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: cs.primary,
        centerTitle: false,
        titleTextStyle: AxiomTypography.heading2.copyWith(
          color: cs.onSurface,
        ),
        iconTheme: IconThemeData(color: cs.onSurfaceVariant, size: 22),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: cs.surface,
                systemNavigationBarIconBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: cs.surface,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
      ),

      // Typography
      textTheme: _buildTextTheme(cs),

      // Card — rounded, elevated with warm shadow
      cardTheme: CardThemeData(
        color: cs.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.lg),
          side: BorderSide(color: cs.outlineVariant.withAlpha(120), width: 1),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: cs.shadow,
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.lg, vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
          ),
          textStyle: AxiomTypography.labelLarge,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.hovered) ? 2 : 0),
        ),
      ),

      // Filled Button — primary CTA
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.lg, vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outline, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.lg, vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.md, vertical: AxiomSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.sm),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: cs.onSurfaceVariant,
          hoverColor: cs.primary.withAlpha(20),
          highlightColor: cs.primary.withAlpha(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.sm),
          ),
        ),
      ),

      // FAB — large rounded
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xl),
        ),
        extendedIconLabelSpacing: AxiomSpacing.sm,
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.lg,
        ),
      ),

      // Dialog — large rounded corners, warm surface
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surfaceContainerLow,
        elevation: 6,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
        titleTextStyle: AxiomTypography.heading2.copyWith(
          color: cs.onSurface,
        ),
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet — drag handle, large top radius
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surfaceContainerLow,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AxiomRadius.xxl),
          ),
        ),
        dragHandleColor: cs.outlineVariant,
        dragHandleSize: const Size(36, 4),
        showDragHandle: true,
      ),

      // Input fields — filled, rounded, warm
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AxiomColors.bg2 : AxiomColors.darkBg2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(color: cs.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md, vertical: 14,
        ),
        hintStyle: AxiomTypography.bodyMedium.copyWith(
          color: cs.onSurfaceVariant.withAlpha(150),
        ),
        labelStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
        floatingLabelStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.primary,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant, thickness: 1, space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md, vertical: AxiomSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: cs.primary.withAlpha(20),
        iconColor: cs.onSurfaceVariant,
        textColor: cs.onSurface,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        selectedColor: cs.secondaryContainer,
        disabledColor: cs.surfaceContainer,
        labelStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
        secondaryLabelStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.onSecondaryContainer,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.sm, vertical: AxiomSpacing.xs,
        ),
        showCheckmark: false,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(
          color: cs.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        actionTextColor: cs.inversePrimary,
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surfaceContainer,
        indicatorColor: cs.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        height: 76,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return AxiomTypography.labelMedium.copyWith(
              color: cs.onSurface,
            );
          }
          return AxiomTypography.labelMedium.copyWith(
            color: cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.onSecondaryContainer);
          }
          return IconThemeData(color: cs.onSurfaceVariant);
        }),
      ),

      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.secondaryContainer,
        selectedIconTheme: IconThemeData(color: cs.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: cs.onSurfaceVariant),
        selectedLabelTextStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.onSurface,
        ),
        unselectedLabelTextStyle: AxiomTypography.labelMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: cs.surfaceContainerLow,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
      ),

      // Progress
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.surfaceContainerHighest,
        circularTrackColor: cs.surfaceContainerHighest,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceContainerHighest,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withAlpha(30),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return cs.onPrimary;
          return cs.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return cs.primary;
          return cs.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return Colors.transparent;
          return cs.outline;
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return cs.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(cs.onPrimary),
        side: BorderSide(color: cs.outline, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: cs.inverseSurface,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        textStyle: AxiomTypography.bodySmall.copyWith(
          color: cs.onInverseSurface,
        ),
      ),

      // PopupMenu
      popupMenuTheme: PopupMenuThemeData(
        color: cs.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        textStyle: AxiomTypography.bodyMedium.copyWith(
          color: cs.onSurface,
        ),
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicatorColor: cs.primary,
        labelColor: cs.primary,
        unselectedLabelColor: cs.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AxiomTypography.labelLarge,
        unselectedLabelStyle: AxiomTypography.labelLarge,
      ),
    );
  }

  /// Build text theme with Inter font
  static TextTheme _buildTextTheme(ColorScheme cs) {
    return TextTheme(
      displayLarge: AxiomTypography.display.copyWith(color: cs.onSurface),
      displayMedium: AxiomTypography.displayMedium.copyWith(color: cs.onSurface),
      displaySmall: AxiomTypography.displaySmall.copyWith(color: cs.onSurface),
      headlineLarge: AxiomTypography.heading1.copyWith(color: cs.onSurface),
      headlineMedium: AxiomTypography.heading2.copyWith(color: cs.onSurface),
      headlineSmall: AxiomTypography.heading3.copyWith(color: cs.onSurface),
      titleLarge: AxiomTypography.heading2.copyWith(color: cs.onSurface),
      titleMedium: AxiomTypography.heading3.copyWith(color: cs.onSurface),
      titleSmall: AxiomTypography.labelLarge.copyWith(color: cs.onSurface),
      bodyLarge: AxiomTypography.bodyLarge.copyWith(color: cs.onSurface),
      bodyMedium: AxiomTypography.bodyMedium.copyWith(color: cs.onSurface),
      bodySmall: AxiomTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
      labelLarge: AxiomTypography.labelLarge.copyWith(color: cs.onSurface),
      labelMedium: AxiomTypography.labelMedium.copyWith(color: cs.onSurfaceVariant),
      labelSmall: AxiomTypography.labelSmall.copyWith(color: cs.onSurfaceVariant),
    );
  }
}
