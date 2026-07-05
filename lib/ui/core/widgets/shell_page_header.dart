import 'package:flutter/material.dart';

/// Tier-1 header for root tab pages inside [AppShell].
///
/// Large inline title on the gradient body — no back button. Right padding
/// clears the shell's [ProfileAvatarButton] overlay.
class ShellPageHeader extends StatelessWidget {
  const ShellPageHeader({
    required this.title,
    this.actions,
    super.key,
  });

  final String title;
  final List<Widget>? actions;

  static const _rightClearance = 56.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: actions == null ? _rightClearance - 4 : 0,
                ),
                child: Text(
                  title,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
