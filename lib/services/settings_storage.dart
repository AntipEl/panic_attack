import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {

  static const _defaultPatternKey = "default_pattern";
  static const _defaultTheme = "dark_theme";

  static Future<void> saveDefaultPattern(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultPatternKey, id);
  }

  static Future<String?> loadDefaultPattern() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultPatternKey);
  }

  static Future<bool?> saveTheme(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_defaultTheme, value);
    return null;
  }

  static Future<bool?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_defaultTheme);
  }
}