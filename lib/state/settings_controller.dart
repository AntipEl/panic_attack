import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';
import '../services/breathing_patterns_repository.dart';
import '../services/settings_storage.dart';

class SettingsController extends ChangeNotifier {

  bool sound = true;
  bool vibration = true;
  bool darkTheme = false;

  BreathingPattern defaultPattern = BreathingPatternsRepository.defaultPattern;

  Future<void> init() async {

    final savedId = await SettingsStorage.loadDefaultPattern();

    if (savedId == null) {
      defaultPattern = BreathingPatternsRepository.defaultPattern;
      notifyListeners();
      return;
    }

    final pattern =
    BreathingPatternsRepository.findById(savedId);

    if (pattern != null) {
      defaultPattern = pattern;
    } else {
      defaultPattern =
          BreathingPatternsRepository.defaultPattern;
    }
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
    notifyListeners();
  }

  Future<void> setDefaultPattern(BreathingPattern pattern) async {

    defaultPattern = pattern;

    await SettingsStorage.saveDefaultPattern(pattern.id);

    notifyListeners();
  }
}