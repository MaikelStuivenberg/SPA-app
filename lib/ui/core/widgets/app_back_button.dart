import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/l10n/app_localizations.dart';

/// Standard back control for all navigation chrome.
///
/// Uses [FontAwesomeIcons.arrowLeft] and [context.pop] when [GoRouter.canPop].
/// Renders nothing when there is no route to pop.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    this.onPrimary = true,
    super.key,
  });

  /// When true, icon color follows [ColorScheme.onPrimary] (AppBar context).
  final bool onPrimary;

  @override
  Widget build(BuildContext context) {
    if (!context.canPop()) {
      return const SizedBox(width: 48, height: 48);
    }

    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = onPrimary ? colorScheme.onPrimary : colorScheme.primary;

    return IconButton(
      icon: Icon(FontAwesomeIcons.arrowLeft, color: iconColor),
      tooltip: AppLocalizations.of(context)!.commonBack,
      onPressed: () => context.pop(),
    );
  }
}
