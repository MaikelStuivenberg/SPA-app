import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/shared/models/weather.dart';
import 'package:spa_app/shared/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState());

  Future<void> fetchCurrentWeather() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final weatherRepository = getIt.get<WeatherRepository>();
      final weather = await weatherRepository.getWeather();

      emit(state.copyWith(isLoading: false, weather: weather));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
