import 'dart:math';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCanvasAnimator extends StatefulWidget {
  final WeatherCondition condition;

  const WeatherCanvasAnimator({
    super.key,
    required this.condition,
  });

  @override
  State<WeatherCanvasAnimator> createState() => _WeatherCanvasAnimatorState();
}

class _WeatherCanvasAnimatorState extends State<WeatherCanvasAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles.clear();
    const count = 100;
    for (int i = 0; i < count; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.2 + _random.nextDouble() * 0.8,
        size: 1.0 + _random.nextDouble() * 3.0,
        opacity: 0.3 + _random.nextDouble() * 0.7,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WeatherParticlePainter(
            condition: widget.condition,
            particles: _particles,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class WeatherParticlePainter extends CustomPainter {
  final WeatherCondition condition;
  final List<Particle> particles;
  final double progress;

  WeatherParticlePainter({
    required this.condition,
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // رسم خلفية التدرج اللوني للسماء بناء على حالة الطقس
    final gradient = _getSkyGradient(condition);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paintBg = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintBg);

    // رسم جزيئات الطقس (مطر، ثلج، شمس)
    final paintParticle = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeCap = StrokeCap.round;

    for (var particle in particles) {
      // تحديث الموقع
      particle.y += particle.speed * 0.015;
      if (particle.y > 1.0) {
        particle.y = 0.0;
        particle.x = Random().nextDouble();
      }

      final drawX = particle.x * size.width;
      final drawY = particle.y * size.height;

      if (condition == WeatherCondition.rain || condition == WeatherCondition.heavyRain) {
        paintParticle.strokeWidth = 1.5;
        canvas.drawLine(
          Offset(drawX, drawY),
          Offset(drawX - 2, drawY + 12),
          paintParticle,
        );
      } else if (condition == WeatherCondition.snow) {
        paintParticle.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(drawX, drawY), particle.size, paintParticle);
      }
    }
  }

  LinearGradient _getSkyGradient(WeatherCondition cond) {
    switch (cond) {
      case WeatherCondition.sunny:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0284C7), Color(0xFF0369A1), Color(0xFF0F172A)],
        );
      case WeatherCondition.thunderstorm:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1B4B), Color(0xFF0F172A), Color(0xFF020617)],
        );
      case WeatherCondition.rain:
      case WeatherCondition.heavyRain:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF334155), Color(0xFF1E293B), Color(0xFF0F172A)],
        );
      case WeatherCondition.snow:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF475569), Color(0xFF334155), Color(0xFF1E293B)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF020617)],
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}