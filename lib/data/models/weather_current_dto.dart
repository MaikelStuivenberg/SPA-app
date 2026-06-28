import 'package:spa_app/domain/entities/weather_current.dart';

class WeatherCurrentDto {
  WeatherCurrentDto({
    required this.temp,
    required this.feelslike,
    required this.uv,
    required this.conditionIcon,
  });

  factory WeatherCurrentDto.fromJson(Map<String, dynamic> json) {
    return WeatherCurrentDto(
      temp: (json['temp_c'] as num).round(),
      feelslike: (json['feelslike_c'] as num).round(),
      uv: (json['uv'] as num).round(),
      conditionIcon: 'https:${json['condition']['icon'] as String}',
    );
  }

  final int temp;
  final int feelslike;
  final int uv;
  final String conditionIcon;

  WeatherCurrent toEntity() {
    return WeatherCurrent(
      temp: temp,
      feelslike: feelslike,
      uv: uv,
      conditionIcon: conditionIcon,
    );
  }
}
