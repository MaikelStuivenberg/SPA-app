import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/app_semantic_colors.dart';

extension AppColorsContext on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
