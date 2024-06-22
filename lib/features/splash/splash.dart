import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
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
    Future.delayed(const Duration(milliseconds: 1000), () async {
      setState(() {
        _visible = !_visible;
      });
    });

    // After 1000ms, go to login/program page
    Future.delayed(const Duration(milliseconds: 1000), () async {
      final autoLogin =
          await BlocProvider.of<AuthCubit>(context).tryAutoLogin();

      if (!mounted) return;

      if (autoLogin) {
        await Navigator.of(context).pushReplacementNamed(Routes.home);
      } else {
        await Navigator.of(context).pushReplacementNamed(Routes.login);
      }
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
            child: SizedBox(
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
