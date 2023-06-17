import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spa_app/features/rules/pages/rules_page.dart';
import 'package:spa_app/features/splash/splash.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/unanimated_page_route.dart';

Future<void> main() async {
  // await Data.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const SpaApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SpaApp extends StatelessWidget {
  const SpaApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white, // Color for Android
          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ),
    );

    return MaterialApp(
      title: 'SPA',
      home: const SplashPage(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true
      ),

      onGenerateRoute: (settings) {
        return UnanimatedPageRoute(
          builder: (context) => Routes.routes[settings.name]!(context),
        );
      },
    );
  }
}
