import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/features/tasks/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDataRepository {
  final CollectionReference<Map<String, dynamic>> tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<List<Task>> getTasksForUser(String userId) async {
    final query = await tasksCollection.where('users', arrayContains: userId).get();
    return query.docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  // Local storage helpers for marking tasks as done
  static const String _doneTasksKey = 'done_tasks';

  Future<Set<String>> getDoneTaskIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_doneTasksKey)?.toSet() ?? <String>{};
  }

  Future<void> setTaskDone(String taskId, bool done) async {
    final prefs = await SharedPreferences.getInstance();
    final doneTasks = prefs.getStringList(_doneTasksKey)?.toSet() ?? <String>{};
    if (done) {
      doneTasks.add(taskId);
    } else {
      doneTasks.remove(taskId);
    }
    await prefs.setStringList(_doneTasksKey, doneTasks.toList());
  }

  Future<bool> isTaskDone(String taskId) async {
    final doneTasks = await getDoneTaskIds();
    return doneTasks.contains(taskId);
  }
} 