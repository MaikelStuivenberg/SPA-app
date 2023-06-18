import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/features/biblestudy/models/biblestudy.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/date_formatter.dart';
import 'package:spa_app/utils/styles.dart';

class BibleStudyPage extends StatefulWidget {
  const BibleStudyPage({super.key});

  @override
  BibleStudyPageState createState() => BibleStudyPageState();
}

class BibleStudyPageState extends State<BibleStudyPage> {
  late Future<QuerySnapshot<Map<String, dynamic>>> biblestudyFuture;
  List<Biblestudy> biblestudies = [];

  @override
  void initState() {
    super.initState();
    biblestudyFuture =
        FirebaseFirestore.instance.collection('biblestudy').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      PageView(
        children: [
          _buildBiblestudyWidget(DateTime(2023, 7, 22)),
          _buildBiblestudyWidget(DateTime(2023, 7, 23)),
          _buildBiblestudyWidget(DateTime(2023, 7, 24)),
          _buildBiblestudyWidget(DateTime(2023, 7, 25)),
          _buildBiblestudyWidget(DateTime(2023, 7, 26)),
          _buildBiblestudyWidget(DateTime(2023, 7, 27)),
          _buildBiblestudyWidget(DateTime(2023, 7, 28)),
        ],
      ),
    );
  }

  Widget _buildBiblestudyWidget(DateTime dateTime) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Bijbelstudie',
                style: Styles.pageTitle,
              ),
            ),
            Center(
              child: Text(
                DateFormatter(dateTime, context).formatAsDayname(),
                style: Styles.pageSubTitle,
              ),
            ),
            Container(height: 10),
            Expanded(
              child: FutureBuilder(
                future: biblestudyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Text('Loading');
                  }

                  /** Convert FirebaseStoreDocs to Activity
                   * and Filter on current date */
                  biblestudies = snapshot.data!.docs
                      .map<Biblestudy>(Biblestudy.createFromDoc)
                      .where(
                        (el) =>
                            el.date!.toDate().isAfter(dateTime) &&
                            el.date!.toDate().isBefore(
                                  dateTime.add(const Duration(days: 1)),
                                ),
                      )
                      .toList()
                    ..sort(
                      (a, b) => a.date!.millisecondsSinceEpoch >
                              b.date!.millisecondsSinceEpoch
                          ? 1
                          : -1,
                    );

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i = 0; i < biblestudies.length; i++)
                          _buildElement(i)
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElement(int rowNr) {
    const color = Colors.white;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      width: double.infinity,
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              // Number
              Container(
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                width: 35,
                height: 35,
                child: Center(
                  child: Text(
                    (rowNr + 1).toString(),
                    style: Styles.textNumber,
                  ),
                ),
              ),

              // Right part
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Text(
                    biblestudies[rowNr].title!,
                    style: Styles.textTitleStyle,
                  ),
                  //Subtitle
                  Text(
                    biblestudies[rowNr].tagline!,
                    style: Styles.textSubTitleStyle,
                  ),
                ],
              )
            ],
          ),
          // Content
          Text(
            biblestudies[rowNr].content!,
            style: Styles.textStyle,
          ),
        ],
      ),
    );
  }
}
