import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spa_app/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/card.dart';

class UpcomingDaysWidget extends StatefulWidget {
  const UpcomingDaysWidget({super.key});

  @override
  State<UpcomingDaysWidget> createState() => _UpcomingDaysWidgetState();
}

class _UpcomingDaysWidgetState extends State<UpcomingDaysWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        final weatherCurrent = state.weather!.current;

        return Column(
          children: [
            for (final weatherForecast in state.weather!.forecast!)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Card(
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 4, top: 4),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              weatherForecast.conditionIcon,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
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
                                DateFormat('EEEE').format(
                                  DateTime.parse(weatherForecast.date),
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Max: ${weatherForecast.maxtemp}°',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Min: ${weatherForecast.mintemp}°',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${weatherForecast.maxtemp}°',
                              style:
                                  Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
