class WeatherForecast {
  WeatherForecast({
    required this.date,
    required this.maxtemp,
    required this.mintemp,
    required this.uv,
    required this.conditionIcon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'] as String,
      maxtemp: (json['day']['maxtemp_c'] as double).round(),
      mintemp: (json['day']['mintemp_c'] as double).round(),
      uv: (json['day']['uv'] as double).round(),
      conditionIcon: 'https:${json['day']['condition']['icon'] as String}',
    );
  }

  final String date;
  final int maxtemp;
  final int mintemp;
  final int uv;
  final String conditionIcon;
}
