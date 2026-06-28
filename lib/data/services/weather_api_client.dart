import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spa_app/core/config/environment.dart';
import 'package:spa_app/data/models/weather_current_dto.dart';
import 'package:spa_app/data/models/weather_forecast_dto.dart';
import 'package:spa_app/domain/entities/weather.dart';

class WeatherApiClient {
  WeatherApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'http://api.weatherapi.com/v1';

  Future<Weather> fetchForecast() async {
    final url = Uri.parse(
      '$_baseUrl/forecast.json'
      '?key=${Environment.weatherApiKey}'
      '&q=Lunteren,Gelderland,Netherlands'
      '&days=5',
    );

    final response = await _client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather');
    }

    final parsed = jsonDecode(response.body) as Map<String, dynamic>;
    final currentJson = parsed['current'] as Map<String, dynamic>;
    final current = currentJson.isEmpty
        ? null
        : WeatherCurrentDto.fromJson(currentJson).toEntity();
    final forecast = (parsed['forecast']['forecastday'] as List<dynamic>)
        .map(
          (e) => WeatherForecastDto.fromJson(e as Map<String, dynamic>)
              .toEntity(),
        )
        .toList();

    return Weather(current: current, forecast: forecast);
  }
}
