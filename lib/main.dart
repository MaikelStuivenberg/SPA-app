import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/app/app.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Injection.setup();

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 30),
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
    'flickr_min_upload_date': 1689804000, // Unix timestamp (2023-07-20)
    'flickr_max_upload_date': 1690840800, // Unix timestamp (2023-08-01)
    'show_photos_per_page': 8,
    'start_date': '2026-01-17T01:00:00+01:00',
    'end_date': '2026-01-17T23:59:00+01:00',
    'use_minor': true,
    'countdown_date': '2026-01-17T09:00:00+01:00', // Default countdown date
    'countdown_event': 'SPA Pre Party 2026',
  });

  await remoteConfig.fetchAndActivate();

  runApp(const App());
}
