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

  final prepare = const Duration(seconds: 3);
  late final Duration sessionLength;

  bool isRunning = false;
  Duration elapsed = Duration.zero;

  Timer? _phaseTimer;
  Timer? _sessionTimer;

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

    Duration duration;

    switch (phase) {

      case BreathingPhase.inhale:
        duration = slowBreathing
            ? pattern.inhaleDuration + const Duration(seconds: 1)
            : pattern.inhaleDuration;
        break;

      case BreathingPhase.holdAfterInhale:
        duration = slowBreathing
            ? pattern.holdAfterInhaleDuration + const Duration(seconds: 1)
            : pattern.holdAfterInhaleDuration;
        break;

      case BreathingPhase.exhale:
        duration = slowBreathing
            ? pattern.exhaleDuration + const Duration(seconds: 1)
            : pattern.exhaleDuration;
        break;

      case BreathingPhase.holdAfterExhale:
        duration = slowBreathing
            ? pattern.holdAfterExhaleDuration + const Duration(seconds: 1)
            : pattern.holdAfterExhaleDuration;
        break;

      default:
        duration = const Duration(seconds: 1);
    }

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

  bool slowBreathing = false;

  void slowMode() {

    slowBreathing = true;

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
