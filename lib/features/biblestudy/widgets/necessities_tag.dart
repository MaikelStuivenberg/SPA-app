import 'package:flutter/material.dart';

class NecessitiesTag extends StatelessWidget {
  final String text;

  const NecessitiesTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.only(right: 8, top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 2,
        ),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
