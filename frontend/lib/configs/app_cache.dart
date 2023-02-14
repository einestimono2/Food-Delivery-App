import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static String getString(String key) => _prefs?.getString(key) ?? "";

  static void setString({required String key, required String value}) {
    if (value.isEmpty || key.isEmpty) return;
    _prefs?.setString(key, value);
  }

  static Future<void> removeString(String key) async {
    await _prefs?.remove(key);
  }
}
