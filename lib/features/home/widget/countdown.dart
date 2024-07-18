import 'package:flutter/material.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/primary_card.dart';

class CountdownWidget extends StatelessWidget {
  CountdownWidget({super.key});

  final DateTime targetDate = DateTime(2024, 7, 20, 14, 30);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysRemaining = targetDate.difference(now).inDays;
    final hoursRemaining = targetDate.difference(now).inHours;

    return SizedBox(
      width: double.infinity,
      child: PrimaryCardWidget(
        onTap: () => Navigator.of(context).pushNamed(Routes.program),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if(daysRemaining >= 2)
              Text(
                '$daysRemaining dagen',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              if(daysRemaining < 2)
              Text(
                '$hoursRemaining uur',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              Text(
                'tot SPA2024',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
