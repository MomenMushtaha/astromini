import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScoreMeter extends StatelessWidget {
  final String label;
  final double score;
  final double size;

  const ScoreMeter({
    super.key,
    required this.label,
    required this.score,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ScoreArcPainter(score: score, color: color),
            child: Center(
              child: Text(
                '${score.round()}%',
                style: TextStyle(
                  color: color,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: size < 80 ? 10 : 12,
          ),
        ),
      ],
    );
  }

  Color _scoreColor(double score) {
    if (score >= 80) return const Color(0xFF66BB6A);
    if (score >= 60) return const Color(0xFFFFD54F);
    if (score >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }
}

class _ScoreArcPainter extends CustomPainter {
  final double score;
  final Color color;

  _ScoreArcPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2 - 4;
    final strokeWidth = r * 0.15;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -pi / 2,
      2 * pi,
      false,
      Paint()
        ..color = color.withAlpha(20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Score arc
    final sweep = (score / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -pi / 2,
      sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ScoreArcPainter oldDelegate) =>
      oldDelegate.score != score;
}
