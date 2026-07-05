import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/ui/features/program/models/activity.dart';

class Programitem extends StatelessWidget {
  const Programitem({
    required this.activity,
    required this.isCurrent,
    required this.isPast,
    this.isFirst = false,
    super.key,
  });

  final Activity activity;
  final bool isCurrent;
  final bool isPast;
  final bool isFirst;

  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(_radius);
    final backgroundColor = isCurrent
        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
        : isPast
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceBright;

    return Padding(
      padding: EdgeInsets.only(bottom: 4, top: isFirst ? 0 : 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: activity.link != null && activity.link!.isNotEmpty
              ? () => context.push(RoutePaths.biblestudy)
              : null,
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: context.appColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          activity.title!,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                              const SizedBox(width: 10)
                            else
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                              ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                            ),
                            Expanded(
                              child: Text(
                                activity.location ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
