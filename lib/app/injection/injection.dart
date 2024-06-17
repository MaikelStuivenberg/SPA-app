import 'package:get_it/get_it.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';
import 'package:spa_app/shared/repositories/program_data.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/repositories/weather_repository.dart';

final getIt = GetIt.I;

class Injection {
  static void setup() {
    getIt
      ..registerSingleton<WeatherRepository>(WeatherRepository())
      ..registerSingleton<UserDataRepository>(UserDataRepository())
      ..registerSingleton<ProgramDataRepository>(ProgramDataRepository())
      ..registerSingleton<PhotoDataRepository>(PhotoDataRepository());
  }
}
