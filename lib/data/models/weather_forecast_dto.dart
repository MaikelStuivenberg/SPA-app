import 'package:spa_app/domain/entities/weather_forecast.dart';

class WeatherForecastDto {
  WeatherForecastDto({
    required this.date,
    required this.maxtemp,
    required this.mintemp,
    required this.uv,
    required this.conditionIcon,
    required this.hourFourcast,
  });

  factory WeatherForecastDto.fromJson(Map<String, dynamic> json) {
    return WeatherForecastDto(
      date: json['date'] as String,
      maxtemp: (json['day']['maxtemp_c'] as num).round(),
      mintemp: (json['day']['mintemp_c'] as num).round(),
      uv: (json['day']['uv'] as num).round(),
      conditionIcon: 'https:${json['day']['condition']['icon'] as String}',
      hourFourcast: (json['hour'] as List<dynamic>)
          .map(
            (e) => WeatherHourForecastDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String date;
  final int maxtemp;
  final int mintemp;
  final int uv;
  final String conditionIcon;
  final List<WeatherHourForecastDto> hourFourcast;

  WeatherForecast toEntity() {
    return WeatherForecast(
      date: date,
      maxtemp: maxtemp,
      mintemp: mintemp,
      uv: uv,
      conditionIcon: conditionIcon,
      hourFourcast: hourFourcast.map((e) => e.toEntity()).toList(),
    );
  }
}

class WeatherHourForecastDto {
  WeatherHourForecastDto({
    required this.time,
    required this.temp,
    required this.conditionIcon,
  });

  factory WeatherHourForecastDto.fromJson(Map<String, dynamic> json) {
    return WeatherHourForecastDto(
      time: json['time'] as String,
      temp: (json['temp_c'] as num).round(),
      conditionIcon: 'https:${json['condition']['icon'] as String}',
    );
  }

  final String time;
  final int temp;
  final String conditionIcon;

  WeatherHourForecast toEntity() {
    return WeatherHourForecast(
      time: time,
      temp: temp,
      conditionIcon: conditionIcon,
    );
  }
}
