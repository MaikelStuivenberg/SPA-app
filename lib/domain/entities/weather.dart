import 'package:spa_app/domain/entities/weather_current.dart';
import 'package:spa_app/domain/entities/weather_forecast.dart';

class Weather {
  const Weather({this.current, this.forecast});

  final WeatherCurrent? current;
  final List<WeatherForecast>? forecast;
}
