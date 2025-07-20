import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/features/tasks/models/task.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDataRepository {
  final CollectionReference<Map<String, dynamic>> tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<Task>> getTasksForUser(String userId) async {
    final query = await tasksCollection.where('users', arrayContains: userId).get();
    return query.docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  Future<List<Task>> getAllTasks() async {
    final query = await tasksCollection.get();
    return query.docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  Future<Task?> getTaskById(String taskId) async {
    final doc = await tasksCollection.doc(taskId).get();
    if (doc.exists) {
      return Task.fromFirestore(doc);
    }
    return null;
  }

  Future<List<UserData>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    
    // Firestore has a limit of 10 items in 'in' queries, so we need to batch them
    const int batchSize = 10;
    final List<UserData> users = [];
    
    for (int i = 0; i < userIds.length; i += batchSize) {
      final batch = userIds.skip(i).take(batchSize).toList();
      
      try {
        // Ensure batch is not empty and has valid IDs
        if (batch.isEmpty) continue;
        
        final query = await usersCollection
            .where(FieldPath.documentId, whereIn: batch)
            .get();
            
        for (final doc in query.docs) {
          final data = doc.data();
          users.add(UserData(
            id: doc.id,
            firstname: data['firstname'] as String? ?? '',
            lastname: data['lastname'] as String? ?? '',
            age: data['age'] as String? ?? '',
            major: data['major'] as String? ?? '',
            minor: data['minor'] as String? ?? '',
            image: data['image'] as String? ?? '',
            biblestudyGroup: data['biblestudyGroup'] as String?,
            biblestudyLeader: data['biblestudyLeader'] as bool?,
            tent: data['tent'] as String?,
            tentLeader: data['tentLeader'] as bool?,
            staff: data['staff'] as bool?,
          ));
        }
      } catch (e) {
        print('Batch query failed for IDs: $batch. Error: $e');
        // If the batch query fails, fall back to individual queries for this batch
        for (final userId in batch) {
          try {
            final doc = await usersCollection.doc(userId).get();
            if (doc.exists) {
              final data = doc.data()!;
              users.add(UserData(
                id: doc.id,
                firstname: data['firstname'] as String? ?? '',
                lastname: data['lastname'] as String? ?? '',
                age: data['age'] as String? ?? '',
                major: data['major'] as String? ?? '',
                minor: data['minor'] as String? ?? '',
                image: data['image'] as String? ?? '',
                biblestudyGroup: data['biblestudyGroup'] as String?,
                biblestudyLeader: data['biblestudyLeader'] as bool?,
                tent: data['tent'] as String?,
                tentLeader: data['tentLeader'] as bool?,
                staff: data['staff'] as bool?,
              ));
            }
          } catch (e) {
            // Skip users that can't be found
            continue;
          }
        }
      }
    }
    
    return users;
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