import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static Future restore(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.get(key) ?? null);
  }

  static save(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
  }
}