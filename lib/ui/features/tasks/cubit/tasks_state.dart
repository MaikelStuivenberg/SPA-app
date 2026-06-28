part of 'tasks_cubit.dart';

class TasksState {
  const TasksState({
    this.isLoading = false,
    this.doneTaskIds = const {},
    this.tasks = const [],
    this.allTasks = const [],
    this.taskUsers = const {},
  });

  final bool isLoading;
  final Set<String> doneTaskIds;
  final List<Task> tasks;
  final List<Task> allTasks;
  final Map<String, List<UserData>> taskUsers;

  TasksState copyWith({
    bool? isLoading,
    Set<String>? doneTaskIds,
    List<Task>? tasks,
    List<Task>? allTasks,
    Map<String, List<UserData>>? taskUsers,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      doneTaskIds: doneTaskIds ?? this.doneTaskIds,
      tasks: tasks ?? this.tasks,
      allTasks: allTasks ?? this.allTasks,
      taskUsers: taskUsers ?? this.taskUsers,
    );
  }
}
