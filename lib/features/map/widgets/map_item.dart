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
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 2),
        child: Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    location,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
