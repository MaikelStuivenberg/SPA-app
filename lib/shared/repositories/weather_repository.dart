import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spa_app/shared/models/weather.dart';
import 'package:spa_app/shared/models/weather_current.dart';
import 'package:spa_app/shared/models/weather_forecast.dart';

class WeatherRepository {
  final baseUrl = 'http://api.weatherapi.com/v1';

  Future<Weather> getWeather() async {
    // Fetch weather data from the API
    var url = '$baseUrl/forecast.json';
    url += '?key=bdc5cfb06e9b4c4da4c125836241606';
    url += '&q=Lunteren,Gelderland,Netherlands';
    url += '&days=5';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final parsed = jsonDecode(response.body) as Map<String, dynamic>;
      
      final current =
      (parsed['current'] as Map<String, dynamic>).isEmpty ? null : 
          WeatherCurrent.fromJson(parsed['current'] as Map<String, dynamic>);
      final forecast = (parsed['forecast']['forecastday'] as List<dynamic>)
          .map((e) => WeatherForecast.fromJson(e as Map<String, dynamic>))
          .toList();

      return Weather(current: current, forecast: forecast);
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load weather');
    }
  }
}
