import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/firebase_options.dart';

Future<void> bootstrap() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Injection.setup();
  await _configureRemoteConfig();
}

Future<void> _configureRemoteConfig() async {
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
    'flickr_min_upload_date': 1689804000,
    'flickr_max_upload_date': 1690840800,
    'flickr_albums':
        '[{"id":"72177720331523846","title":"SPA NYP 2026"},{"id":"72177720327684878","title":"SPA 2025"},{"id":"72177720323423534","title":"SPA NYP 2025"},{"id":"72177720318968222","title":"SPA 2024"},{"id":"72177720314200521","title":"SPA NYP 2024"},{"id":"72177720309943266","title":"SPA 2023"},{"id":"72177720300776159","title":"SPA 2022"}]',
    'show_photos_per_page': 8,
    'start_date': '2026-01-17T01:00:00+01:00',
    'end_date': '2026-01-17T23:59:00+01:00',
    'use_minor': true,
    'countdown_date': '2026-01-17T09:00:00+01:00',
    'countdown_event': 'SPA Pre Party 2026',
  });

  await remoteConfig.fetchAndActivate();
}
