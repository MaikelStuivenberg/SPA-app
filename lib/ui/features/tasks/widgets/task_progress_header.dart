import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';

class TaskProgressHeader extends StatelessWidget {
  const TaskProgressHeader({
    required this.completedCount,
    required this.totalCount,
    super.key,
  });

  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allDone = totalCount > 0 && completedCount >= totalCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allDone
                ? l10n.tasksAllDone
                : l10n.tasksProgress(completedCount, totalCount),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalCount == 0 ? 0 : completedCount / totalCount,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCompletedSectionHeader extends StatelessWidget {
  const TaskCompletedSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        AppLocalizations.of(context)!.tasksCompletedSection,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
            ),
      ),
    );
  }
}
