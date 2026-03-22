import 'dart:math';
import 'package:flutter/material.dart';
import '../models/birth_chart.dart';
import '../models/planet_position.dart';
import '../models/aspect.dart';
import '../services/astro/zodiac_util.dart';

class ChartWheelPainter extends CustomPainter {
  final BirthChart chart;

  ChartWheelPainter(this.chart);

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
    final innerR = outerR * 0.72;
    final planetR = outerR * 0.58;
    final aspectR = outerR * 0.38;

    final ascRot = -chart.ascendant * pi / 180 + pi;

    _drawOuterRing(canvas, center, outerR, innerR, ascRot);
    _drawHouseLines(canvas, center, innerR, outerR * 0.45, ascRot);
    _drawAspectLines(canvas, center, aspectR, ascRot);
    _drawPlanets(canvas, center, planetR, innerR, ascRot);
  }

  void _drawOuterRing(
      Canvas canvas, Offset center, double outerR, double innerR, double ascRot) {
    for (int i = 0; i < 12; i++) {
      final startAngle = (i * 30) * pi / 180 + ascRot;
      final sweepAngle = 30 * pi / 180;

      final sign = ZodiacUtil.signNames[i];
      final element = ZodiacUtil.signElements[sign] ?? 'Fire';
      final color = _elementColors[element]!;

      // Draw arc segment
      final paint = Paint()
        ..color = color.withAlpha(40)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(
            center.dx + innerR * cos(startAngle),
            center.dy + innerR * sin(startAngle))
        ..arcTo(Rect.fromCircle(center: center, radius: outerR), startAngle,
            sweepAngle, false)
        ..lineTo(
            center.dx + innerR * cos(startAngle + sweepAngle),
            center.dy + innerR * sin(startAngle + sweepAngle))
        ..arcTo(Rect.fromCircle(center: center, radius: innerR),
            startAngle + sweepAngle, -sweepAngle, false)
        ..close();

      canvas.drawPath(path, paint);

      // Draw border
      final borderPaint = Paint()
        ..color = color.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawPath(path, borderPaint);

      // Draw sign symbol
      final midAngle = startAngle + sweepAngle / 2;
      final symbolR = (outerR + innerR) / 2;
      final symbolPos = Offset(
        center.dx + symbolR * cos(midAngle),
        center.dy + symbolR * sin(midAngle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: ZodiacUtil.signSymbols[i],
          style: TextStyle(fontSize: 14, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        symbolPos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Inner circle
    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..color = Colors.white.withAlpha(20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawHouseLines(
      Canvas canvas, Offset center, double innerR, double labelR, double ascRot) {
    final linePaint = Paint()
      ..color = Colors.white.withAlpha(30)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 12; i++) {
      final angle = chart.houseCusps[i] * pi / 180 + ascRot - pi;
      final inner = Offset(
          center.dx + labelR * cos(angle), center.dy + labelR * sin(angle));
      final outer = Offset(
          center.dx + innerR * cos(angle), center.dy + innerR * sin(angle));

      canvas.drawLine(inner, outer, linePaint);

      // House number
      final numR = labelR - 12;
      final numPos = Offset(
        center.dx + numR * cos(angle + 15 * pi / 180),
        center.dy + numR * sin(angle + 15 * pi / 180),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(fontSize: 9, color: Colors.white.withAlpha(60)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, numPos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  void _drawAspectLines(
      Canvas canvas, Offset center, double r, double ascRot) {
    for (final aspect in chart.aspects) {
      final lon1 = chart.planets[aspect.planet1]!.eclipticLongitude;
      final lon2 = chart.planets[aspect.planet2]!.eclipticLongitude;

      final a1 = lon1 * pi / 180 + ascRot - pi;
      final a2 = lon2 * pi / 180 + ascRot - pi;

      final p1 = Offset(center.dx + r * cos(a1), center.dy + r * sin(a1));
      final p2 = Offset(center.dx + r * cos(a2), center.dy + r * sin(a2));

      final opacity = (1.0 - aspect.orb / aspect.type.maxOrb).clamp(0.2, 0.8);
      final paint = Paint()
        ..color = aspect.type.color.withAlpha((opacity * 255).round())
        ..strokeWidth = aspect.type.isHarmonious ? 1.0 : 0.8;

      if (aspect.type == AspectType.opposition) {
        _drawDashedLine(canvas, p1, p2, paint);
      } else {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final dist = sqrt(dx * dx + dy * dy);
    final dashLen = 4.0;
    final gaps = (dist / (dashLen * 2)).floor();

    for (int i = 0; i < gaps; i++) {
      final t1 = i * dashLen * 2 / dist;
      final t2 = (i * dashLen * 2 + dashLen) / dist;
      canvas.drawLine(
        Offset(p1.dx + dx * t1, p1.dy + dy * t1),
        Offset(p1.dx + dx * t2, p1.dy + dy * t2),
        paint,
      );
    }
  }

  void _drawPlanets(
      Canvas canvas, Offset center, double planetR, double innerR, double ascRot) {
    final positions = <double, List<CelestialBody>>{};

    // Group close planets
    for (final entry in chart.planets.entries) {
      final lon = entry.value.eclipticLongitude;
      final bucket = (lon / 5).round() * 5.0;
      positions.putIfAbsent(bucket, () => []).add(entry.key);
    }

    for (final entry in chart.planets.entries) {
      final body = entry.key;
      final pos = entry.value;
      final angle = pos.eclipticLongitude * pi / 180 + ascRot - pi;

      final pt = Offset(
        center.dx + planetR * cos(angle),
        center.dy + planetR * sin(angle),
      );

      // Glyph
      final color = pos.isRetrograde
          ? const Color(0xFFEF5350)
          : const Color(0xFFE8E8F0);

      final tp = TextPainter(
        text: TextSpan(
          text: body.symbol,
          style: TextStyle(fontSize: 14, color: color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pt - Offset(tp.width / 2, tp.height / 2));

      // Small line to exact position on inner ring
      final exactPt = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      canvas.drawLine(
        pt + Offset(0, tp.height / 2 + 2),
        exactPt,
        Paint()
          ..color = Colors.white.withAlpha(20)
          ..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(ChartWheelPainter oldDelegate) =>
      oldDelegate.chart != chart;
}
