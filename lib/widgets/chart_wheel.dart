import 'package:flutter/material.dart';
import '../models/birth_chart.dart';
import 'chart_wheel_painter.dart';

class ChartWheel extends StatelessWidget {
  final BirthChart chart;
  final double size;

  const ChartWheel({super.key, required this.chart, this.size = 320});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ChartWheelPainter(chart),
        size: Size(size, size),
      ),
    );
  }
}
