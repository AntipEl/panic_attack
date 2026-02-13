import 'package:flutter/material.dart';
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
    return ChangeNotifierProvider<BreathingController>(
      create: (_) {
        final controller = BreathingController();
        _breathingController = controller;
        return controller;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const IntroScreen(),
      ),
    );
  }
}
