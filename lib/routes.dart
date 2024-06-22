import 'package:flutter/material.dart';
import 'package:spa_app/features/auth/pages/login_page.dart';
import 'package:spa_app/features/auth/pages/register_page.dart';
import 'package:spa_app/features/biblestudy/biblestudy.dart';
import 'package:spa_app/features/home/home.dart';
import 'package:spa_app/features/map/pages/map_page.dart';
import 'package:spa_app/features/photos/photos.dart';
import 'package:spa_app/features/program/pages/program.dart';
import 'package:spa_app/features/rules/pages/rules_page.dart';
import 'package:spa_app/features/user/pages/edit_profile_page.dart';
import 'package:spa_app/features/user/pages/user_details_page.dart';
import 'package:spa_app/features/welcome/pages/welcome_page.dart';

class Routes {
  Routes._();

  static const String home = '/home';
  static const String program = '/program';
  static const String biblestudy = '/biblestudy';
  static const String photos = '/photos';
  static const String rules = '/rules';
  static const String map = '/map';
  static const String userDetails = '/user';
  static const String editUser = '/user/edit';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';

  // static const String music = '/music';
  // static const String games = '/games';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => const HomePage(),
    program: (BuildContext context) => const ProgramPage(),
    biblestudy: (BuildContext context) => const BibleStudyPage(),
    photos: (BuildContext context) => const PhotosPage(),
    rules: (BuildContext context) => const RulesPage(),
    map: (BuildContext context) => const MapPage(),
    userDetails: (BuildContext context) => const UserDetailsPage(),
    editUser: (BuildContext context) => const EditProfilePage(),
    welcome: (BuildContext context) => const WelcomePage(),
    login: (BuildContext context) => const LoginPage(),
    register: (BuildContext context) => const RegisterPage(),

    // music: (BuildContext context) => const MusicPage(),
    // games: (BuildContext context) => const GamesPage(),
  };
}
