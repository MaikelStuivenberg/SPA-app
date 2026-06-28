import 'package:spa_app/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather();
}
