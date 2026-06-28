import 'package:spa_app/core/theme/app_palette.dart';

/// Deprecated aliases — prefer [Theme.of(context).colorScheme] and
/// [context.appColors] from theme_extensions.dart.
@Deprecated('Use Theme.of(context).colorScheme or AppPalette')
class AppColors {
  AppColors._();

  static const mainColor = AppPalette.spaNavy;
  static const secondaryColor = AppPalette.saRed;
}
