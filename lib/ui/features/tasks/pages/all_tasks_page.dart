import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/tasks/cubit/tasks_cubit.dart';
import 'package:spa_app/ui/features/tasks/widgets/task_list_tile.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().loadAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tasksAllTasks),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.isLoading && state.allTasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.isLoading && state.allTasks.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.tasksNoTasks),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<TasksCubit>().loadAllTasks(forceRefresh: true),
            child: ListView.builder(
              itemCount: state.allTasks.length,
              itemBuilder: (context, index) {
                final task = state.allTasks[index];

                return TaskListTile(
                  task: task,
                  showCompletion: false,
                  showDescription: false,
                  onTap: () =>
                      context.push(RoutePaths.taskDetails, extra: task),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
