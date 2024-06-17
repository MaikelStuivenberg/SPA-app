import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/app/app.dart';
import 'package:spa_app/app/injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  Injection.setup();

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
    'start_date': '2024-07-20T07:00:00+01:00',
    'end_date': '2024-07-26T23:00:00+01:00',
    'use_minor': true,
  });

  await remoteConfig.fetchAndActivate();

  runApp(const App());
}
