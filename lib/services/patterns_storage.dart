import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breathing_pattern.dart';

class PatternsStorage {

  static const _key = "user_patterns";

  static Future<List<BreathingPattern>> loadPatterns() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List list = jsonDecode(jsonString);

    return list
        .map((e) => BreathingPattern.fromJson(e))
        .toList();
  }

  static Future<void> savePatterns(
      List<BreathingPattern> patterns) async {

    final prefs = await SharedPreferences.getInstance();

    final jsonString =
    jsonEncode(patterns.map((e) => e.toJson()).toList());

    await prefs.setString(_key, jsonString);
  }
}