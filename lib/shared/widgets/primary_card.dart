import 'package:flutter/material.dart';
import 'package:spa_app/shared/widgets/card.dart';

class PrimaryCardWidget extends StatelessWidget {
  const PrimaryCardWidget({required this.child, super.key, this.onTap});

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      key: key,
      color: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      child: child,
    );
  }
}
