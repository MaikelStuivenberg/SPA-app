import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    // Change state of background and logo
    Future.delayed(const Duration(milliseconds: 800), () {
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
      duration: const Duration(milliseconds: 300),
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
                  child: Image.asset('assets/logo.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
