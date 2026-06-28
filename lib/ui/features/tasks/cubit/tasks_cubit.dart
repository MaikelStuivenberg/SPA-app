import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/repositories/task_repository.dart';
import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TasksState());

  final TaskRepository _taskRepository;

  Future<void> loadDoneTaskIds() async {
    final doneIds = await _taskRepository.getDoneTaskIds();
    emit(state.copyWith(doneTaskIds: doneIds));
  }

  Future<void> loadTasksForUser(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await _taskRepository.getTasksForUser(userId);
      emit(state.copyWith(isLoading: false, tasks: tasks));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadAllTasks({bool forceRefresh = false}) async {
    if (!forceRefresh && state.allTasks.isNotEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await _taskRepository.getAllTasks();
      tasks.sort((a, b) => a.date.compareTo(b.date));
      emit(state.copyWith(isLoading: false, allTasks: tasks));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> toggleTaskDone(String taskId, {required bool done}) async {
    final previousDoneIds = Set<String>.from(state.doneTaskIds);
    final doneIds = Set<String>.from(state.doneTaskIds);
    if (done) {
      doneIds.add(taskId);
    } else {
      doneIds.remove(taskId);
    }
    emit(state.copyWith(doneTaskIds: doneIds));
    try {
      await _taskRepository.setTaskDone(taskId, done: done);
    } catch (_) {
      emit(state.copyWith(doneTaskIds: previousDoneIds));
    }
  }

  Future<List<UserData>> getUsersForTask(List<String> userIds) {
    return _taskRepository.getUsersByIds(userIds);
  }
}
