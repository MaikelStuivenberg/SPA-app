import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/splash/splash.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/unanimated_page_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

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
      theme: ThemeData(useMaterial3: true),
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
