import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:panic_attack/screens/intro_screen.dart';
import 'package:panic_attack/services/ads_service.dart';
import 'package:panic_attack/services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AdsService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroScreen(),
    );
  }
}

///сворачивание приложения
//
// блокировка экрана
//
// повторный вход
//
// Поведение:
//
// сессия либо продолжается
//
// либо аккуратно завершается
