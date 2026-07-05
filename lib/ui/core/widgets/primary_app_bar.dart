import 'package:flutter/material.dart';
import 'package:spa_app/ui/core/widgets/app_bar_shape.dart';

/// Curved navy app bar shared by [PageScaffold] and tabbed stacked pages.
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    super.key,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: AppBarShape(),
      automaticallyImplyLeading: false,
      leading: leading,
      title: title,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
