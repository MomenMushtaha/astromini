import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet_position.dart';
import '../models/birth_chart.dart';
import '../services/astro/zodiac_util.dart';

class SkyWheelPainter extends CustomPainter {
  final Map<CelestialBody, PlanetPosition> positions;
  final double rotation;
  final BirthChart? natalChart;

  SkyWheelPainter({
    required this.positions,
    this.rotation = 0,
    this.natalChart,
  });

  static const _elementColors = {
    'Fire': Color(0xFFEF5350),
    'Earth': Color(0xFF66BB6A),
    'Air': Color(0xFFFFEE58),
    'Water': Color(0xFF42A5F5),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = min(size.width, size.height) / 2 - 8;
    final innerR = outerR * 0.75;
    final planetR = outerR * 0.55;

    final rotRad = rotation * 2 * pi;

    // Draw outer zodiac ring
    for (int i = 0; i < 12; i++) {
      final startAngle = (i * 30) * pi / 180 + rotRad;
      final sweepAngle = 30 * pi / 180;

      final sign = ZodiacUtil.signNames[i];
      final element = ZodiacUtil.signElements[sign] ?? 'Fire';
      final color = _elementColors[element]!;

      final path = Path()
        ..moveTo(center.dx + innerR * cos(startAngle),
            center.dy + innerR * sin(startAngle))
        ..arcTo(Rect.fromCircle(center: center, radius: outerR), startAngle,
            sweepAngle, false)
        ..lineTo(center.dx + innerR * cos(startAngle + sweepAngle),
            center.dy + innerR * sin(startAngle + sweepAngle))
        ..arcTo(Rect.fromCircle(center: center, radius: innerR),
            startAngle + sweepAngle, -sweepAngle, false)
        ..close();

      canvas.drawPath(
          path, Paint()..color = color.withAlpha(30)..style = PaintingStyle.fill);
      canvas.drawPath(
          path,
          Paint()
            ..color = color.withAlpha(60)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5);

      // Sign symbol
      final midAngle = startAngle + sweepAngle / 2;
      final symbolR = (outerR + innerR) / 2;
      final symbolPos = Offset(
        center.dx + symbolR * cos(midAngle),
        center.dy + symbolR * sin(midAngle),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: ZodiacUtil.signSymbols[i],
          style: TextStyle(fontSize: 13, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, symbolPos - Offset(tp.width / 2, tp.height / 2));
    }

    // Inner circle
    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..color = Colors.white.withAlpha(15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Draw natal chart overlay (faded)
    if (natalChart != null) {
      for (final entry in natalChart!.planets.entries) {
        final angle = entry.value.eclipticLongitude * pi / 180 + rotRad;
        final pt = Offset(
          center.dx + (planetR - 20) * cos(angle),
          center.dy + (planetR - 20) * sin(angle),
        );
        final tp = TextPainter(
          text: TextSpan(
            text: entry.key.symbol,
            style: TextStyle(fontSize: 10, color: Colors.white.withAlpha(40)),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, pt - Offset(tp.width / 2, tp.height / 2));
      }
    }

    // Draw current planets
    for (final entry in positions.entries) {
      final body = entry.key;
      final pos = entry.value;
      final angle = pos.eclipticLongitude * pi / 180 + rotRad;

      final pt = Offset(
        center.dx + planetR * cos(angle),
        center.dy + planetR * sin(angle),
      );

      final color =
          pos.isRetrograde ? const Color(0xFFEF5350) : const Color(0xFFE8E8F0);

      // Glow behind planet
      canvas.drawCircle(
        pt,
        10,
        Paint()..color = color.withAlpha(15),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: body.symbol,
          style: TextStyle(fontSize: 15, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pt - Offset(tp.width / 2, tp.height / 2));

      // Tick to inner ring
      final tickPt = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      canvas.drawLine(
        pt,
        tickPt,
        Paint()
          ..color = Colors.white.withAlpha(15)
          ..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(SkyWheelPainter oldDelegate) => true;
}
