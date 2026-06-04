
import '../models/breathing_pattern.dart';

class BreathingPatternsRepository {

  static final defaultPattern = BreathingPattern(
    id: "box",
    name: "Box Breathing",
    inhale: 4,
    holdAfterInhale: 4,
    exhale: 4,
    holdAfterExhale: 4,
    sessionMinutes: 2,
  );

  static final fourSevenEight = BreathingPattern(
    id: "478",
    name: "4-7-8 Breathing",
    inhale: 4,
    holdAfterInhale: 7,
    exhale: 8,
    holdAfterExhale: 0,
    sessionMinutes: 2,
  );

  static final physiologicalSigh = BreathingPattern(
    id: "sigh",
    name: "Physiological Sigh",
    inhale: 2,
    holdAfterInhale: 1,
    exhale: 6,
    holdAfterExhale: 0,
    sessionMinutes: 2,
  );

  static final builtInPatterns = [
    defaultPattern,
    physiologicalSigh,
    fourSevenEight,
  ];

  List<BreathingPattern> userPatterns = [];

  List<BreathingPattern> get all => [
    ...builtInPatterns,
    ...userPatterns,
  ];

  BreathingPattern? findById(String id) {
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}