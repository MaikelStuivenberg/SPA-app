import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
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
          )
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
          const Center(
            child: Text(
              'Programma',
              style: Styles.pageTitle,
            ),
          ),
          Center(
            child: Text(
              DateFormatter(dateTime).formatAsDayname(),
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
                    return const Text('Loading');
                  }
                  user = snapshot.data![1] as User;
                  /** Convert FirebaseStoreDocs to Activity*/
                  activities =
                      (snapshot.data![0] as QuerySnapshot<Map<String, dynamic>>)
                          .docs
                          .map<Activity>(Activity.createFromDoc)
                          /** Filter on current day */
                          .where(
                            (el) =>
                                el.date!.toDate().isAfter(dateTime) &&
                                el.date!.toDate().isBefore(
                                      dateTime.add(const Duration(days: 1)),
                                    ),
                          )
                          /** Only show relevant majors */
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.major == null ||
                                !el.requirements!.containsKey('major') ||
                                (el.requirements!.containsKey('major') &&
                                    el.requirements!['major'] == user.major),
                          )

                          /** Only show relevant minors */
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.minor == null ||
                                !el.requirements!.containsKey('minor') ||
                                (el.requirements!.containsKey('minor') &&
                                    el.requirements!['minor'] == user.minor),
                          )

                          /** Filter on age <13 */
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.age == null ||
                                !el.requirements!.containsKey('age') ||
                                el.requirements!['age'] != '<13' ||
                                (int.tryParse(user.age!) != null &&
                                    int.tryParse(user.age!)! < 13),
                          )

                          /** Filter on age >=13 */
                          .where(
                            (el) =>
                                el.requirements == null ||
                                user.age == null ||
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
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final activity = activities[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                          style: Styles.textStyleMedium),
                                    ],
                                  ),
                                ),
                                Text(activity.title!,
                                    style: Styles.textStyleLarge),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2, top: 3),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 18,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                      ),
                                      Text('${activity.location}',
                                          style: Styles.textStyleMedium),
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

  // Widget _buildWeatherWidget() {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 600),
  //     curve: Curves.decelerate,
  //     width: double.infinity,
  //     height: _weatherOpen ? 260 : 130,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(width: 0), // Set border width
  //       borderRadius: const BorderRadius.all(
  //         Radius.circular(20),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.5),
  //           spreadRadius: 2,
  //           blurRadius: 5,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: const SafeArea(
  //       child: Padding(
  //         padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
  //         child: Row(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //               child: Icon(
  //                 Icons.sunny,
  //                 color: Colors.yellow,
  //               ),
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   '22 Juli',
  //                   style: Styles.weatherDate,
  //                 ),
  //                 Text(
  //                   '23º',
  //                   style: Styles.weatherCelcius,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
