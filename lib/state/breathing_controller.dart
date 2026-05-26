import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/breathing_pattern.dart';
import '../services/ads_service.dart';
import '../services/analytics_service.dart';

enum BreathingPhase {
  prepare,
  inhale,
  holdAfterInhale,
  exhale,
  holdAfterExhale,
}

class BreathingController extends ChangeNotifier {
  final BreathingPattern pattern;

  BreathingController({
    required this.pattern,
  });

  VoidCallback? onSessionComplete;

  BreathingPhase phase = BreathingPhase.prepare;
  int phaseSecondsRemaining = 0;
  Timer? _phaseCountdownTimer;

  final prepareDuration = const Duration(seconds: 3);
  late final Duration sessionLength;

  bool slowBreathing = false;

  bool isRunning = false;
  Duration elapsed = Duration.zero;

  Timer? _phaseTimer;
  Timer? _sessionTimer;

  double get currentScale {
    return switch (phase) {
      BreathingPhase.prepare => 0.85,
      BreathingPhase.inhale => 1.0,
      BreathingPhase.holdAfterInhale => 1.0,
      BreathingPhase.exhale => 0.7,
      BreathingPhase.holdAfterExhale => 0.7,
    };
  }

  Duration get currentDuration {
    final extra = slowBreathing ? const Duration (seconds: 1) : Duration.zero;

    return switch (phase) {
      BreathingPhase.prepare => prepareDuration,
      BreathingPhase.inhale => pattern.inhaleDuration + extra,
      BreathingPhase.holdAfterInhale => pattern.holdAfterInhaleDuration + extra,
      BreathingPhase.exhale => pattern.exhaleDuration + extra,
      BreathingPhase.holdAfterExhale => pattern.holdAfterExhaleDuration + extra,
    };
  }

  String get currentLabel {
    return switch (phase) {
      BreathingPhase.prepare => 'Get Ready',
      BreathingPhase.inhale => 'Inhale',
      BreathingPhase.holdAfterInhale => 'Hold',
      BreathingPhase.exhale => 'Exhale',
      BreathingPhase.holdAfterExhale => 'Hold',
    };
  }

  void start() {
    if (isRunning) return;

    isRunning = true;
    elapsed = Duration.zero;
    phase = BreathingPhase.prepare;

    sessionLength = pattern.sessionDuration;

    WakelockPlus.enable();

    AdsService.preloadInterstitial();

    _hapticForPhase();

    notifyListeners();
    _startPhaseTimer();

    _startSessionTimer();
  }

  void pause({bool interrupted = true}) {
    if (!isRunning) return;

    if (interrupted) {
      AnalyticsService.breathingInterrupted();
    }

    isRunning = false;
    _phaseTimer?.cancel();
    _sessionTimer?.cancel();

    WakelockPlus.disable();

    notifyListeners();
  }

  void reset() {
    pause(interrupted: false);
    elapsed = Duration.zero;
    phase = BreathingPhase.prepare;
    notifyListeners();
  }

  void _hapticForPhase() {

    switch (phase) {

      case BreathingPhase.inhale:
        HapticFeedback.lightImpact();
        break;

      case BreathingPhase.holdAfterInhale:
        HapticFeedback.selectionClick();
        break;

      case BreathingPhase.exhale:
        HapticFeedback.mediumImpact();
        break;

      case BreathingPhase.holdAfterExhale:
        HapticFeedback.selectionClick();
        break;

      default:
        break;
    }
  }

  void _startPhaseTimer() {
    _phaseTimer?.cancel();

    final duration = currentDuration;

    phaseSecondsRemaining = duration.inSeconds;
    _startPhaseCountdown();
    notifyListeners();

    _phaseTimer = Timer(duration, () {

      if (!isRunning) return;

      switch (phase) {

        case BreathingPhase.inhale:
          phase = BreathingPhase.holdAfterInhale;
          break;

        case BreathingPhase.holdAfterInhale:
          phase = BreathingPhase.exhale;
          break;

        case BreathingPhase.exhale:
          phase = BreathingPhase.holdAfterExhale;
          break;

        case BreathingPhase.holdAfterExhale:
          phase = BreathingPhase.inhale;
          break;

        default:
          phase = BreathingPhase.inhale;
      }
      _hapticForPhase();

      notifyListeners();
      _startPhaseTimer();
    });
  }

  void _startPhaseCountdown() {
    _phaseCountdownTimer?.cancel();

    _phaseCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {

        if (!isRunning) return;

        if (phaseSecondsRemaining > 0) {
          phaseSecondsRemaining--;
          notifyListeners();
        }
      },
    );
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        elapsed += const Duration(seconds: 1);

        if (elapsed >= sessionLength) {
          pause(interrupted: false);
          AnalyticsService.breathingCompleted();
          onSessionComplete?.call();
          return;
        }

        notifyListeners();
      },
    );
  }

  void toggleSlowMode() {
    slowBreathing = !slowBreathing;
    notifyListeners();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _phaseTimer?.cancel();
    _sessionTimer?.cancel();
    _phaseCountdownTimer?.cancel();
    super.dispose();
  }
}
