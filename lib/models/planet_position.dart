enum CelestialBody {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto;

  String get symbol {
    switch (this) {
      case sun: return '\u2609';
      case moon: return '\u263D';
      case mercury: return '\u263F';
      case venus: return '\u2640';
      case mars: return '\u2642';
      case jupiter: return '\u2643';
      case saturn: return '\u2644';
      case uranus: return '\u2645';
      case neptune: return '\u2646';
      case pluto: return '\u2647';
    }
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}

class ZodiacPosition {
  final String sign;
  final int degree;
  final int minute;

  const ZodiacPosition({
    required this.sign,
    required this.degree,
    required this.minute,
  });

  String get formatted => '$degree\u00B0$minute\' $sign';
}

class PlanetPosition {
  final CelestialBody body;
  final double eclipticLongitude;
  final ZodiacPosition zodiacPosition;
  final int house;
  final bool isRetrograde;

  const PlanetPosition({
    required this.body,
    required this.eclipticLongitude,
    required this.zodiacPosition,
    required this.house,
    this.isRetrograde = false,
  });
}
