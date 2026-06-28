import 'package:flutter/material.dart';
import 'package:spa_app/ui/core/widgets/app_shell.dart';

class DefaultScaffoldWidget extends PageScaffold {
  const DefaultScaffoldWidget(
    String? title,
    Widget child, {
    super.showMenu = true,
    super.actions,
    super.back = false,
    super.key,
  }) : super(title: title, child: child);
}
