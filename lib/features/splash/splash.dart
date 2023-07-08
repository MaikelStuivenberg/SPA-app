import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // After 1000ms, go to program page
    Timer(const Duration(milliseconds: 1000), () {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool('isFirstTime') == null) {
          prefs.setBool('isFirstTime', false);
          Navigator.of(context).pushReplacementNamed(Routes.welcome);
        } else {
          Navigator.of(context).pushReplacementNamed(Routes.program);
        }
      });
    });

    return _buildBody();
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Image.asset(
            'assets/background.jpg',
            height: double.infinity,
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/logo.png'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
