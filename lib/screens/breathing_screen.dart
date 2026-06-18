import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/breathing_pattern.dart';
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

        final scale = controller.currentScale;
        final duration = controller.currentDuration;
        final label = controller.currentLabel;


        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: GestureDetector(

            onTap: () {
              context.read<BreathingController>().toggleSlowMode();
            },

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: BreathingOrb.orbSize,
                    height: BreathingOrb.orbSize,
                    child:
                      BreathingOrb(
                        scale: scale,
                        duration: duration,
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