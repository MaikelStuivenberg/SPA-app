import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.child,
    this.color,
    this.textColor,
    super.key,
    this.onTap,
    this.padding = 8,
  });

  final Color? color;
  final Color? textColor;
  final Widget child;
  final double padding;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(padding),
          child: DefaultTextStyle(
            style: TextStyle(
              color: textColor ?? Theme.of(context).colorScheme.onSurface,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
