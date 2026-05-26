import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics =
      FirebaseAnalytics.instance;

  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  static Future<void> breathingStarted() async {
    await _analytics.logEvent(
      name: 'breathing_started',
    );
  }

  static Future<void> breathingCompleted() async {
    await _analytics.logEvent(
      name: 'breathing_completed',
    );
  }

  static Future<void> breathingInterrupted() async {
    await _analytics.logEvent(
      name: 'breathing_interrupted',
    );
  }

  static Future<void> sessionEndShown() async {
    await _analytics.logEvent(
      name: 'session_end_screen_shown',
    );
  }

  static Future<void> breathingFeedback(String result) async {
    await _analytics.logEvent(
      name: 'breathing_feedback',
      parameters: {
        'result': result,
      },
    );
  }

  static Future<void> breathingRetry() async {
    await _analytics.logEvent(
      name: 'breathing_retry',
    );
  }
}
