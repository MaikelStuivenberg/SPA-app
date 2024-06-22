import 'package:spa_app/shared/models/weather_current.dart';
import 'package:spa_app/shared/models/weather_forecast.dart';

class Weather {
  Weather({this.current, this.forecast});

  WeatherCurrent? current;
  List<WeatherForecast>? forecast;
}
