import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spa_app/features/program/models/activity.dart';
import 'package:spa_app/routes.dart';

class Programitem extends StatelessWidget {
  const Programitem({
    required this.activity,
    super.key,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Card(
        elevation: 1,
        // color: isCurrentItem(
        //   activity,
        //   nextActivity,
        //   DateTime.now(),
        // )
        //     ? Colors.blue.shade50
        //     : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: activity.link != null && activity.link!.isNotEmpty
              ? () {
                  Navigator.of(context).pushNamed(
                    Routes.biblestudy,
                    arguments: activity,
                  );
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 4, top: 4),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/program/${activity.image!}',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 75,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      activity.title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                        top: 2,
                      ),
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
                            DateFormat('HH:mm').format(
                              activity.date!,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Row(
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (activity.link != null && activity.link!.isNotEmpty)
                  const FaIcon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
