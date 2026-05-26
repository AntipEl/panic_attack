import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';
import '../services/settings_storage.dart';

class SettingsController extends ChangeNotifier {
  bool sound = true;
  bool vibration = true;
  bool darkTheme = false;
  String? defaultPatternId;

  Future<void> init() async {
    defaultPatternId = await SettingsStorage.loadDefaultPattern();
    darkTheme = await SettingsStorage.loadTheme() ?? false;
    notifyListeners();
  }

  void toggleSound(bool value) {
    sound = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    vibration = value;
    notifyListeners();
  }

  void toggleTheme(bool value) {
    darkTheme = value;
    SettingsStorage.saveTheme(value);
    notifyListeners();
  }

  Future<void> setDefaultPattern(BreathingPattern pattern) async {

    defaultPatternId = pattern.id;

    await SettingsStorage.saveDefaultPattern(pattern.id);

    notifyListeners();
  }
}