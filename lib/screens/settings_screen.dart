import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/breathing_pattern.dart';
import '../state/patterns_controller.dart';
import '../state/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final patterns = context
        .watch<PatternsController>()
        .patterns;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing techniques"),
        actions: [
          Padding(
          padding: const EdgeInsets.only(right: 16),
            child:IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/addPattern");
              },
              icon: const Icon(Icons.add),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList.builder(
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
                  "${pattern.inhale}-${pattern.holdAfterInhale}-${pattern
                      .exhale}-${pattern.holdAfterExhale} • ${pattern
                      .sessionMinutes} min",
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
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8, top:16),
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 24),
                  ),
                ),

              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SwitchListTile(
              title: Text("Dark theme"),
              value: settings.darkTheme,
              onChanged: (val) {
                context.read<SettingsController>().toggleTheme(val);
              },
            ),
          )
        ]
      ),
    );
  }


}
///добавить кнопки управления звуком,
///вибрацией,
///запуск дефолтной техники без заставки
