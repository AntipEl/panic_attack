import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/ads_service.dart';
import '../services/analytics_service.dart';

enum BreathingPhase {
  prepare,
  inhale,
  exhale,
}

class BreathingController extends ChangeNotifier {
  VoidCallback? onSessionComplete;

  BreathingPhase phase = BreathingPhase.prepare;

  final prepare = const Duration(seconds: 3);
  final inhale = const Duration(seconds: 4);
  final exhale = const Duration(seconds: 6);
  final sessionLength = const Duration(minutes: 2);

  bool isRunning = false;
  Duration elapsed = Duration.zero;

  Timer? _phaseTimer;
  Timer? _sessionTimer;

  void start() {
    if (isRunning) return;

    isRunning = true;
    elapsed = Duration.zero;
    phase = BreathingPhase.prepare;

    WakelockPlus.enable();

    AdsService.preloadInterstitial();

    _startPhaseTimer();
    _startSessionTimer();
    notifyListeners();
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

  void _startPreparePhase() {
    _phaseTimer?.cancel();

    _phaseTimer = Timer(prepare, () {
      if (!isRunning) return;

      phase = BreathingPhase.inhale;
      notifyListeners();
      _startPhaseTimer();
    });
  }

  void _startPhaseTimer() {
    _phaseTimer?.cancel();

    final duration =
    phase == BreathingPhase.inhale ? inhale : exhale;

    _phaseTimer = Timer(duration, () {
      if (!isRunning) return;

      phase = phase == BreathingPhase.inhale
          ? BreathingPhase.exhale
          : BreathingPhase.inhale;

      notifyListeners();
      _startPhaseTimer();
    });
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

  @override
  void dispose() {
    WakelockPlus.disable();
    _phaseTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }
}
