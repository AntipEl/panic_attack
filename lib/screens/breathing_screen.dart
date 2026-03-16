import 'package:flutter/material.dart';
import 'package:panic_attack/screens/session_end_screen.dart';
import 'package:provider/provider.dart';
import '../models/breathing_pattern.dart';
import '../services/breathing_patterns_repository.dart';
import '../state/breathing_controller.dart';
import '../widgets/breathing_orb.dart';
import 'feeling_screen.dart';

class BreathingScreen extends StatelessWidget {
  final BreathingPattern pattern;

  const BreathingScreen({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = BreathingController(pattern: pattern,);

        controller.onSessionComplete = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const FeelingScreen(),
            ),
          );
        };

        return controller;
      },
      child: const _BreathingView(),
    );
  }
}

class _BreathingView extends StatefulWidget {
  const _BreathingView();

  @override
  State<_BreathingView> createState() => _BreathingViewState();
}

class _BreathingViewState extends State<_BreathingView> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_started) {
      _started = true;
      final controller = context.read<BreathingController>();

      // Автозапуск после первого кадра
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.start();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BreathingController>(
      builder: (context, controller, _) {
        final isInhale = controller.phase == BreathingPhase.inhale;
        final isExhale = controller.phase == BreathingPhase.exhale;
        final isPrepare = controller.phase == BreathingPhase.prepare;

        final scale = switch (controller.phase) {

          BreathingPhase.prepare => 0.85,

        BreathingPhase.inhale => 1.0,

        BreathingPhase.holdAfterInhale => 1.0,

        BreathingPhase.exhale => 0.7,

        BreathingPhase.holdAfterExhale => 0.7,
        };

        final duration = switch (controller.phase) {

          BreathingPhase.prepare => controller.prepare,

          BreathingPhase.inhale => controller.pattern.inhaleDuration,

          BreathingPhase.holdAfterInhale =>
          controller.pattern.holdAfterInhaleDuration,

          BreathingPhase.exhale =>
          controller.pattern.exhaleDuration,

          BreathingPhase.holdAfterExhale =>
          controller.pattern.holdAfterExhaleDuration,
        };

        final label = switch (controller.phase) {

          BreathingPhase.prepare => 'Get Ready',

          BreathingPhase.inhale => 'Inhale',

          BreathingPhase.holdAfterInhale => 'Hold',

          BreathingPhase.exhale => 'Exhale',

          BreathingPhase.holdAfterExhale => 'Hold',
        };

        return Scaffold(
          backgroundColor: Colors.white,
            body: GestureDetector(

              onTap: () {
                context.read<BreathingController>().slowMode();
              },

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          BreathingOrb(
                            scale: scale,
                            duration: duration,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "${controller.phaseSecondsRemaining}",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
