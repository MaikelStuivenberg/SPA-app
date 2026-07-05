import 'package:flutter/material.dart';
import 'package:spa_app/ui/core/widgets/app_back_button.dart';

/// Tier-1 header for nested routes inside [AppShell] that need a back button
/// while keeping bottom navigation visible.
class ShellDetailHeader extends StatelessWidget {
  const ShellDetailHeader({
    required this.title,
    this.actions,
    super.key,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
        child: Row(
          children: [
            const AppBackButton(onPrimary: false),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
