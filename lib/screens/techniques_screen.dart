import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/breathing_pattern.dart';
import '../state/patterns_controller.dart';
import '../state/settings_controller.dart';

class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final settings = context.watch<SettingsController>();
    final patterns = context.watch<PatternsController>().patterns;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing techniques"),
      ),

      body: ListView.builder(
        itemCount: patterns.length,
        itemBuilder: (context, index) {

          final BreathingPattern pattern = patterns[index];

          final bool isDefault =
              settings.defaultPatternId == pattern.id;

          final bool isUserPattern =
          pattern.id.startsWith("user_");

          return ListTile(
            title: Text(pattern.name),

            subtitle: Text(
              "${pattern.inhale}-${pattern.holdAfterInhale}-${pattern.exhale}-${pattern.holdAfterExhale} • ${pattern.sessionMinutes} min",
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                if (isDefault)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),

                PopupMenuButton<String>(
                  onSelected: (value) {

                    if (value == "default") {

                      context
                          .read<SettingsController>()
                          .setDefaultPattern(pattern);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Technique set as default"),
                        ),
                      );
                    }

                    if (value == "delete") {

                      context
                          .read<PatternsController>()
                          .deletePattern(pattern.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Technique deleted"),
                        ),
                      );
                    }
                  },

                  itemBuilder: (context) {

                    final items = <PopupMenuEntry<String>>[];

                    items.add(
                      const PopupMenuItem(
                        value: "default",
                        child: Text("Set as default"),
                      ),
                    );

                    if (isUserPattern) {
                      items.add(
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      );
                    }

                    return items;
                  },
                ),
              ],
            ),

            onTap: () {

              context
                  .read<SettingsController>()
                  .setDefaultPattern(pattern);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Technique set as default"),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.pushNamed(context, "/addPattern");
        },
      ),
    );
  }
}