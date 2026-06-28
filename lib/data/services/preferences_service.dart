import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesService {
  Future<Set<String>> getStringSet(String key);
  Future<void> setStringSet(String key, Set<String> values);
}

class SharedPreferencesService implements PreferencesService {
  @override
  Future<Set<String>> getStringSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key)?.toSet() ?? {};
  }

  @override
  Future<void> setStringSet(String key, Set<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values.toList());
  }
}
