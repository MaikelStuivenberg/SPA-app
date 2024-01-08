import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/splash/splash.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/app_bar_shape.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/unanimated_page_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  remoteConfig.onConfigUpdated.listen((event) async {
    if (kDebugMode) {
      print('Remote config updated!');
    }

    await remoteConfig.activate();
  });

  await remoteConfig.setDefaults(const {
    'flickr_album_id': '72177720309943266', //
    'flickr_min_upload_date': 1689804000, // Unix timestamp (2023-07-20)
    'flickr_max_upload_date': 1690840800, // Unix timestamp (2023-08-01)
    'show_photos_per_page': 5,
    'start_date': '2024-01-20T07:00:00+01:00',
    'end_date': '2024-01-20T23:00:00+01:00',
    'use_minor': false,
  });

  await remoteConfig.fetchAndActivate();

  runApp(const SpaApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SpaApp extends StatelessWidget {
  const SpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = ColorScheme.light(
      primary: AppColors.mainColor,
      secondary: AppColors.secondaryColor,
    );
    
    final colorSchemeDark = ColorScheme.dark(
      primary: AppColors.mainColor,
      secondary: AppColors.secondaryColor,
    );

    final spaThemeLight = ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeLight,
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      dividerColor: AppColors.mainColor.shade200,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 28,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.mainColor,
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

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: Colors.transparent, // Color for Android
    //     statusBarBrightness:
    //         Brightness.dark, // Dark == white status bar -- for IOS.
    //   ),
    // );

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
