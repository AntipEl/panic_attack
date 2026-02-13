import 'package:flutter/material.dart';
import 'package:panic_attack/screens/session_end_screen.dart';
import 'package:provider/provider.dart';
import '../state/breathing_controller.dart';

class BreathingScreen extends StatelessWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = BreathingController();

        controller.onSessionComplete = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SessionEndScreen(),
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

        final scale = isPrepare
            ? 0.85
            : isInhale
            ? 1.0
            : 0.7;

        final duration = isPrepare
            ? controller.prepare
            : isInhale
            ? controller.inhale
            : controller.exhale;

        final label = isPrepare
            ? 'We’ll start gently'
            : isInhale
            ? 'Inhale'
            : 'Exhale';

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: scale,
                  duration: duration,
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
