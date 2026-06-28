class WeatherForecast {
  const WeatherForecast({
    required this.date,
    required this.maxtemp,
    required this.mintemp,
    required this.uv,
    required this.conditionIcon,
    required this.hourFourcast,
  });

  final String date;
  final int maxtemp;
  final int mintemp;
  final int uv;
  final String conditionIcon;
  final List<WeatherHourForecast> hourFourcast;
}

class WeatherHourForecast {
  const WeatherHourForecast({
    required this.time,
    required this.temp,
    required this.conditionIcon,
  });

  final String time;
  final int temp;
  final String conditionIcon;
}
