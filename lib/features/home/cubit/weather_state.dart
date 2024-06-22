part of 'weather_cubit.dart';

class WeatherState {
  WeatherState({
    this.isLoading = false,
    this.weather,
  });

  final bool isLoading;
  final Weather? weather;

  WeatherState copyWith({
    bool? isLoading,
    Weather? weather,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
    );
  }
}
