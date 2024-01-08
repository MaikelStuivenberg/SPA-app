import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/program_data.dart';
import 'package:spa_app/utils/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool _visible = true;
  late Future preloadProgram;

  @override
  void initState() {
    super.initState();

    preloadProgram = ProgramDataRepository().getProgram();

    // Change state of background and logo
    Future.delayed(const Duration(milliseconds: 800), () async {
      await preloadProgram;
      setState(() {
        _visible = !_visible;
      });
    });

    // After 1000ms, go to login/program page
    Future.delayed(const Duration(milliseconds: 1000), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(Routes.program);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }

      // SharedPreferences.getInstance().then((prefs) {
      // if (prefs.getBool('isFirstTime') == null) {
      //   prefs.setBool('isFirstTime', false);
      //   Navigator.of(context).pushReplacementNamed(Routes.userDetails);
      // } else {
      //   Navigator.of(context).pushReplacementNamed(Routes.program);
      // }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              'assets/background-nyp.jpg',
              height: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset('assets/logo/SPA Logo Tagline.png'),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.width * 0.90,
              child: SpinKitRing(
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.90,
                lineWidth: 2,
                duration: const Duration(milliseconds: 2000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
