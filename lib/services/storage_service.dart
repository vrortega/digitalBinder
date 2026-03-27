import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}