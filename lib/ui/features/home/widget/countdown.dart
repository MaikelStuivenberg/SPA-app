import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/core/widgets/primary_card.dart';

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({
    required this.targetDate,
    required this.countdownEvent,
    super.key,
  });

  final DateTime targetDate;
  final String countdownEvent;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysRemaining = targetDate.difference(now).inDays;
    final hoursRemaining = targetDate.difference(now).inHours;

    return SizedBox(
      width: double.infinity,
      child: PrimaryCardWidget(
        onTap: () => context.push(RoutePaths.program),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (daysRemaining >= 2)
                Text(
                  '$daysRemaining dagen',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              if (daysRemaining < 2)
                Text(
                  '$hoursRemaining uur',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              Text(
                'tot $countdownEvent',
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
