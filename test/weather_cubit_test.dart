import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spa_app/domain/repositories/weather_repository.dart';
import 'package:spa_app/domain/entities/weather.dart';
import 'package:spa_app/domain/entities/weather_current.dart';
import 'package:spa_app/ui/features/home/cubit/weather_cubit.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository weatherRepository;

  setUp(() {
    weatherRepository = MockWeatherRepository();
  });

  blocTest<WeatherCubit, WeatherState>(
    'loads weather successfully',
    build: () {
      when(() => weatherRepository.getWeather()).thenAnswer(
        (_) async => Weather(
          current: WeatherCurrent(
            temp: 20,
            feelslike: 19,
            uv: 5,
            conditionIcon: 'https://example.com/icon.png',
          ),
        ),
      );
      return WeatherCubit(weatherRepository: weatherRepository);
    },
    act: (cubit) => cubit.fetchCurrentWeather(),
    expect: () => [
      isA<WeatherState>().having((s) => s.isLoading, 'loading', true),
      isA<WeatherState>()
          .having((s) => s.isLoading, 'loading', false)
          .having((s) => s.weather?.current?.temp, 'temp', 20),
    ],
  );
}
