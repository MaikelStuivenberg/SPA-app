import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/app_palette.dart';
import 'package:spa_app/core/theme/app_semantic_colors.dart';

extension AppColorsContext on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}

extension AppColorScheme on ColorScheme {
  /// Brand accent for icons and labels on surface backgrounds (nav, tabs).
  ///
  /// Light mode uses navy [primary]; dark mode uses cyan [inversePrimary]
  /// because [primary] is a dark navy tuned for the app bar.
  Color get surfaceAccent =>
      brightness == Brightness.dark ? inversePrimary : primary;

  /// Default icon color on surface backgrounds.
  Color get onSurfaceIcon =>
      brightness == Brightness.dark ? onSurface : primary;

  /// Foreground on a [surfaceAccent] fill (e.g. check badge, camera button).
  Color get onSurfaceAccent =>
      brightness == Brightness.dark ? AppPalette.spaNavy : onPrimary;
}
