/// Main theme configuration for AXIOM
/// Applies Material Design 3 with Everforest dark color palette
///
/// Design philosophy:
/// - Warm, olive-tinted surfaces (no pure black)
/// - Muted, natural accent colors
/// - Soft contrast for comfort
/// - M3 Expressive shapes and emphasis
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

class AxiomTheme {
  AxiomTheme._();

  /// Dark theme (primary theme for AXIOM) - Everforest inspired
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      // Primary
      primary: AxiomColors.primary,
      onPrimary: AxiomColors.onPrimary,
      primaryContainer: AxiomColors.primaryContainer,
      onPrimaryContainer: AxiomColors.onPrimaryContainer,
      // Secondary
      secondary: AxiomColors.secondary,
      onSecondary: AxiomColors.onSecondary,
      secondaryContainer: AxiomColors.secondaryContainer,
      onSecondaryContainer: AxiomColors.onSecondaryContainer,
      // Tertiary
      tertiary: AxiomColors.tertiary,
      onTertiary: AxiomColors.onTertiary,
      tertiaryContainer: AxiomColors.tertiaryContainer,
      onTertiaryContainer: AxiomColors.onTertiaryContainer,
      // Error
      error: AxiomColors.error,
      onError: AxiomColors.onError,
      errorContainer: AxiomColors.errorContainer,
      onErrorContainer: AxiomColors.onErrorContainer,
      // Surface
      surface: AxiomColors.surface,
      onSurface: AxiomColors.onSurface,
      surfaceContainerLowest: AxiomColors.surfaceContainerLowest,
      surfaceContainerLow: AxiomColors.surfaceContainerLow,
      surfaceContainer: AxiomColors.surfaceContainer,
      surfaceContainerHigh: AxiomColors.surfaceContainerHigh,
      surfaceContainerHighest: AxiomColors.surfaceContainerHighest,
      onSurfaceVariant: AxiomColors.onSurfaceVariant,
      // Outline
      outline: AxiomColors.outline,
      outlineVariant: AxiomColors.outlineVariant,
      // Inverse
      inverseSurface: AxiomColors.inverseSurface,
      onInverseSurface: AxiomColors.inverseOnSurface,
      inversePrimary: AxiomColors.inversePrimary,
      // Shadow & Scrim
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      // Scaffold
      scaffoldBackgroundColor: AxiomColors.bg0,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AxiomColors.bg0,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: AxiomColors.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF232A2E),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        centerTitle: false,
        titleTextStyle: AxiomTypography.heading2.copyWith(
          color: AxiomColors.fg,
        ),
        iconTheme: IconThemeData(color: AxiomColors.fg, size: 24),
      ),

      // Typography
      textTheme: _buildTextTheme(colorScheme),

      // Card - M3 Expressive with soft shape
      cardTheme: CardThemeData(
        color: AxiomColors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.lg),
          side: BorderSide(color: AxiomColors.outlineVariant, width: 1),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withAlpha(40),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button - M3 tonal style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AxiomColors.primaryContainer,
              foregroundColor: AxiomColors.onPrimaryContainer,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: AxiomSpacing.lg,
                vertical: AxiomSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AxiomRadius.lg),
              ),
              textStyle: AxiomTypography.labelLarge,
            ).copyWith(
              elevation: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) return 1;
                if (states.contains(WidgetState.pressed)) return 0;
                return 0;
              }),
            ),
      ),

      // Filled Button - Primary emphasis
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AxiomColors.primary,
          foregroundColor: AxiomColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.lg,
            vertical: AxiomSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.lg),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Outlined Button - Subtle emphasis
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AxiomColors.primary,
          side: BorderSide(color: AxiomColors.outline, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.lg,
            vertical: AxiomSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.lg),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Text Button - Minimal emphasis
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AxiomColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AxiomSpacing.md,
            vertical: AxiomSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
          ),
          textStyle: AxiomTypography.labelLarge,
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AxiomColors.onSurfaceVariant,
          hoverColor: AxiomColors.primary.withAlpha(20),
          highlightColor: AxiomColors.primary.withAlpha(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.md),
          ),
        ),
      ),

      // Floating Action Button - M3 large rounded
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AxiomColors.primaryContainer,
        foregroundColor: AxiomColors.onPrimaryContainer,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 3,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xl),
        ),
        extendedIconLabelSpacing: AxiomSpacing.sm,
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.lg,
        ),
      ),

      // Dialog - M3 with large corners
      dialogTheme: DialogThemeData(
        backgroundColor: AxiomColors.surfaceContainerHigh,
        elevation: 3,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
        titleTextStyle: AxiomTypography.heading2.copyWith(
          color: AxiomColors.onSurface,
        ),
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(
          color: AxiomColors.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet - M3 with drag handle area
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AxiomColors.surfaceContainerLow,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AxiomRadius.xxl),
          ),
        ),
        dragHandleColor: AxiomColors.outlineVariant,
        dragHandleSize: const Size(32, 4),
        showDragHandle: true,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AxiomColors.surfaceContainerHighest,
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
          borderSide: BorderSide(color: AxiomColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(color: AxiomColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(color: AxiomColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.md,
        ),
        hintStyle: AxiomTypography.bodyMedium.copyWith(
          color: AxiomColors.grey0,
        ),
        labelStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.grey1,
        ),
        floatingLabelStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.primary,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AxiomColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AxiomColors.primary.withAlpha(25),
        iconColor: AxiomColors.onSurfaceVariant,
        textColor: AxiomColors.onSurface,
      ),

      // Chip - M3 style
      chipTheme: ChipThemeData(
        backgroundColor: AxiomColors.surfaceContainerHigh,
        selectedColor: AxiomColors.secondaryContainer,
        disabledColor: AxiomColors.surfaceContainer,
        labelStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.onSurfaceVariant,
        ),
        secondaryLabelStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.onSecondaryContainer,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.sm,
          vertical: AxiomSpacing.xs,
        ),
        showCheckmark: false,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AxiomColors.inverseSurface,
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(
          color: AxiomColors.inverseOnSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 3,
        actionTextColor: AxiomColors.inversePrimary,
      ),

      // Navigation Bar (Bottom)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AxiomColors.surfaceContainer,
        indicatorColor: AxiomColors.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AxiomTypography.labelMedium.copyWith(
              color: AxiomColors.onSurface,
            );
          }
          return AxiomTypography.labelMedium.copyWith(
            color: AxiomColors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AxiomColors.onSecondaryContainer);
          }
          return IconThemeData(color: AxiomColors.onSurfaceVariant);
        }),
      ),

      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AxiomColors.surface,
        indicatorColor: AxiomColors.secondaryContainer,
        selectedIconTheme: IconThemeData(
          color: AxiomColors.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: AxiomColors.onSurfaceVariant),
        selectedLabelTextStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.onSurface,
        ),
        unselectedLabelTextStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.onSurfaceVariant,
        ),
      ),

      // Navigation Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AxiomColors.surfaceContainerLow,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
        ),
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AxiomColors.primary,
        linearTrackColor: AxiomColors.surfaceContainerHighest,
        circularTrackColor: AxiomColors.surfaceContainerHighest,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AxiomColors.primary,
        inactiveTrackColor: AxiomColors.surfaceContainerHighest,
        thumbColor: AxiomColors.primary,
        overlayColor: AxiomColors.primary.withAlpha(30),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AxiomColors.onPrimary;
          }
          return AxiomColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AxiomColors.primary;
          }
          return AxiomColors.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return AxiomColors.outline;
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AxiomColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AxiomColors.onPrimary),
        side: BorderSide(color: AxiomColors.outline, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AxiomColors.inverseSurface,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        textStyle: AxiomTypography.bodySmall.copyWith(
          color: AxiomColors.inverseOnSurface,
        ),
      ),

      // PopupMenu
      popupMenuTheme: PopupMenuThemeData(
        color: AxiomColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        textStyle: AxiomTypography.bodyMedium.copyWith(
          color: AxiomColors.onSurface,
        ),
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicatorColor: AxiomColors.primary,
        labelColor: AxiomColors.primary,
        unselectedLabelColor: AxiomColors.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AxiomTypography.labelLarge,
        unselectedLabelStyle: AxiomTypography.labelLarge,
      ),
    );
  }

  /// Build text theme with proper colors
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AxiomTypography.display.copyWith(
        color: colorScheme.onSurface,
      ),
      displayMedium: AxiomTypography.displayMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      displaySmall: AxiomTypography.displaySmall.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: AxiomTypography.heading1.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: AxiomTypography.heading2.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: AxiomTypography.heading3.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AxiomTypography.heading2.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: AxiomTypography.heading3.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: AxiomTypography.labelLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyLarge: AxiomTypography.bodyLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: AxiomTypography.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: AxiomTypography.bodySmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: AxiomTypography.labelLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: AxiomTypography.labelMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: AxiomTypography.labelSmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Light theme (optional, warm Everforest light variant)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AxiomColors.inversePrimary,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFD4E8D1),
        onPrimaryContainer: const Color(0xFF3D5A3D),
        secondary: const Color(0xFF5C7A5D),
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFD9ECD9),
        surface: const Color(0xFFFAFAF8),
        onSurface: const Color(0xFF333D35),
        surfaceContainerHighest: const Color(0xFFE8EBE5),
        outline: const Color(0xFFA0B099),
        error: AxiomColors.red,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7F3),
      textTheme: TextTheme(
        displayLarge: AxiomTypography.display.copyWith(
          color: const Color(0xFF333D35),
        ),
        displayMedium: AxiomTypography.displayMedium.copyWith(
          color: const Color(0xFF333D35),
        ),
        displaySmall: AxiomTypography.displaySmall.copyWith(
          color: const Color(0xFF333D35),
        ),
        headlineLarge: AxiomTypography.heading1.copyWith(
          color: const Color(0xFF333D35),
        ),
        headlineMedium: AxiomTypography.heading2.copyWith(
          color: const Color(0xFF333D35),
        ),
        headlineSmall: AxiomTypography.heading3.copyWith(
          color: const Color(0xFF333D35),
        ),
        bodyLarge: AxiomTypography.bodyLarge.copyWith(
          color: const Color(0xFF333D35),
        ),
        bodyMedium: AxiomTypography.bodyMedium.copyWith(
          color: const Color(0xFF333D35),
        ),
        bodySmall: AxiomTypography.bodySmall.copyWith(
          color: const Color(0xFF5A6A5C),
        ),
        labelLarge: AxiomTypography.labelLarge.copyWith(
          color: const Color(0xFF333D35),
        ),
        labelMedium: AxiomTypography.labelMedium.copyWith(
          color: const Color(0xFF5A6A5C),
        ),
        labelSmall: AxiomTypography.labelSmall.copyWith(
          color: const Color(0xFF5A6A5C),
        ),
      ),
    );
  }
}
