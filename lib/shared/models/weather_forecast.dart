class WeatherForecast {
  WeatherForecast({
    required this.date,
    required this.maxtemp,
    required this.mintemp,
    required this.uv,
    required this.conditionIcon,
    required this.hourFourcast,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'] as String,
      maxtemp: (json['day']['maxtemp_c'] as double).round(),
      mintemp: (json['day']['mintemp_c'] as double).round(),
      uv: (json['day']['uv'] as double).round(),
      conditionIcon: 'https:${json['day']['condition']['icon'] as String}',
      hourFourcast: (json['hour'] as List<dynamic>)
          .map((e) => WeatherHourForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String date;
  final int maxtemp;
  final int mintemp;
  final int uv;
  final String conditionIcon;
  final List<WeatherHourForecast> hourFourcast;
}

class WeatherHourForecast {
  WeatherHourForecast({
    required this.time,
    required this.temp,
    required this.conditionIcon,
  });

  factory WeatherHourForecast.fromJson(Map<String, dynamic> json) {
    return WeatherHourForecast(
      time: json['time'] as String,
      temp: (json['temp_c'] as double).round(),
      conditionIcon: 'https:${json['condition']['icon'] as String}',
    );
  }

  final String time;
  final int temp;
  final String conditionIcon;
}
