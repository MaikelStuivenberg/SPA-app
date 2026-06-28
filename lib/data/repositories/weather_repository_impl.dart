import 'package:spa_app/data/services/weather_api_client.dart';
import 'package:spa_app/domain/repositories/weather_repository.dart';
import 'package:spa_app/domain/entities/weather.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({required WeatherApiClient weatherApiClient})
      : _weatherApiClient = weatherApiClient;

  final WeatherApiClient _weatherApiClient;

  @override
  Future<Weather> getWeather() => _weatherApiClient.fetchForecast();
}
