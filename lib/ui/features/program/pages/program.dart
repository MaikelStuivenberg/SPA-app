import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/program/cubit/program_cubit.dart';
import 'package:spa_app/ui/features/program/models/activity.dart';
import 'package:spa_app/ui/features/program/widget/program_item.dart';
import 'package:spa_app/ui/features/tasks/widgets/task_list_tile.dart';
import 'package:spa_app/ui/features/tasks/widgets/task_progress_header.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/features/tasks/cubit/tasks_cubit.dart';
import 'package:spa_app/core/utils/date_formatter.dart';
import 'package:spa_app/ui/core/widgets/profile_avatar_button.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  ProgramPageState createState() => ProgramPageState();
}

class ProgramPageState extends State<ProgramPage> {
  final PageController _pageController = PageController();
  final ScrollController _listViewController = ScrollController();

  late DateTime minDate;
  late DateTime maxDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthStateSuccess) {
        final user = authState.user;
        if ((user.staff ?? false) || (user.tentLeader ?? false)) {
          context.read<TasksCubit>().loadTasksForUser(user.id!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isStaffOrTentLeader = authState is AuthStateSuccess &&
            ((authState.user.staff ?? false) ||
                (authState.user.tentLeader ?? false));
        final userId = authState is AuthStateSuccess ? authState.user.id : null;

        return DefaultTabController(
          length: isStaffOrTentLeader ? 2 : 1,
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.programTitle),
              actions: [
                if (isStaffOrTentLeader)
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () => context.push(RoutePaths.allTasks),
                    tooltip: AppLocalizations.of(context)!.tasksAllTasks,
                  ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ProfileAvatarButton(),
                ),
              ],
              bottom: TabBar(
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.5),
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.programTitle),
                  if (isStaffOrTentLeader)
                    Tab(text: AppLocalizations.of(context)!.tasksTab),
                ],
              ),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: TabBarView(
                children: [
                  _buildProgramTab(context),
                  if (isStaffOrTentLeader && userId != null)
                    _buildTasksTab(context, userId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgramTab(BuildContext context) {
    // Wait till pageController has clients
    // and then move to page with current date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pageController.hasClients) return;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (!today.isBefore(minDate) && !today.isAfter(maxDate)) {
        _pageController.jumpToPage(today.difference(minDate).inDays);
      }
    });

    return BlocBuilder<ProgramCubit, ProgramState>(
      bloc: BlocProvider.of<ProgramCubit>(context),
      builder: (context, programState) {
        if (programState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (programState.program == null || programState.program!.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.programNoActivitiesYet),
          );
        }

        final first = programState.program!.first.date!;
        final last = programState.program!.last.date!;
        minDate = DateTime(first.year, first.month, first.day);
        maxDate = DateTime(last.year, last.month, last.day);

        return RefreshIndicator(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        for (var i = 0; i < programState.amountOfDays; i++)
                          _buildProgramWidget(
                            minDate.add(Duration(days: i)),
                            programState
                                .activities(minDate.add(Duration(days: i))),
                          ),
                      ],
                    ),
                  ),
                  if (programState.amountOfDays > 1)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: programState.amountOfDays,
                        effect: const WormEffect(
                          dotHeight: 8,
                        ),
                        onDotClicked: (index) {},
                      ),
                    ),
                ],
              ),
            ],
          ),
          onRefresh: () =>
              BlocProvider.of<ProgramCubit>(context).fetchProgram(),
        );
      },
    );
  }

  Widget _buildProgramWidget(DateTime dayDate, List<Activity> activities) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: BlocProvider.of<AuthCubit>(context),
      builder: (context, authState) {
        if (authState is! AuthStateSuccess) return Container();

        final user = authState.user;

        final filteredActivities = activities
            // Only show relevant majors
            .where(
              (el) =>
                  el.requirements == null ||
                  user.major == null ||
                  user.major!.isEmpty ||
                  !el.requirements!.containsKey('major') ||
                  el.requirements!['major'] == null ||
                  (el.requirements!.containsKey('major') &&
                      el.requirements!['major']
                          .toString()
                          .split(',')
                          .contains(user.major)),
            )

            // Only show relevant minors
            .where(
              (el) =>
                  el.requirements == null ||
                  user.minor == null ||
                  user.minor!.isEmpty ||
                  !el.requirements!.containsKey('minor') ||
                  el.requirements!['minor'] == null ||
                  (el.requirements!.containsKey('minor') &&
                      el.requirements!['minor']
                          .toString()
                          .split(',')
                          .contains(user.minor)),
            )

            // Contains activity relevant for user's tent
            .where(
              (el) =>
                  el.requirements == null ||
                  user.tent == null ||
                  user.tent!.isEmpty ||
                  !el.requirements!.containsKey('tent') ||
                  el.requirements!['tent'] == null ||
                  (el.requirements!.containsKey('tent') &&
                      el.requirements!['tent']
                          .toString()
                          .split(',')
                          .contains(user.tent)),
            )

            // Only relevant activities for staff
            .where(
              (el) =>
                  el.requirements == null ||
                  !el.requirements!.containsKey('staff') ||
                  el.requirements!['staff'] == false ||
                  (user.staff != null && user.staff!),
            )

            // Only relevant activities for staff
            .where(
              (el) =>
                  el.requirements == null ||
                  !el.requirements!.containsKey('tentLeader') ||
                  el.requirements!['tentLeader'] == false ||
                  (user.tentLeader != null && user.tentLeader!),
            )

            // Only relevant activities for biblestudy leaders
            .where(
              (el) =>
                  el.requirements == null ||
                  !el.requirements!.containsKey('biblestudyLeader') ||
                  el.requirements!['biblestudyLeader'] == false ||
                  (user.biblestudyLeader != null && user.biblestudyLeader!),
            )

            // Filter on age <13
            .where(
              (el) =>
                  el.requirements == null ||
                  user.age == null ||
                  user.age!.isEmpty ||
                  !el.requirements!.containsKey('age') ||
                  el.requirements!['age'] != '<13' ||
                  (int.tryParse(user.age!) != null &&
                      int.tryParse(user.age!)! < 13),
            )

            // Filter on age >=13
            .where(
              (el) =>
                  el.requirements == null ||
                  user.age == null ||
                  user.age!.isEmpty ||
                  !el.requirements!.containsKey('age') ||
                  el.requirements!['age'] != '>=13' ||
                  (int.tryParse(user.age!) != null &&
                      int.tryParse(user.age!)! >= 13),
            )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16),
            Center(
              child: Text(
                DateFormatter(dayDate, context).formatAsDayname(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Container(height: 10),
            Expanded(
              child: filteredActivities.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.programNoActivitiesYet,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: ListView.builder(
                        controller: _listViewController,
                        itemCount: filteredActivities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Programitem(
                            isPast: filteredActivities[index]
                                .date!
                                .isBefore(DateTime.now()),
                            isCurrent: isCurrentItem(
                              filteredActivities[index],
                              index + 1 < filteredActivities.length
                                  ? filteredActivities[index + 1]
                                  : null,
                              DateTime.now(),
                            ),
                            activity: filteredActivities[index],
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTasksTab(BuildContext context, String userId) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, tasksState) {
        if (tasksState.isLoading && tasksState.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = tasksState.tasks;
        if (tasks.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.tasksNoTasks),
          );
        }

        final doneTaskIds = tasksState.doneTaskIds;
        final undoneTasks =
            tasks.where((t) => !doneTaskIds.contains(t.id)).toList();
        final doneTasks =
            tasks.where((t) => doneTaskIds.contains(t.id)).toList();
        undoneTasks.sort((a, b) => a.date.compareTo(b.date));
        doneTasks.sort((a, b) => a.date.compareTo(b.date));
        final completedCount = doneTasks.length;

        return RefreshIndicator(
          onRefresh: () =>
              context.read<TasksCubit>().loadTasksForUser(userId),
          child: ListView(
            children: [
              TaskProgressHeader(
                completedCount: completedCount,
                totalCount: tasks.length,
              ),
              ...undoneTasks.map(
                (task) => TaskListTile(
                  task: task,
                  isDone: false,
                  onToggle: ({required bool done}) => context
                      .read<TasksCubit>()
                      .toggleTaskDone(task.id, done: done),
                  onTap: () =>
                      context.push(RoutePaths.taskDetails, extra: task),
                ),
              ),
              if (undoneTasks.isNotEmpty && doneTasks.isNotEmpty)
                const TaskCompletedSectionHeader(),
              ...doneTasks.map(
                (task) => TaskListTile(
                  task: task,
                  isDone: true,
                  onToggle: ({required bool done}) => context
                      .read<TasksCubit>()
                      .toggleTaskDone(task.id, done: done),
                  onTap: () =>
                      context.push(RoutePaths.taskDetails, extra: task),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isCurrentItem(
    Activity activity,
    Activity? nextActivity,
    DateTime currentTime,
  ) {
    return (activity.date!.isBefore(currentTime) ||
            activity.date!.isAtSameMomentAs(currentTime)) &&
        nextActivity != null &&
        nextActivity.date!.isAfter(currentTime);
  }
}
