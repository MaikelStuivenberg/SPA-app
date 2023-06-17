import 'package:flutter/material.dart';
import 'package:spa_app/utils/styles.dart';

class RuleContainerWidget extends StatelessWidget {
  RuleContainerWidget(this.title, this.text, {super.key});

  String title;
  String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Styles.pageSubTitleDark,
              ),
            ),
            Text(
              text,
              style: Styles.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
