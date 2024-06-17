import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/home/cubit/weather_cubit.dart';
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

        final weatherCurrent = state.weather!.current!;
        final weatherForecast = state.weather!.forecast!.first;

        return Row(
          children: [
            Expanded(
              child: CardWidget(
                child: Column(
                  children: [
                    Text('Now', style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      weatherCurrent.temp.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Image.network(weatherCurrent.conditionIcon),
                    // Text('Feels like: ${weather.feelslike}'),
                    // Text('UV: ${weather.uv}'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8), // Add some space between the cards
            Expanded(
              child: CardWidget(
                child: Column(
                  children: [
                    Text('Today', style: Theme.of(context).textTheme.bodyLarge),
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
                    // Text('Feels like: ${weather.feelslike}'),
                    // Text('UV: ${weather.uv}'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
