import 'dart:math';
import 'package:flutter/material.dart';
import '../models/birth_chart.dart';
import '../services/astro/zodiac_util.dart';

class SynastryWheelPainter extends CustomPainter {
  final BirthChart chart1;
  final BirthChart chart2;

  SynastryWheelPainter({required this.chart1, required this.chart2});

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
    final ring1R = outerR * 0.60;
    final ring2R = outerR * 0.45;

    final ascRot = -chart1.ascendant * pi / 180 + pi;

    // Draw zodiac ring
    for (int i = 0; i < 12; i++) {
      final startAngle = (i * 30) * pi / 180 + ascRot;
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
          style: TextStyle(fontSize: 11, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, symbolPos - Offset(tp.width / 2, tp.height / 2));
    }

    // Inner ring separator
    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..color = Colors.white.withAlpha(20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Middle separator
    canvas.drawCircle(
      center,
      (ring1R + ring2R) / 2,
      Paint()
        ..color = Colors.white.withAlpha(10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..strokeCap = StrokeCap.round,
    );

    // Chart 1 planets (outer ring) - purple tinted
    for (final entry in chart1.planets.entries) {
      final angle = entry.value.eclipticLongitude * pi / 180 + ascRot - pi;
      final pt = Offset(
        center.dx + ring1R * cos(angle),
        center.dy + ring1R * sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: entry.key.symbol,
          style: const TextStyle(fontSize: 13, color: Color(0xFFCE93D8)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pt - Offset(tp.width / 2, tp.height / 2));
    }

    // Chart 2 planets (inner ring) - gold tinted
    for (final entry in chart2.planets.entries) {
      final angle = entry.value.eclipticLongitude * pi / 180 + ascRot - pi;
      final pt = Offset(
        center.dx + ring2R * cos(angle),
        center.dy + ring2R * sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: entry.key.symbol,
          style: const TextStyle(fontSize: 13, color: Color(0xFFFFD54F)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pt - Offset(tp.width / 2, tp.height / 2));
    }

    // Cross-chart aspect lines
    for (final e1 in chart1.planets.entries) {
      for (final e2 in chart2.planets.entries) {
        final lon1 = e1.value.eclipticLongitude;
        final lon2 = e2.value.eclipticLongitude;
        var diff = (lon1 - lon2).abs() % 360;
        if (diff > 180) diff = 360 - diff;

        Color? lineColor;
        if ((diff - 0).abs() < 8) lineColor = const Color(0xFFFFD54F);
        if ((diff - 120).abs() < 8) lineColor = const Color(0xFF42A5F5);
        if ((diff - 90).abs() < 8) lineColor = const Color(0xFFEF5350);
        if ((diff - 60).abs() < 8) lineColor = const Color(0xFF66BB6A);

        if (lineColor != null) {
          final a1 = lon1 * pi / 180 + ascRot - pi;
          final a2 = lon2 * pi / 180 + ascRot - pi;
          final p1 =
              Offset(center.dx + ring1R * cos(a1), center.dy + ring1R * sin(a1));
          final p2 =
              Offset(center.dx + ring2R * cos(a2), center.dy + ring2R * sin(a2));

          canvas.drawLine(
            p1,
            p2,
            Paint()
              ..color = lineColor.withAlpha(60)
              ..strokeWidth = 0.8,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(SynastryWheelPainter oldDelegate) =>
      oldDelegate.chart1 != chart1 || oldDelegate.chart2 != chart2;
}
