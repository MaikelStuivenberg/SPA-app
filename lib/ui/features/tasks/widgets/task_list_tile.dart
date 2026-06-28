import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/core/utils/date_formatter.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    required this.task,
    this.isDone = false,
    this.onToggle,
    this.onTap,
    this.assignees,
    this.showDescription = true,
    this.showCompletion = true,
    super.key,
  });

  final Task task;
  final bool isDone;
  final void Function({required bool done})? onToggle;
  final VoidCallback? onTap;
  final List<UserData>? assignees;
  final bool showDescription;
  final bool showCompletion;

  void _handleToggle(BuildContext context, bool? checked) {
    final done = checked ?? false;
    HapticFeedback.lightImpact();
    onToggle?.call(done: done);
    if (done) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(task.title),
          action: SnackBarAction(
            label: l10n.tasksUndo,
            onPressed: () => onToggle?.call(done: false),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final day = DateFormatter(task.date, context).formatAsDayname();
    final time = TimeOfDay.fromDateTime(task.date).format(context);
    final colorScheme = Theme.of(context).colorScheme;
    final showAsDone = showCompletion && isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: showAsDone
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCompletion)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Checkbox(
                    key: ValueKey(isDone),
                    value: isDone,
                    onChanged: (checked) => _handleToggle(context, checked),
                  ),
                ),
              ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    showCompletion ? 0 : 16,
                    12,
                    16,
                    12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    decoration: showAsDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: showAsDone
                                        ? colorScheme.onSurface
                                            .withValues(alpha: 0.5)
                                        : null,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Opacity(
                              opacity: showAsDone ? 0.6 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.tasksDayTime(day, time)),
                                  if (task.location.isNotEmpty)
                                    Text(
                                      '${l10n.tasksLocation}: ${task.location}',
                                    ),
                                  if (showDescription &&
                                      task.description.isNotEmpty)
                                    Text(task.description),
                                  if (assignees != null &&
                                      assignees!.isNotEmpty)
                                    Text(
                                      assignees!
                                          .map(
                                            (u) =>
                                                '${u.firstname} ${u.lastname}',
                                          )
                                          .join(', '),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onTap != null)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
