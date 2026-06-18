import 'package:flutter/material.dart';
import 'package:panic_attack/screens/add_pattern_screen.dart';
import 'package:panic_attack/services/breathing_patterns_repository.dart';
import 'package:panic_attack/state/patterns_controller.dart';
import 'package:panic_attack/state/settings_controller.dart';
import 'package:provider/provider.dart';
import 'screens/intro_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {

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

    switch (state) {
      case AppLifecycleState.resumed:

        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) {
            final controller = PatternsController(repository: BreathingPatternsRepository());
            controller.load();
            return controller;
          },
        ),

        // BreathingController убран — он создаётся локально в BreathingScreen

        ChangeNotifierProvider<SettingsController>(
          create: (_) {
            final controller = SettingsController();
            controller.init();
            return controller;
          },
        ),

      ],

      child: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.blue,
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.blue,
            ),

            themeMode: settings.darkTheme
                ? ThemeMode.dark
                : ThemeMode.light,

            routes: {
              "/addPattern": (_) => const AddPatternScreen(),
            },

            home: const IntroScreen(),
          );
        },
      ),
    );
  }
}
