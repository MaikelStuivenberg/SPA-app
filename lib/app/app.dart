import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/core/router/app_router.dart';
import 'package:spa_app/core/theme/app_theme.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/home/cubit/home_cubit.dart';
import 'package:spa_app/ui/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';
import 'package:spa_app/ui/features/program/cubit/program_cubit.dart';
import 'package:spa_app/ui/features/tasks/cubit/tasks_cubit.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _router = createAppRouter(_authCubit, getIt<AuthService>());
  }

  @override
  void dispose() {
    _router.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider(
          create: (_) => getIt<WeatherCubit>()..fetchCurrentWeather(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => getIt<AlbumsCubit>()..fetchAlbums(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => getIt<ProgramCubit>()..fetchProgram(),
          lazy: false,
        ),
        BlocProvider(create: (_) => getIt<HomeCubit>()),
        BlocProvider(create: (_) => getIt<TasksCubit>()..loadDoneTaskIds()),
        BlocProvider(create: (_) => getIt<UserProfileCubit>()),
      ],
      child: AppView(router: _router),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SPA',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
