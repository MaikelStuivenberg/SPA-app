class WeatherCurrent {
  const WeatherCurrent({
    required this.temp,
    required this.feelslike,
    required this.uv,
    required this.conditionIcon,
  });

  final int temp;
  final int feelslike;
  final int uv;
  final String conditionIcon;
}
