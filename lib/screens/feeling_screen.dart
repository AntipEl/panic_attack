import 'package:flutter/material.dart';
import 'package:panic_attack/screens/intro_screen.dart';
import 'package:panic_attack/screens/session_end_screen.dart';

import '../services/analytics_service.dart';

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  State<FeelingScreen> createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {

  bool _answered = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {

      if (!_answered && mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SessionEndScreen(),
          ),
        );

      }
    });
  }

  void _select(String result) async {

    _answered = true;

    await AnalyticsService.breathingFeedback(result);
    if (!mounted) return;

    if (result == "worse") {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const IntroScreen(retryMode: true),
        ),
      );
      AnalyticsService.breathingRetry();

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SessionEndScreen(),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "How do you feel now?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _emojiButton(
                    context,
                    emoji: "🙂",
                    label: "Better",
                    result: "better",
                  ),

                  _emojiButton(
                    context,
                    emoji: "😐",
                    label: "Same",
                    result: "same",
                  ),

                  _emojiButton(
                    context,
                    emoji: "😣",
                    label: "Worse",
                    result: "worse",
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emojiButton(
      BuildContext context, {
        required String emoji,
        required String label,
        required String result,
      }) {

    return GestureDetector(
      onTap: () => _select(result),
      child: Column(
        children: [

          Text(
            emoji,
            style: const TextStyle(fontSize: 48),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(fontSize: 16),
          )

        ],
      ),
    );
  }
}