import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigService {
  String getString(String key);
  int getInt(String key);
  bool getBool(String key);
}

class FirebaseRemoteConfigService implements RemoteConfigService {
  FirebaseRemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  @override
  String getString(String key) => _remoteConfig.getString(key);

  @override
  int getInt(String key) => _remoteConfig.getInt(key);

  @override
  bool getBool(String key) => _remoteConfig.getBool(key);
}
