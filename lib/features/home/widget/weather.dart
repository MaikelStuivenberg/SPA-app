import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/card.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        if (state.weather == null) {
          return Container();
        }

        final weatherCurrent = state.weather!.current;
        final weatherForecast = state.weather!.forecast!.first;

        return Row(
          children: [
            Expanded(
              child: weatherCurrent == null ? Container() : CardWidget(
                child: Column(
                  children: [
                    Text('Nu', style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      weatherCurrent.temp.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Image.network(weatherCurrent.conditionIcon),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, Routes.weather),
              ),
            ),
            const SizedBox(width: 8), // Add some space between the cards
            Expanded(
              child: CardWidget(
                child: Column(
                  children: [
                    Text(
                      'Vandaag',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weatherForecast.maxtemp.toString(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    Image.network(weatherForecast.conditionIcon),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, Routes.weather),
              ),
            ),
          ],
        );
      },
    );
  }
}
