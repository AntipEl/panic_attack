import 'package:flutter/material.dart';
import 'package:panic_attack/screens/add_pattern_screen.dart';
import 'package:panic_attack/services/breathing_patterns_repository.dart';
import 'package:panic_attack/state/patterns_controller.dart';
import 'package:panic_attack/state/settings_controller.dart';
import 'package:provider/provider.dart';

import 'screens/intro_screen.dart';
import 'state/breathing_controller.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  BreathingController? _breathingController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _breathingController;
    if (controller == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
       // controller.resume();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        controller.pause();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[

        ChangeNotifierProvider(
          create: (_) {
            final controller = PatternsController();
            controller.load();
            return controller;
          },
        ),

        ChangeNotifierProvider<BreathingController>(
          create: (_) {
            final controller = BreathingController(
              pattern: BreathingPatternsRepository.defaultPattern,
            );
            _breathingController = controller;
            return controller;
          },
        ),

        ChangeNotifierProvider<SettingsController>(
          create: (_) {
            final controller = SettingsController();
            controller.init();
            return controller;
          },
        ),

      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          "/addPattern": (_) => const AddPatternScreen(),
        },
        home: const IntroScreen(),
      ),
    );
  }
}
