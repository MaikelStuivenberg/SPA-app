import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/features/tasks/models/task.dart';
import 'package:spa_app/features/tasks/pages/task_details_page.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/repositories/task_data.dart';
import 'package:spa_app/utils/date_formatter.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  List<Task> _allTasks = [];
  Map<String, List<UserData>> _taskUsers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTasks();
  }

  Future<void> _loadAllTasks() async {
    final tasks = await TaskDataRepository().getAllTasks();
    final Map<String, List<UserData>> taskUsers = {};
    
    // Load users for each task
    for (final task in tasks) {
      final users = await TaskDataRepository().getUsersByIds(task.users);
      taskUsers[task.id] = users;
    }

    setState(() {
      // Sort tasks by date/time in ascending order (earliest first)
      _allTasks = tasks..sort((a, b) => a.date.compareTo(b.date));
      _taskUsers = taskUsers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tasksAllTasks),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allTasks.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!.tasksNoTasks),
                )
              : RefreshIndicator(
                  onRefresh: _loadAllTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _allTasks.length,
                    itemBuilder: (context, index) {
                      final task = _allTasks[index];
                      final users = _taskUsers[task.id] ?? [];
                      final day = DateFormatter(task.date, context).formatAsDayname();
                      final time = TimeOfDay.fromDateTime(task.date).format(context);
                      
                      // Count unique users by name
                      final uniqueUsers = users.fold<Set<String>>(<String>{}, (set, user) {
                        final fullName = '${user.firstname ?? ''} ${user.lastname ?? ''}'.trim();
                        if (fullName.isNotEmpty) {
                          set.add(fullName);
                        }
                        return set;
                      });

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsPage(task: task),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${AppLocalizations.of(context)!.tasksDayTime(day, time)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                if (task.location.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppLocalizations.of(context)!.tasksLocation}: ${task.location}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                                if (task.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 12),
                                
                                // Assigned users count (unique by name)
                                Row(
                                  children: [
                                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${uniqueUsers.length} ${uniqueUsers.length == 1 ? 'person' : 'people'} assigned',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
} 