import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasksForUser(String userId);
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String taskId);
  Future<List<UserData>> getUsersByIds(List<String> userIds);
  Future<Set<String>> getDoneTaskIds();
  Future<void> setTaskDone(String taskId, {required bool done});
  Future<bool> isTaskDone(String taskId);
}
