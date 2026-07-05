import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/ui/core/widgets/app_bar_shape.dart';
import 'package:spa_app/ui/core/widgets/profile_avatar_button.dart';

Color _navIconColor(BuildContext context, {required bool isSelected}) {
  final scheme = Theme.of(context).colorScheme;
  return isSelected ? context.appColors.accent : scheme.onSurfaceVariant;
}

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  /// Vertical space occupied by [BottomAppBar] with centered FAB (with
  /// [extendBody]). Safe area is already part of the bar — do not add
  /// [MediaQuery.padding] on top of this.
  /// [BottomAppBar] height (80) plus half the centered FAB diameter (~28).
  static const bottomNavigationBarHeight = 108.0;

  static double bottomNavigationClearance(BuildContext context) {
    return bottomNavigationBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: _buildNavigationBar(context),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withValues(alpha: 0),
                  colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                  colorScheme.surfaceContainerLow,
                ],
              ),
            ),
            child: child,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: ProfileAvatarButton(
                  heroTag: GoRouterState.of(context).uri.path ==
                          RoutePaths.home
                      ? profileAvatarHeroTag
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ShellNavIcon(
              icon: Icons.calendar_today,
              isSelected: location == RoutePaths.program,
              onPressed: () => context.push(RoutePaths.program),
            ),
            _ShellNavIcon(
              icon: Icons.image,
              isSelected: location == RoutePaths.photos,
              onPressed: () => context.go(RoutePaths.photos),
            ),
            FloatingActionButton(
              onPressed: () => context.go(RoutePaths.home),
              elevation: location == RoutePaths.home ? 6 : 4,
              child: const Icon(Icons.home, size: 32),
            ),
            _ShellNavIcon(
              icon: Icons.map,
              isSelected: location == RoutePaths.map,
              onPressed: () => context.go(RoutePaths.map),
            ),
            _ShellNavIcon(
              icon: Icons.list,
              isSelected: location == RoutePaths.rules,
              onPressed: () => context.go(RoutePaths.rules),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShellNavIcon extends StatelessWidget {
  const _ShellNavIcon({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: _navIconColor(context, isSelected: isSelected),
      ),
      onPressed: onPressed,
    );
  }
}

/// Scaffold with optional app bar for pages outside the main shell.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    required this.title,
    required this.child,
    this.showMenu = false,
    this.actions,
    this.back = false,
    super.key,
  });

  final String? title;
  final Widget child;
  final bool showMenu;
  final List<Widget>? actions;
  final bool back;

  @override
  Widget build(BuildContext context) {
    if (showMenu) {
      return AppShell(child: child);
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface.withValues(alpha: 0),
              colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
              colorScheme.surfaceContainerLow,
            ],
          ),
        ),
        child: child,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: title == null
          ? null
          : AppBar(
              shape: AppBarShape(),
              automaticallyImplyLeading: false,
              leading: !back
                  ? null
                  : Builder(
                      builder: (context) {
                        if (context.canPop()) {
                          return IconButton(
                            icon: const Icon(FontAwesomeIcons.arrowLeft),
                            onPressed: () => context.pop(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              title: Text(title!),
              actions: actions ??
                  [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.solidUser),
                      onPressed: () => context.push(RoutePaths.userDetails),
                      color: colorScheme.onPrimary,
                    ),
                  ],
            ),
    );
  }
}
