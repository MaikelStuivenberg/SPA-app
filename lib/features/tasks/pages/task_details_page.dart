import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/features/tasks/models/task.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/repositories/task_data.dart';
import 'package:spa_app/utils/date_formatter.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

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
    final users = await TaskDataRepository().getUsersByIds(widget.task.users);
    setState(() {
      _assignedUsers = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final day = DateFormatter(widget.task.date, context).formatAsDayname();
    final time = TimeOfDay.fromDateTime(widget.task.date).format(context);
    
    // Count unique users by name
    final uniqueUsers = _assignedUsers.fold<Set<String>>(<String>{}, (set, user) {
      final fullName = '${user.firstname ?? ''} ${user.lastname ?? ''}'.trim();
      if (fullName.isNotEmpty) {
        set.add(fullName);
      }
      return set;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tasksDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task details card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppLocalizations.of(context)!.tasksDayTime(day, time)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (widget.task.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context)!.tasksLocation}: ${widget.task.location}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (widget.task.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.task.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Assigned users section
            Text(
              '${AppLocalizations.of(context)!.tasksAssignedUsers} (${uniqueUsers.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_assignedUsers.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.tasksNoAssignedUsers,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: uniqueUsers.length,
                itemBuilder: (context, index) {
                  final userName = uniqueUsers.elementAt(index);
                  // Find the first user with this name to get their details
                  final user = _assignedUsers.firstWhere(
                    (user) => '${user.firstname ?? ''} ${user.lastname ?? ''}'.trim() == userName,
                    orElse: () => _assignedUsers.first,
                  );
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.tent?.isNotEmpty == true)
                            Text('${AppLocalizations.of(context)!.tasksTent}: ${user.tent}'),
                          if (user.major?.isNotEmpty == true)
                            Text('${AppLocalizations.of(context)!.tasksMajor}: ${user.major}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
} 