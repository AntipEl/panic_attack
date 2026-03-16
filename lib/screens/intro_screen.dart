import 'package:flutter/material.dart';
import 'package:panic_attack/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../state/settings_controller.dart';
import 'breathing_screen.dart';

class IntroScreen extends StatelessWidget {
  final bool retryMode;

  const IntroScreen({
    super.key,
    this.retryMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings =
    context.read<SettingsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// ⚙ SETTINGS BUTTON
            Positioned(
              top: 24,
              right: 16,
              child: FloatingActionButton(
                mini: false,
                heroTag: "settingsFab",
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                child: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    retryMode
                        ? "That's okay."
                        : "I’ll guide your breathing.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    retryMode
                        ? "Sometimes the body needs a little more time."
                        : "The exercise will end on its own.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    retryMode
                        ? "Let's try one more round."
                        : "Just breathe and follow the circle.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'First, slowly exhale.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BreathingScreen(
                              pattern: settings.defaultPattern,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        retryMode ? 'Start again' : 'Start breathing',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
