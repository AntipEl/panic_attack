import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/breathing_pattern.dart';
import '../state/patterns_controller.dart';

class AddPatternScreen extends StatefulWidget {
  const AddPatternScreen({super.key});

  @override
  State<AddPatternScreen> createState() => _AddPatternScreenState();
}

class _AddPatternScreenState extends State<AddPatternScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController minutesController =
  TextEditingController(text: "1");

  final TextEditingController secondsController =
  TextEditingController(text: "0");

  int inhale = 4;
  int hold1 = 0;
  int exhale = 4;
  int hold2 = 0;
  int sessionMinutes = 1;
  int sessionSeconds = 0;

  void _normalizeSessionTime() {

    // перенос секунд в минуты
    if (sessionSeconds >= 60) {
      sessionMinutes += sessionSeconds ~/ 60;
      sessionSeconds = sessionSeconds % 60;
    }

    // защита от отрицательных значений
    if (sessionSeconds < 0) {
      sessionSeconds = 0;
    }

    if (sessionMinutes < 0) {
      sessionMinutes = 0;
    }
  }

  void _savePattern() {
    _normalizeSessionTime();

    if (nameController.text.trim().isEmpty) {
      return;
    }

    if (sessionSeconds > 59) {
      sessionSeconds = 59;
    }

    final totalSeconds = sessionMinutes * 60 + sessionSeconds;

// минимум 30 секунд
    if (totalSeconds < 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session must be at least 30 seconds"),
        ),
      );
      return;
    }

// максимум 30 минут
    if (totalSeconds > 1800) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session cannot exceed 30 minutes"),
        ),
      );
      return;
    }

    final pattern = BreathingPattern(
      id: "user_${DateTime.now().millisecondsSinceEpoch}",
      name: nameController.text.trim(),
      inhale: inhale,
      holdAfterInhale: hold1,
      exhale: exhale,
      holdAfterExhale: hold2,
      sessionMinutes: sessionMinutes,
      sessionSeconds: sessionSeconds,
    );

    context.read<PatternsController>().addPattern(pattern);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }

  Widget _buildSessionDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Session duration",
          style: TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Expanded(
              child: TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minutes",
                ),
                onChanged: (value) {

                  final v = int.tryParse(value);

                  if (v != null) {
                    sessionMinutes = v;
                  }
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Seconds",
                ),
                onChanged: (value) {

                  final v = int.tryParse(value);

                  if (v != null) {
                    sessionSeconds = v;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepper(
      String title,
      int value,
      VoidCallback onMinus,
      VoidCallback onPlus,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),

        Row(
          children: [

            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onMinus,
            ),

            Text(
              "$value s",
              style: const TextStyle(fontSize: 18),
            ),

            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onPlus,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Breathing Pattern"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Pattern name",
              ),
            ),

            const SizedBox(height: 30),

            _buildStepper(
              "Inhale",
              inhale,
                  () {
                if (inhale > 1) {
                  setState(() => inhale--);
                }
              },
                  () {
                setState(() => inhale++);
              },
            ),

            _buildStepper(
              "Hold after inhale",
              hold1,
                  () {
                if (hold1 > 0) {
                  setState(() => hold1--);
                }
              },
                  () {
                setState(() => hold1++);
              },
            ),

            _buildStepper(
              "Exhale",
              exhale,
                  () {
                if (exhale > 1) {
                  setState(() => exhale--);
                }
              },
                  () {
                setState(() => exhale++);
              },
            ),

            _buildStepper(
              "Hold after exhale",
              hold2,
                  () {
                if (hold2 > 0) {
                  setState(() => hold2--);
                }
              },
                  () {
                setState(() => hold2++);
              },
            ),

            _buildSessionDuration(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePattern,
                child: const Text("Save Pattern"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}