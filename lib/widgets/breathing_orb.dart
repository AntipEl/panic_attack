import 'package:flutter/material.dart';

class BreathingOrb extends StatelessWidget {
  static const double orbSize = 200;

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
        size: const Size(orbSize, orbSize),
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

    // ── 1. Основной градиент (чуть глубже) ─────────────
    final gradient = RadialGradient(
      colors: [
        const Color(0xFFB3E5FC),
        const Color(0xFF42A5F5),
        const Color(0xFF205AB3),
      ],
      stops: const [0.15, 0.6, 1],
    );

    final basePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, basePaint);

    // ── 2. Мягкое "дыхание света" (без анимаций, через scale) ─────
    final lightShift = Offset(
      -radius * 0.25 * scale,
      -radius * 0.25 * scale,
    );

    final innerLight = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.18 * scale),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center + lightShift,
          radius: radius,
        ),
      );

    canvas.drawCircle(center, radius, innerLight);

    // ── 3. Внутренний "туман" (облегчённый, без тяжёлого blur) ─────
    final fog = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.06 * scale),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius * 0.65,
        ),
      );

    canvas.drawCircle(center, radius * 0.65, fog);

    // ── 4. Внешний glow (дешёвый, без maskFilter) ────────────────
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blueAccent.withValues(alpha: 0.25 * scale),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius * 1.2,
        ),
      );

    canvas.drawCircle(center, radius * 1.2, glow);
  }

  @override
  bool shouldRepaint(covariant _BreathingOrbPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}