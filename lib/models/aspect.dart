import 'dart:ui';

import 'planet_position.dart';

enum AspectType {
  conjunction(0, 8, 'Conjunction'),
  sextile(60, 6, 'Sextile'),
  square(90, 7, 'Square'),
  trine(120, 8, 'Trine'),
  opposition(180, 8, 'Opposition');

  final double angle;
  final double maxOrb;
  final String displayName;

  const AspectType(this.angle, this.maxOrb, this.displayName);

  Color get color {
    switch (this) {
      case conjunction: return const Color(0xFFFFD54F);
      case sextile: return const Color(0xFF66BB6A);
      case square: return const Color(0xFFEF5350);
      case trine: return const Color(0xFF42A5F5);
      case opposition: return const Color(0xFFFF7043);
    }
  }

  bool get isHarmonious =>
      this == conjunction || this == trine || this == sextile;
}

class Aspect {
  final CelestialBody planet1;
  final CelestialBody planet2;
  final AspectType type;
  final double exactAngle;
  final double orb;

  const Aspect({
    required this.planet1,
    required this.planet2,
    required this.type,
    required this.exactAngle,
    required this.orb,
  });

  String get formatted =>
      '${planet1.displayName} ${type.displayName} ${planet2.displayName} (orb: ${orb.toStringAsFixed(1)}\u00B0)';
}
