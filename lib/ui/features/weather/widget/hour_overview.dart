import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spa_app/ui/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/ui/core/widgets/card.dart';

class HourOverviewWidget extends StatefulWidget {
  const HourOverviewWidget({super.key});

  @override
  State<HourOverviewWidget> createState() => _HourOverviewWidgetState();
}

class _HourOverviewWidgetState extends State<HourOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        final firstDay = state.weather!.forecast![0];
        final hours = firstDay.hourFourcast
            .where((element) =>
                DateTime.parse(element.time).isAfter(DateTime.now()),)
            .take(12)
            .toList();

        if (hours.length < 12) {
          hours.addAll(
            state.weather!.forecast![1].hourFourcast
                .take(12 - hours.length)
                .toList(),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final hour in hours)
                CardWidget(
                  accentColor: context.appColors.accent,
                  child: Column(
                    children: [
                      Text(
                          DateFormat('HH:00').format(DateTime.parse(hour.time)),
                          style: Theme.of(context).textTheme.bodyLarge,),
                      const SizedBox(height: 4),
                      Text(
                        '${hour.temp}°',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Image.network(hour.conditionIcon),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
