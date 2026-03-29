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
  pluto,
  northNode,
  southNode,
  chiron,
  lilith;

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
      case northNode: return '\u260A';
      case southNode: return '\u260B';
      case chiron: return '\u26B7';
      case lilith: return '\u26B8';
    }
  }

  String get displayName {
    switch (this) {
      case northNode: return 'North Node';
      case southNode: return 'South Node';
      case lilith: return 'Black Moon Lilith';
      default: return name[0].toUpperCase() + name.substring(1);
    }
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
  final double? dailyMotion;
  final double? declination;
  final String? decan;
  final int? dignityScore;
  final String? combustionStatus;
  final String? speedStatus;

  const PlanetPosition({
    required this.body,
    required this.eclipticLongitude,
    required this.zodiacPosition,
    required this.house,
    this.isRetrograde = false,
    this.dailyMotion,
    this.declination,
    this.decan,
    this.dignityScore,
    this.combustionStatus,
    this.speedStatus,
  });
}
