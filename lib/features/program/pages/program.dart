import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/features/program/cubit/program_cubit.dart';
import 'package:spa_app/features/program/models/activity.dart';
import 'package:spa_app/features/program/widget/program_item.dart';
import 'package:spa_app/features/tasks/models/task.dart';
import 'package:spa_app/features/tasks/pages/all_tasks_page.dart';
import 'package:spa_app/features/tasks/pages/task_details_page.dart';
import 'package:spa_app/shared/repositories/task_data.dart';
import 'package:spa_app/utils/date_formatter.dart';

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

  Set<String> _doneTaskIds = <String>{};
  bool _doneTasksLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDoneTasks();
  }

  Future<void> _loadDoneTasks() async {
    final doneIds = await TaskDataRepository().getDoneTaskIds();
    setState(() {
      _doneTaskIds = doneIds;
      _doneTasksLoaded = true;
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllTasksPage(),
                        ),
                      );
                    },
                    tooltip: AppLocalizations.of(context)!.tasksAllTasks,
                  ),
              ],
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.5),
                indicatorColor: Colors.white,
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
      if (_pageController.hasClients &&
          DateTime.now().isAfter(minDate) &&
          DateTime.now().isBefore(maxDate)) {
        _pageController.jumpToPage(DateTime.now().day - minDate.day);
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

        minDate = programState.program!.first.date!;
        maxDate = programState.program!.last.date!;

        return RefreshIndicator(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        for (var i = 0; i <= programState.amountOfDays; i++)
                          _buildProgramWidget(
                            programState
                                .activities(minDate.add(Duration(days: i))),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: SmoothPageIndicator(
                      controller: _pageController, // PageController
                      count: programState.amountOfDays + 1,
                      effect: const WormEffect(
                        // dotColor: AppColors.mainColor,
                        // activeDotColor: AppColors.secondaryColor,
                        dotHeight: 8,
                      ), // your preferred effect
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

  Widget _buildProgramWidget(List<Activity> activities) {
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
                DateFormatter(filteredActivities.first.date!, context)
                    .formatAsDayname(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Container(height: 10),
            Expanded(
              child: Container(
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
    return FutureBuilder<List<Task>>(
      future: TaskDataRepository().getTasksForUser(userId),
      builder: (context, snapshot) {
        if (!_doneTasksLoaded ||
            snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data ?? [];
        if (tasks.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.tasksNoTasks));
        }
        final undoneTasks =
            tasks.where((t) => !_doneTaskIds.contains(t.id)).toList();
        final doneTasks =
            tasks.where((t) => _doneTaskIds.contains(t.id)).toList();
        undoneTasks.sort((a, b) => a.date.compareTo(b.date));
        doneTasks.sort((a, b) => a.date.compareTo(b.date));
        final allTasks = [...undoneTasks, ...doneTasks];
        return ListView.builder(
          itemCount: allTasks.length,
          itemBuilder: (context, index) {
            final task = allTasks[index];
            final isDone = _doneTaskIds.contains(task.id);
            final day = DateFormatter(task.date, context).formatAsDayname();
            final time = TimeOfDay.fromDateTime(task.date).format(context);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(task: task),
                    ),
                  );
                },
                child: ListTile(
                  leading: Checkbox(
                    value: isDone,
                    onChanged: (checked) async {
                      await TaskDataRepository()
                          .setTaskDone(task.id, checked ?? false);
                      setState(() {
                        if (checked ?? false) {
                          _doneTaskIds.add(task.id);
                        } else {
                          _doneTaskIds.remove(task.id);
                        }
                      });
                    },
                  ),
                  title: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone ? Colors.grey : null,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.tasksDayTime(day, time)),
                      if (task.location.isNotEmpty)
                      Text(
                          '${AppLocalizations.of(context)!.tasksLocation}: ${task.location}'),
                      if (task.description.isNotEmpty) Text(task.description),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            );
          },
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
