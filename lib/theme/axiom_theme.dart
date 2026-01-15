/// Main theme configuration for AXIOM
/// Applies Material Design 3 with custom design tokens
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

class AxiomTheme {
  AxiomTheme._();

  /// Dark theme (primary theme for AXIOM)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AxiomColors.primary,
        onPrimary: AxiomColors.onPrimary,
        primaryContainer: AxiomColors.primaryLight,
        onPrimaryContainer: AxiomColors.onPrimary,
        surface: AxiomColors.surfaceDark,
        onSurface: Colors.white,
        surfaceContainerHighest: AxiomColors.surfaceVariant,
        outline: AxiomColors.outline,
        outlineVariant: AxiomColors.borderDark,
        error: AxiomColors.error,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AxiomColors.backgroundDark,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AxiomColors.backgroundDark.withAlpha((0.9 * 255).round()),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        titleTextStyle: AxiomTypography.heading2.copyWith(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: AxiomTypography.display.copyWith(color: Colors.white),
        displayMedium: AxiomTypography.displayMedium.copyWith(color: Colors.white),
        displaySmall: AxiomTypography.displaySmall.copyWith(color: Colors.white),
        headlineLarge: AxiomTypography.heading1.copyWith(color: Colors.white),
        headlineMedium: AxiomTypography.heading2.copyWith(color: Colors.white),
        headlineSmall: AxiomTypography.heading3.copyWith(color: Colors.white),
        bodyLarge: AxiomTypography.bodyLarge.copyWith(color: Colors.white),
        bodyMedium: AxiomTypography.bodyMedium.copyWith(color: Colors.white),
        bodySmall: AxiomTypography.bodySmall.copyWith(color: Colors.white),
        labelLarge: AxiomTypography.labelLarge.copyWith(color: Colors.white),
        labelMedium: AxiomTypography.labelMedium.copyWith(color: AxiomColors.textMuted),
        labelSmall: AxiomTypography.labelSmall.copyWith(color: AxiomColors.textMuted),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AxiomColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.lg),
          side: BorderSide(
            color: AxiomColors.borderDark,
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withAlpha((0.3 * 255).round()),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AxiomColors.primary,
          foregroundColor: AxiomColors.onPrimary,
          elevation: 2,
          shadowColor: Colors.black.withAlpha((0.3 * 255).round()),
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

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: AxiomColors.borderDark,
            width: 1.5,
          ),
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

      // Text Button
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
          foregroundColor: Colors.white,
          hoverColor: Colors.white.withAlpha((0.1 * 255).round()),
          highlightColor: Colors.white.withAlpha((0.2 * 255).round()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AxiomRadius.full),
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AxiomColors.primary,
        foregroundColor: AxiomColors.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        ),
        iconSize: 28,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AxiomColors.surfaceDark,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.xl),
        ),
        titleTextStyle: AxiomTypography.heading2.copyWith(color: Colors.white),
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(color: Colors.white),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AxiomColors.surfaceDark,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AxiomRadius.xl),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AxiomColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(
            color: AxiomColors.borderDark,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(
            color: AxiomColors.borderDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(
            color: AxiomColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
          borderSide: BorderSide(
            color: AxiomColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.md,
        ),
        hintStyle: AxiomTypography.bodyMedium.copyWith(
          color: AxiomColors.textMuted,
        ),
        labelStyle: AxiomTypography.labelMedium.copyWith(
          color: AxiomColors.textMuted,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AxiomColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AxiomColors.primary.withAlpha((0.1 * 255).round()),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AxiomColors.surfaceVariant,
        selectedColor: AxiomColors.primary,
        labelStyle: AxiomTypography.labelMedium.copyWith(color: Colors.white),
        side: BorderSide(
          color: AxiomColors.borderDark,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.full),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.sm,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AxiomColors.surfaceDark,
        contentTextStyle: AxiomTypography.bodyMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AxiomRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 3,
      ),

      // Navigation Bar (Bottom)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AxiomColors.surfaceDark,
        indicatorColor: AxiomColors.primary,
        height: 64,
        labelTextStyle: WidgetStateProperty.all(
          AxiomTypography.labelSmall.copyWith(color: AxiomColors.textMuted),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white);
          }
          return IconThemeData(color: AxiomColors.textMuted);
        }),
      ),

      // Navigation Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AxiomColors.surfaceDark,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }

  /// Light theme (optional, for future use)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AxiomColors.primary,
        onPrimary: AxiomColors.onPrimary,
        primaryContainer: AxiomColors.primaryLight,
        onPrimaryContainer: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        outline: AxiomColors.outline,
        error: AxiomColors.error,
      ),
      scaffoldBackgroundColor: AxiomColors.backgroundLight,
      textTheme: TextTheme(
        displayLarge: AxiomTypography.display.copyWith(color: Colors.black87),
        displayMedium: AxiomTypography.displayMedium.copyWith(color: Colors.black87),
        displaySmall: AxiomTypography.displaySmall.copyWith(color: Colors.black87),
        headlineLarge: AxiomTypography.heading1.copyWith(color: Colors.black87),
        headlineMedium: AxiomTypography.heading2.copyWith(color: Colors.black87),
        headlineSmall: AxiomTypography.heading3.copyWith(color: Colors.black87),
        bodyLarge: AxiomTypography.bodyLarge.copyWith(color: Colors.black87),
        bodyMedium: AxiomTypography.bodyMedium.copyWith(color: Colors.black87),
        bodySmall: AxiomTypography.bodySmall.copyWith(color: Colors.black87),
        labelLarge: AxiomTypography.labelLarge.copyWith(color: Colors.black87),
        labelMedium: AxiomTypography.labelMedium.copyWith(color: Colors.black54),
        labelSmall: AxiomTypography.labelSmall.copyWith(color: Colors.black54),
      ),
    );
  }
}
