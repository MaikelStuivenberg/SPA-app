import 'package:get_it/get_it.dart';
import 'package:spa_app/data/repositories/bible_study_repository_impl.dart';
import 'package:spa_app/data/repositories/photo_repository_impl.dart';
import 'package:spa_app/data/repositories/program_repository_impl.dart';
import 'package:spa_app/data/repositories/task_repository_impl.dart';
import 'package:spa_app/data/repositories/user_repository_impl.dart';
import 'package:spa_app/data/repositories/weather_repository_impl.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/data/services/flickr_api_client.dart';
import 'package:spa_app/data/services/photo_file_service.dart';
import 'package:spa_app/data/services/preferences_service.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/data/services/weather_api_client.dart';
import 'package:spa_app/domain/repositories/bible_study_repository.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';
import 'package:spa_app/domain/repositories/program_repository.dart';
import 'package:spa_app/domain/repositories/task_repository.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/domain/repositories/weather_repository.dart';
import 'package:spa_app/domain/use_cases/get_home_dashboard_use_case.dart';
import 'package:spa_app/domain/use_cases/get_program_schedule_use_case.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/biblestudy/cubit/bible_study_cubit.dart';
import 'package:spa_app/ui/features/home/cubit/home_cubit.dart';
import 'package:spa_app/ui/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/ui/features/program/cubit/program_cubit.dart';
import 'package:spa_app/ui/features/tasks/cubit/tasks_cubit.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';

final getIt = GetIt.I;

class Injection {
  static void setup() {
    getIt
      ..registerLazySingleton<AuthService>(FirebaseAuthService.new)
      ..registerLazySingleton<RemoteConfigService>(
        FirebaseRemoteConfigService.new,
      )
      ..registerLazySingleton<PreferencesService>(
        SharedPreferencesService.new,
      )
      ..registerLazySingleton(WeatherApiClient.new)
      ..registerLazySingleton(FlickrApiClient.new)
      ..registerLazySingleton(PhotoFileService.new)
      ..registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(authService: getIt()),
      )
      ..registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(
          userRepository: getIt(),
          preferencesService: getIt(),
          remoteConfigService: getIt(),
        ),
      )
      ..registerLazySingleton<ProgramRepository>(ProgramRepositoryImpl.new)
      ..registerLazySingleton<PhotoRepository>(
        () => PhotoRepositoryImpl(
          userRepository: getIt(),
          remoteConfigService: getIt(),
          flickrApiClient: getIt(),
        ),
      )
      ..registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(weatherApiClient: getIt()),
      )
      ..registerLazySingleton<BibleStudyRepository>(
        BibleStudyRepositoryImpl.new,
      )
      ..registerLazySingleton(
        () => GetHomeDashboardUseCase(
          userRepository: getIt(),
          remoteConfigService: getIt(),
        ),
      )
      ..registerLazySingleton(
        () => GetProgramScheduleUseCase(
          programRepository: getIt(),
          remoteConfigService: getIt(),
        ),
      )
      ..registerFactory(
        () => AuthCubit(
          authService: getIt(),
          userRepository: getIt(),
        ),
      )
      ..registerFactory(
        () => WeatherCubit(weatherRepository: getIt()),
      )
      ..registerFactory(
        () => AlbumsCubit(photoRepository: getIt()),
      )
      ..registerFactoryParam<PhotosCubit, String, void>(
        (albumId, _) => PhotosCubit(
          photoRepository: getIt(),
          albumId: albumId,
        ),
      )
      ..registerFactory(
        () => ProgramCubit(getProgramScheduleUseCase: getIt()),
      )
      ..registerFactory(
        () => HomeCubit(getHomeDashboardUseCase: getIt()),
      )
      ..registerFactory(
        () => TasksCubit(taskRepository: getIt()),
      )
      ..registerFactory(
        () => BibleStudyCubit(bibleStudyRepository: getIt()),
      )
      ..registerFactory(
        () => UserProfileCubit(
          userRepository: getIt(),
          photoRepository: getIt(),
        ),
      );
  }
}
