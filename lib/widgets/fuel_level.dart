
import 'package:flutter/material.dart';
import 'dart:math';

import '../utils/colors.dart';




class CircularFuelGauge extends StatefulWidget {
  const CircularFuelGauge({super.key});

  @override
  _CircularFuelGaugeState createState() => _CircularFuelGaugeState();
}

class _CircularFuelGaugeState extends State<CircularFuelGauge> {
  double _fuelLevel = 0.5; // Current fuel level (0.0 - empty, 1.0 - full)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            // Handle user interaction to update fuel level
            setState(() {
              _fuelLevel = _calculateFuelLevel(details.localPosition);
            });
          },
          child: SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: FuelGaugePainter(fuelLevel: _fuelLevel),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateFuelLevel(Offset localPosition) {
    final center = Offset(125, 125); // Center of the circular gauge
    final angle = atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);
    double normalizedAngle = (angle + pi) / (2 * pi); // Normalize to 0.0 - 1.0 range
    return normalizedAngle.clamp(0.0, 1.0); // Clamp to valid range
  }
}

class FuelGaugePainter extends CustomPainter {
  final double fuelLevel;

  FuelGaugePainter({required this.fuelLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the gauge background
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the fuel level arc
    final fuelPaint = Paint()
      ..color = btncolor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
    final fuelAngle = 2 * pi * fuelLevel;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      fuelAngle,
      false,
      fuelPaint,
    );

    // Draw the fuel level text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(fuelLevel * 100).toInt()}%',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
