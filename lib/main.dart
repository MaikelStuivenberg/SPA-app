import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/splash/splash.dart';
import 'package:spa_app/routes.dart';
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
  });

  await remoteConfig.setDefaults(const {
    'flickr_album_id': '72177720309943266', //
    'flickr_min_upload_date': 1689804000, // Unix timestamp (2023-07-20)
    'flickr_max_upload_date': 1690840800, // Unix timestamp (2023-08-01)
    'show_photos_per_page': 5,
    'start_date': '2023-07-22T10:00:00+01:00',
    'end_date': '2023-07-28T22:00:00+01:00'
  });

  await remoteConfig.fetchAndActivate();

  runApp(const SpaApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SpaApp extends StatelessWidget {
  const SpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Color for Android
        statusBarBrightness:
            Brightness.dark, // Dark == white status bar -- for IOS.
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPA',
      home: const SplashPage(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: AppColors.mainColor),
      ),
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
