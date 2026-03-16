import 'dart:math';
import 'package:flutter/material.dart';

class BreathingOrb extends StatelessWidget {
  final double scale;
  final Duration duration;

  const BreathingOrb({
    super.key,
    required this.scale,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()..scale(scale),
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _BreathingOrbPainter(scale),
      ),
    );
  }
}

class _BreathingOrbPainter extends CustomPainter {
  final double scale;

  _BreathingOrbPainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    /// основной градиент
    final gradient = RadialGradient(
      colors: [
        const Color(0xFF8ED5FF),
        const Color(0xFF2196F3),
        const Color(0xFF0D47A1),
      ],
      stops: const [0.2, 0.6, 1],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);

    /// внутренний туман
    final fogPaint = Paint()
      ..color = Colors.white.withOpacity(0.08 * scale)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        30,
      );

    canvas.drawCircle(center, radius * 0.6, fogPaint);

    /// мягкий glow
    final glowPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.35 * scale)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        40,
      );

    canvas.drawCircle(center, radius * 0.9, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathingOrbPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}