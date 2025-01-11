import 'package:flutter/material.dart';
import 'dart:math';

class PendulumSimulation extends StatefulWidget {
  const PendulumSimulation({super.key});

  @override
  State<PendulumSimulation> createState() => _PendulumSimulationState();
}

class _PendulumSimulationState extends State<PendulumSimulation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double length = 200; // Chiều dài con lắc
  final double gravity = 9.8; // Gia tốc trọng trường
  final double angle = pi / 4; // Góc lệch ban đầu

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -angle, end: angle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mô phỏng con lắc đơn'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double x = length * sin(_animation.value);
            double y = length * cos(_animation.value);

            return CustomPaint(
              size: Size(400, 400),
              painter: PendulumPainter(x, y),
            );
          },
        ),
      ),
    );
  }
}

class PendulumPainter extends CustomPainter {
  final double x;
  final double y;

  PendulumPainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    Paint ball = Paint()..color = Colors.red;

    // Tâm treo con lắc
    Offset center = Offset(size.width / 2, 100);

    // Vị trí quả nặng
    Offset bob = Offset(center.dx + x, center.dy + y);

    // Vẽ dây con lắc
    canvas.drawLine(center, bob, paint);

    // Vẽ quả nặng
    canvas.drawCircle(bob, 15, ball);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
