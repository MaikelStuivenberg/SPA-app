import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/home/cubit/weather_cubit.dart';
import 'package:spa_app/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/features/splash/splash.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/unanimated_page_route.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // Define your state variables here

  @override
  Widget build(BuildContext context) {
    // Define your view here
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WeatherCubit()..fetchCurrentWeather(),
        ),
        BlocProvider(
          create: (_) => PhotosCubit()..fetchLastPhotos(),
        ),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    const colorSchemeLight = ColorScheme.light(
      primary: AppColors.mainColor,
      secondary: AppColors.secondaryColor,
    );

    const colorSchemeDark = ColorScheme.dark(
      primary: AppColors.mainColor,
      secondary: AppColors.secondaryColor,
    );

    final spaThemeLight = ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeLight,
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      dividerColor: AppColors.mainColor.shade200,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 28,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.mainColor,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color.fromARGB(255, 240, 246, 246),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor.shade500,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 36),
        ),
      ),
      iconTheme: IconThemeData(color: colorSchemeDark.primary),
    );

    final spaThemeDark = ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeDark,
      brightness: Brightness.dark,
      fontFamily: 'Montserrat',
      dividerColor: AppColors.mainColor.shade800,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 28,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: AppColors.mainColor.shade900,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor.shade900,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 36),
        ),
      ),
      iconTheme: IconThemeData(color: colorSchemeDark.primary),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPA',
      home: const SplashPage(),
      navigatorKey: navigatorKey,
      theme: spaThemeLight,
      darkTheme: spaThemeDark,
      // themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        return UnanimatedPageRoute(
          builder: (context) => Routes.routes[settings.name]!(context),
        );
      },
    );
  }
}
