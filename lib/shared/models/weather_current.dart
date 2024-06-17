class WeatherCurrent {
  WeatherCurrent({
    required this.temp,
    required this.feelslike,
    required this.uv,
    required this.conditionIcon,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) {
    return WeatherCurrent(
      temp: (json['temp_c'] as double).round(),
      feelslike: (json['feelslike_c'] as double).round(),
      uv: (json['uv'] as double).round(),
      conditionIcon: 'https:${json['condition']['icon'] as String}',
    );
  }

  final int temp;
  final int feelslike;
  final int uv;
  final String conditionIcon;
}
