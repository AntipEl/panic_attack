import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';
import '../services/patterns_storage.dart';
import '../services/breathing_patterns_repository.dart';

class PatternsController extends ChangeNotifier {

  List<BreathingPattern> get patterns =>
      BreathingPatternsRepository.all;

  bool _initialized = false;

  Future<void> load() async {
    if (_initialized) return;

    final loaded =
    await PatternsStorage.loadPatterns();

    BreathingPatternsRepository.userPatterns =
        loaded;

    _initialized = true;

    notifyListeners();
  }

  Future<void> addPattern(BreathingPattern pattern) async {

    BreathingPatternsRepository.userPatterns
        .add(pattern);

    await PatternsStorage.savePatterns(
        BreathingPatternsRepository.userPatterns);

    notifyListeners();
  }

  Future<void> deletePattern(String id) async {

    BreathingPatternsRepository.userPatterns
        .removeWhere((p) => p.id == id);

    await PatternsStorage.savePatterns(
        BreathingPatternsRepository.userPatterns);

    notifyListeners();
  }
}