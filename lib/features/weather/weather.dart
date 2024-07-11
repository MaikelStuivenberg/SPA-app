import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/weather/widget/hour_overview.dart';
import 'package:spa_app/features/weather/widget/upcoming_days.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.weatherTitle,
      _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weatherUpcomingHours,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const HourOverviewWidget(),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.weatherUpcomingDays,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const UpcomingDaysWidget(),
          ],
        ),
      ),
    );
  }
}
