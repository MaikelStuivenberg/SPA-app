import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/app_palette.dart';
import 'package:spa_app/core/theme/app_semantic_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.spaNavy,
      onPrimary: AppPalette.onDark,
      primaryContainer: AppPalette.spaNavyMuted,
      onPrimaryContainer: AppPalette.onDark,
      secondary: AppPalette.saRed,
      onSecondary: AppPalette.onDark,
      secondaryContainer: Color(0xFFFCE8E9),
      onSecondaryContainer: AppPalette.saRed,
      tertiary: AppPalette.amber,
      onTertiary: AppPalette.onDark,
      tertiaryContainer: Color(0xFFFFF3E0),
      onTertiaryContainer: Color(0xFF5D4037),
      error: AppPalette.error,
      onError: AppPalette.onDark,
      errorContainer: Color(0xFFFFEBEE),
      onErrorContainer: AppPalette.error,
      surface: AppPalette.surfaceLight,
      onSurface: AppPalette.onSurfaceLight,
      onSurfaceVariant: AppPalette.onSurfaceVariantLight,
      outline: AppPalette.outlineLight,
      outlineVariant: Color(0xFFDDE3EA),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppPalette.spaNavy,
      onInverseSurface: AppPalette.onDark,
      inversePrimary: AppPalette.spaCyan,
      surfaceTint: AppPalette.spaNavy,
      surfaceContainerHighest: AppPalette.surfaceContainerLight,
      surfaceContainerHigh: Color(0xFFE8EDF2),
      surfaceContainer: Color(0xFFF0F4F8),
      surfaceContainerLow: Color(0xFFF4F7FA),
      surfaceContainerLowest: AppPalette.onDark,
      surfaceBright: AppPalette.onDark,
      surfaceDim: Color(0xFFD8DEE6),
    );

    return _buildTheme(colorScheme, AppSemanticColors.light);
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.spaNavyMuted,
      onPrimary: AppPalette.onDark,
      primaryContainer: AppPalette.spaNavy,
      onPrimaryContainer: AppPalette.onDark,
      secondary: AppPalette.saRed,
      onSecondary: AppPalette.onDark,
      secondaryContainer: Color(0xFF5C1518),
      onSecondaryContainer: Color(0xFFFFCDD2),
      tertiary: AppPalette.amber,
      onTertiary: AppPalette.onDark,
      tertiaryContainer: Color(0xFF5D4037),
      onTertiaryContainer: Color(0xFFFFE0B2),
      error: Color(0xFFEF9A9A),
      onError: Color(0xFF5C0000),
      errorContainer: Color(0xFF5C1518),
      onErrorContainer: Color(0xFFFFCDD2),
      surface: AppPalette.surfaceDark,
      onSurface: AppPalette.onSurfaceDark,
      onSurfaceVariant: AppPalette.onSurfaceVariantDark,
      outline: AppPalette.outlineDark,
      outlineVariant: Color(0xFF2A3A4E),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppPalette.onSurfaceDark,
      onInverseSurface: AppPalette.spaNavy,
      inversePrimary: AppPalette.spaCyan,
      surfaceTint: AppPalette.spaCyan,
      surfaceContainerHighest: AppPalette.surfaceContainerDark,
      surfaceContainerHigh: Color(0xFF152232),
      surfaceContainer: Color(0xFF121E2C),
      surfaceContainerLow: Color(0xFF0F1A28),
      surfaceContainerLowest: Color(0xFF0A121C),
      surfaceBright: Color(0xFF243447),
      surfaceDim: AppPalette.spaNavy,
    );

    return _buildTheme(colorScheme, AppSemanticColors.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    AppSemanticColors semanticColors,
  ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      fontFamily: 'Montserrat',
      dividerColor: colorScheme.outlineVariant,
      extensions: [semanticColors],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 28,
          color: colorScheme.onPrimary,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: colorScheme.surfaceContainerLow,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 36),
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: semanticColors.shadowLight,
      ),
    );
  }
}
