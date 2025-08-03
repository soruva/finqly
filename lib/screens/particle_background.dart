import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _numParticles = 30;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < _numParticles; i++) {
      _particles.add(_Particle(
        _random.nextDouble(),
        _random.nextDouble(),
        _random.nextDouble() * 0.002 + 0.001, // vx
        _random.nextDouble() * 0.002 + 0.001, // vy
        _random.nextDouble() * 1.5 + 2.0, // radius
        _random.nextDouble() * 0.13 + 0.15, // opacity
      ));
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() {
            for (var p in _particles) {
              p.x = (p.x + p.vx) % 1;
              p.y = (p.y + p.vy) % 1;
            }
            setState(() {});
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(_particles),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  double x, y, vx, vy, radius, opacity;
  _Particle(this.x, this.y, this.vx, this.vy, this.radius, this.opacity);
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
