import 'package:flutter/material.dart';
import 'package:panic_attack/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../state/patterns_controller.dart';
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
    final settings = context.watch<SettingsController>();
    final patterns = context.watch<PatternsController>();
    final defaultPattern = patterns.patterns.firstWhere(
          (p) => p.id == settings.defaultPatternId,
      orElse: () => patterns.patterns.first,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            /// ⚙ SETTINGS BUTTON
            Positioned(
              bottom: 24,
              right: 16,
              child: FloatingActionButton(
                mini: false,
                heroTag: "settingsFab",
                backgroundColor: Colors.blueAccent,
                foregroundColor: Theme.of(context).colorScheme.surface,
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
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    retryMode
                        ? "Let's try one more round."
                        : "Just breathe and follow the circle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'First, slowly exhale.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
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
                              pattern: defaultPattern,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        retryMode ? 'Start again' : 'Start breathing',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.surface,
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
