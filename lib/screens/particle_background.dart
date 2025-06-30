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
  final List<Offset> _positions = List.generate(30, (_) => Offset.zero);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < _positions.length; i++) {
      _positions[i] = Offset(_random.nextDouble(), _random.nextDouble());
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() {
            setState(() {
              for (var i = 0; i < _positions.length; i++) {
                _positions[i] = Offset(
                  (_positions[i].dx + 0.001) % 1,
                  (_positions[i].dy + 0.002) % 1,
                );
              }
            });
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
    return CustomPaint(
      painter: _ParticlePainter(_positions),
      size: Size.infinite,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Offset> positions;
  _ParticlePainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (final pos in positions) {
      final dx = pos.dx * size.width;
      final dy = pos.dy * size.height;
      canvas.drawCircle(Offset(dx, dy), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
