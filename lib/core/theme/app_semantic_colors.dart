import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/app_palette.dart';

/// Semantic color tokens exposed via [ThemeExtension] for accents beyond M3 ColorScheme.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.accent,
    required this.tertiary,
    required this.success,
    required this.warning,
    required this.error,
    required this.favorite,
    required this.shadowLight,
    required this.scrim,
    required this.ruleAccents,
    required this.decorativeAccents,
  });

  /// Poster cyan — highlights, active states, glow-like accents.
  final Color accent;

  /// Warm amber — decorative variety, safety rule card.
  final Color tertiary;

  final Color success;
  final Color warning;
  final Color error;

  /// Like/favorite actions (uses SA red for camp warmth).
  final Color favorite;

  /// Subtle card/list shadows on light surfaces.
  final Color shadowLight;

  /// Modal/photo overlay scrim.
  final Color scrim;

  /// Four distinct colors for the rules carousel.
  final List<Color> ruleAccents;

  /// Decorative circle tints on auth screens (navy, cyan, red, amber).
  final List<Color> decorativeAccents;

  static const light = AppSemanticColors(
    accent: AppPalette.spaCyan,
    tertiary: AppPalette.amber,
    success: AppPalette.success,
    warning: AppPalette.warning,
    error: AppPalette.error,
    favorite: AppPalette.saRed,
    shadowLight: Color(0x14000000),
    scrim: Color(0xDE000000),
    ruleAccents: [
      AppPalette.spaNavy,
      AppPalette.saRed,
      AppPalette.amber,
      AppPalette.spaCyan,
    ],
    decorativeAccents: [
      AppPalette.spaNavy,
      AppPalette.spaCyan,
      AppPalette.saRed,
      AppPalette.amber,
    ],
  );

  static const dark = AppSemanticColors(
    accent: AppPalette.spaCyan,
    tertiary: AppPalette.amber,
    success: AppPalette.success,
    warning: AppPalette.warning,
    error: AppPalette.error,
    favorite: AppPalette.saRed,
    shadowLight: Color(0x33000000),
    scrim: Color(0xE6000000),
    ruleAccents: [
      AppPalette.spaCyan,
      AppPalette.saRed,
      AppPalette.amber,
      Color(0xFF6B9FD4),
    ],
    decorativeAccents: [
      AppPalette.spaCyan,
      AppPalette.spaNavyMuted,
      AppPalette.saRed,
      AppPalette.amber,
    ],
  );

  @override
  AppSemanticColors copyWith({
    Color? accent,
    Color? tertiary,
    Color? success,
    Color? warning,
    Color? error,
    Color? favorite,
    Color? shadowLight,
    Color? scrim,
    List<Color>? ruleAccents,
    List<Color>? decorativeAccents,
  }) {
    return AppSemanticColors(
      accent: accent ?? this.accent,
      tertiary: tertiary ?? this.tertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      favorite: favorite ?? this.favorite,
      shadowLight: shadowLight ?? this.shadowLight,
      scrim: scrim ?? this.scrim,
      ruleAccents: ruleAccents ?? this.ruleAccents,
      decorativeAccents: decorativeAccents ?? this.decorativeAccents,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      accent: Color.lerp(accent, other.accent, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      ruleAccents: List.generate(
        ruleAccents.length,
        (i) => Color.lerp(ruleAccents[i], other.ruleAccents[i], t)!,
      ),
      decorativeAccents: List.generate(
        decorativeAccents.length,
        (i) =>
            Color.lerp(decorativeAccents[i], other.decorativeAccents[i], t)!,
      ),
    );
  }
}
