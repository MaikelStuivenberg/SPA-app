import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/features/program/cubit/program_cubit.dart';
import 'package:spa_app/features/program/models/activity.dart';
import 'package:spa_app/features/program/widget/program_item.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Wait till pageController has clients
    // and then move to page with current date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients &&
          DateTime.now().isAfter(minDate) &&
          DateTime.now().isBefore(maxDate)) {
        _pageController.jumpToPage(DateTime.now().day - minDate.day);
      }
    });

    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.programTitle,
      BlocBuilder<ProgramCubit, ProgramState>(
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
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 36),
                      child: SmoothPageIndicator(
                        controller: _pageController, // PageController
                        count: programState.amountOfDays,
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
      ),
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
                  (user.staff != null &&
                      user.staff!),
            )

            // Only relevant activities for staff
            .where(
              (el) =>
                  el.requirements == null ||
                  !el.requirements!.containsKey('tentLeader') ||
                  el.requirements!['tentLeader'] == false ||
                  (user.tentLeader != null &&
                      user.tentLeader!),
            )

            // Only relevant activities for biblestudy leaders
            .where(
              (el) =>
                  el.requirements == null ||
                  !el.requirements!.containsKey('biblestudyLeader') ||
                  el.requirements!['biblestudyLeader'] == false ||
                  (user.biblestudyLeader != null &&
                      user.biblestudyLeader!),
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

        return SafeArea(
          bottom: false,
          child: Column(
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
