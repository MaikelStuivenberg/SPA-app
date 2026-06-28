import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/core/utils/date_formatter.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/card.dart';
import 'package:spa_app/ui/features/tasks/cubit/tasks_cubit.dart';
import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/tasks/widgets/assigned_users_list.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({required this.task, super.key});

  final Task task;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  List<UserData> _assignedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedUsers();
  }

  Future<void> _loadAssignedUsers() async {
    final cached =
        context.read<TasksCubit>().state.taskUsers[widget.task.id];
    if (cached != null) {
      setState(() {
        _assignedUsers = cached;
        _isLoading = false;
      });
      return;
    }

    final users = await context
        .read<TasksCubit>()
        .getUsersForTask(widget.task.users);
    if (!mounted) return;
    setState(() {
      _assignedUsers = users;
      _isLoading = false;
    });
  }

  void _toggleDone(BuildContext context, bool done) {
    HapticFeedback.lightImpact();
    context.read<TasksCubit>().toggleTaskDone(widget.task.id, done: done);
    if (done) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(widget.task.title),
          action: SnackBarAction(
            label: l10n.tasksUndo,
            onPressed: () => context
                .read<TasksCubit>()
                .toggleTaskDone(widget.task.id, done: false),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final day = DateFormatter(widget.task.date, context).formatAsDayname();
    final time = TimeOfDay.fromDateTime(widget.task.date).format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                final isDone = state.doneTaskIds.contains(widget.task.id);
                final colorScheme = Theme.of(context).colorScheme;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isDone
                            ? colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6)
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
                      child: CheckboxListTile(
                        value: isDone,
                        title: Text(
                          l10n.tasksMarkDone,
                          style: TextStyle(
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                            color: isDone
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : null,
                          ),
                        ),
                        onChanged: (checked) =>
                            _toggleDone(context, checked ?? false),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tasksDayTime(day, time),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (widget.task.location.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${l10n.tasksLocation}: ${widget.task.location}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (widget.task.description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(widget.task.description),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      child: AssignedUsersList(users: _assignedUsers),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
