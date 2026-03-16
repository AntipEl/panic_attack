class BreathingPattern {
  final String id;
  final String name;

  final int inhale;
  final int holdAfterInhale;
  final int exhale;
  final int holdAfterExhale;
  final int sessionMinutes;
  final int sessionSeconds;

  const BreathingPattern({
    required this.id,
    required this.name,
    required this.inhale,
    required this.holdAfterInhale,
    required this.exhale,
    required this.holdAfterExhale,
    required this.sessionMinutes,
    this.sessionSeconds = 0,
  });

  Duration get inhaleDuration => Duration(seconds: inhale);
  Duration get holdAfterInhaleDuration => Duration(seconds: holdAfterInhale);
  Duration get exhaleDuration => Duration(seconds: exhale);
  Duration get holdAfterExhaleDuration => Duration(seconds: holdAfterExhale);

  Duration get sessionDuration =>
      Duration(minutes: sessionMinutes, seconds: sessionSeconds);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inhale': inhale,
      'holdAfterInhale': holdAfterInhale,
      'exhale': exhale,
      'holdAfterExhale': holdAfterExhale,
      'sessionMinutes': sessionMinutes,
      'sessionSeconds': sessionSeconds,
    };
  }

  factory BreathingPattern.fromJson(Map<String, dynamic> json) {
    return BreathingPattern(
      id: json['id'],
      name: json['name'],
      inhale: json['inhale'],
      holdAfterInhale: json['holdAfterInhale'],
      exhale: json['exhale'],
      holdAfterExhale: json['holdAfterExhale'],
      sessionMinutes: json['sessionMinutes'] ?? 1,
      sessionSeconds: json['sessionSeconds'] ?? 0,
    );
  }
}




///Ты используешь один паттерн.
// Модель нужна, когда:
//
// несколько режимов
//
// кастом
//
// сохранение
//
// 📍 Можешь оставить файл, но не использовать.