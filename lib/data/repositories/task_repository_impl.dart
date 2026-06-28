import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/core/config/camp_date_range.dart';
import 'package:spa_app/data/services/preferences_service.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/domain/repositories/task_repository.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required UserRepository userRepository,
    required PreferencesService preferencesService,
    required RemoteConfigService remoteConfigService,
    FirebaseFirestore? firestore,
  })  : _userRepository = userRepository,
        _preferencesService = preferencesService,
        _remoteConfigService = remoteConfigService,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final UserRepository _userRepository;
  final PreferencesService _preferencesService;
  final RemoteConfigService _remoteConfigService;
  final FirebaseFirestore _firestore;

  static const _doneTasksKey = 'done_tasks';

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  List<Task> _withinCampRange(List<Task> tasks) {
    final campDates = CampDateRange.fromRemoteConfig(_remoteConfigService);
    return tasks.where((task) => campDates.contains(task.date)).toList();
  }

  @override
  Future<List<Task>> getTasksForUser(String userId) async {
    final query =
        await _tasksCollection.where('users', arrayContains: userId).get();
    return _withinCampRange(query.docs.map(Task.fromFirestore).toList());
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final query = await _tasksCollection.get();
    return _withinCampRange(query.docs.map(Task.fromFirestore).toList());
  }

  @override
  Future<Task?> getTaskById(String taskId) async {
    final doc = await _tasksCollection.doc(taskId).get();
    if (!doc.exists) return null;
    return Task.fromFirestore(doc);
  }

  @override
  Future<List<UserData>> getUsersByIds(List<String> userIds) {
    return _userRepository.getUsersByIds(userIds);
  }

  @override
  Future<Set<String>> getDoneTaskIds() {
    return _preferencesService.getStringSet(_doneTasksKey);
  }

  @override
  Future<void> setTaskDone(String taskId, {required bool done}) async {
    final doneTasks = await _preferencesService.getStringSet(_doneTasksKey);
    if (done) {
      doneTasks.add(taskId);
    } else {
      doneTasks.remove(taskId);
    }
    await _preferencesService.setStringSet(_doneTasksKey, doneTasks);
  }

  @override
  Future<bool> isTaskDone(String taskId) async {
    final doneTasks = await getDoneTaskIds();
    return doneTasks.contains(taskId);
  }
}
