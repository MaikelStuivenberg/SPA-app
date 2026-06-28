import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/repositories/weather_repository.dart';
import 'package:spa_app/domain/entities/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchCurrentWeather() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final weather = await _weatherRepository.getWeather();
      emit(state.copyWith(isLoading: false, weather: weather));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
