import 'package:flutter/material.dart';
import 'package:spa_app/utils/styles.dart';

class MapItemWidget extends StatelessWidget {
  const MapItemWidget(this.location, this.description, {super.key});

  final String location;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
        child: Row(
          children: [
            SizedBox(
              width: 140,
              child: Text(
                location,
                style: Styles.textStyleLarge,
              ),
            ),
            Text(
              description,
              style: Styles.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
