import 'package:flutter/material.dart';

/// Gradient background used by [AppShell] and stacked [PageScaffold] pages.
class ScaffoldGradient extends StatelessWidget {
  const ScaffoldGradient({required this.child, super.key});

  final Widget child;

  static BoxDecoration decoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorScheme.surface.withValues(alpha: 0),
          colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
          colorScheme.surfaceContainerLow,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration(context),
      child: child,
    );
  }
}
