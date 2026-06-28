import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/ui/core/widgets/card.dart';
import 'package:spa_app/ui/features/home/cubit/weather_cubit.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

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
              child: weatherCurrent == null
                  ? Container()
                  : CardWidget(
                      accentColor: appColors.accent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nu',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            weatherCurrent.temp.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Image.network(weatherCurrent.conditionIcon),
                        ],
                      ),
                      onTap: () => context.push(RoutePaths.weather),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CardWidget(
                accentColor: colorScheme.primary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Vandaag',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      weatherForecast.maxtemp.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Image.network(weatherForecast.conditionIcon),
                  ],
                ),
                onTap: () => context.push(RoutePaths.weather),
              ),
            ),
          ],
        );
      },
    );
  }
}
