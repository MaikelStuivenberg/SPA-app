import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_app/features/program/models/activity.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/date_formatter.dart';
import 'package:spa_app/utils/styles.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  ProgramPageState createState() => ProgramPageState();
}

class ProgramPageState extends State<ProgramPage> {
  // final bool _weatherOpen = false;
  final PageController _pageController = PageController();
  final ScrollController _listViewController = ScrollController();

  late Future<QuerySnapshot<Map<String, dynamic>>> programDocsFuture;
  late Future<User> userDataFuture;

  @override
  void initState() {
    super.initState();

    programDocsFuture = FirebaseFirestore.instance.collection('program').get();
    userDataFuture = UserDataRepository().getUser();
  }

  @override
  Widget build(BuildContext context) {
    // Wait till pageController has clients
    // and then move to page with current date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(DateTime.now().day - 22);
      }
    });

    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.programTitle,
      Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildProgramWidget(DateTime(2023, 7, 22)),
                    _buildProgramWidget(DateTime(2023, 7, 23)),
                    _buildProgramWidget(DateTime(2023, 7, 24)),
                    _buildProgramWidget(DateTime(2023, 7, 25)),
                    _buildProgramWidget(DateTime(2023, 7, 26)),
                    _buildProgramWidget(DateTime(2023, 7, 27)),
                    _buildProgramWidget(DateTime(2023, 7, 28)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: SmoothPageIndicator(
                  controller: _pageController, // PageController
                  count: 7,
                  effect: const WormEffect(
                    dotColor: AppColors.mainColor,
                    activeDotColor: AppColors.buttonColor,
                    dotHeight: 8,
                  ), // your preferred effect
                  onDotClicked: (index) {},
                ),
              ),
            ],
          ),
          // _buildWeatherWidget(),
        ],
      ),
    );
  }

  Widget _buildProgramWidget(DateTime dateTime) {
    var activities = <Activity>[];
    var user = User();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              DateFormatter(dateTime, context).formatAsDayname(),
              style: Styles.pageSubTitle,
            ),
          ),
          Container(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: FutureBuilder(
                future: Future.wait([
                  programDocsFuture,
                  userDataFuture,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text(AppLocalizations.of(context)!.loading);
                  }
                  user = snapshot.data![1] as User;
                  // Convert FirebaseStoreDocs to Activity
                  activities =
                      (snapshot.data![0] as QuerySnapshot<Map<String, dynamic>>)
                          .docs
                          .map<Activity>(Activity.createFromDoc)

                          // Filter out activities without date
                          .where((el) => el.date != null)

                          // Filter on current day
                          .where(
                            (el) =>
                                el.date!.toDate().isAfter(dateTime) &&
                                el.date!.toDate().isBefore(
                                      dateTime.add(const Duration(days: 1)),
                                    ),
                          )
                          // Only show relevant majors
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.major == null ||
                                !el.requirements!.containsKey('major') ||
                                (el.requirements!.containsKey('major') &&
                                    el.requirements!['major'] == user.major),
                          )

                          // Only show relevant minors
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.minor == null ||
                                !el.requirements!.containsKey('minor') ||
                                (el.requirements!.containsKey('minor') &&
                                    el.requirements!['minor'] == user.minor),
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
                          .toList()
                        ..sort(
                          (a, b) => a.date!.millisecondsSinceEpoch >
                                  b.date!.millisecondsSinceEpoch
                              ? 1
                              : -1,
                        );

                  return ListView.builder(
                    controller: _listViewController,
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final activity = activities[index];
                      final nextActivity = index + 1 < activities.length
                          ? activities[index + 1]
                          : null;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        height: 95,
                        decoration: BoxDecoration(
                          color: (nextActivity != null &&
                                      nextActivity.date!
                                          .toDate()
                                          .isBefore(DateTime.now())) ||
                                  (nextActivity == null &&
                                      activity.date!
                                          .toDate()
                                          .add(const Duration(minutes: 30))
                                          .isBefore(DateTime.now()))
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/program/${activity.image!}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule_outlined,
                                        size: 18,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                      ),
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(activity.date!.toDate()),
                                        style: Styles.textStyleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  activity.title!,
                                  style: Styles.textStyleLarge,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      if (activity.location == null ||
                                          activity.location!.trim().isEmpty)
                                        Container(
                                          width: 10,
                                        )
                                      else
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                        ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                      ),
                                      Text(
                                        activity.location ?? '',
                                        style: Styles.textStyleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isCurrentItem(
    Activity activity,
    Activity? nextActivity,
    DateTime currentTime,
  ) {
    return activity.date!.toDate().isBefore(currentTime) &&
        nextActivity != null &&
        nextActivity.date!.toDate().isAfter(currentTime);
  }
}
