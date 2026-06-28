import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

List<UserData> dedupeUsers(List<UserData> users) {
  final seen = <String>{};
  return users.where((user) {
    final id = user.id;
    if (id == null || id.isEmpty) {
      return true;
    }
    if (seen.contains(id)) {
      return false;
    }
    seen.add(id);
    return true;
  }).toList();
}

String _initials(UserData user) {
  final first =
      (user.firstname?.isNotEmpty ?? false) ? user.firstname![0] : '';
  final last = (user.lastname?.isNotEmpty ?? false) ? user.lastname![0] : '';
  return '$first$last'.toUpperCase();
}

class AssignedUsersList extends StatelessWidget {
  const AssignedUsersList({required this.users, super.key});

  final List<UserData> users;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uniqueUsers = dedupeUsers(users);

    if (uniqueUsers.isEmpty) {
      return Text(
        l10n.tasksNoAssignedUsers,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tasksAssignedUsers,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...uniqueUsers.map(
          (user) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              child: Text(_initials(user)),
            ),
            title: Text('${user.firstname} ${user.lastname}'),
          ),
        ),
      ],
    );
  }
}
