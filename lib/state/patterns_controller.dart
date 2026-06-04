import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';
import '../services/patterns_storage.dart';
import '../services/breathing_patterns_repository.dart';

class PatternsController extends ChangeNotifier {
  BreathingPatternsRepository repository;

  PatternsController({
  required this.repository,
});

  List<BreathingPattern> get patterns =>
      repository.all;

  bool _initialized = false;

  Future<void> load() async {
    if (_initialized) return;
    final loaded = await PatternsStorage.loadPatterns();

    repository.userPatterns = loaded;
    _initialized = true;
    notifyListeners();
  }

  Future<void> addPattern(BreathingPattern pattern) async {
    repository.userPatterns.add(pattern);

    await PatternsStorage.savePatterns(repository.userPatterns);

    notifyListeners();
  }

  Future<void> deletePattern(String id) async {
    repository.userPatterns.removeWhere((p) => p.id == id);

    await PatternsStorage.savePatterns(repository.userPatterns);

    notifyListeners();
  }
}