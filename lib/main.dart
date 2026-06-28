import 'package:flutter/material.dart';
import 'package:spa_app/app/app.dart';
import 'package:spa_app/app/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const App());
}
