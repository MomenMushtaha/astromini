import '../../models/planet_position.dart';
import '../../models/chart_analysis_result.dart';
import 'dignities.dart';

/// Central chart analysis: chart ruler, sect, Part of Fortune,
/// mutual receptions, hemisphere balance, and planetary speed status.
class ChartAnalysis {
  ChartAnalysis._();

  // --- Sign rulers (inverted domicile lookup) ---
  static const _signRulers = <String, CelestialBody>{
    'Aries': CelestialBody.mars,
    'Taurus': CelestialBody.venus,
    'Gemini': CelestialBody.mercury,
    'Cancer': CelestialBody.moon,
    'Leo': CelestialBody.sun,
    'Virgo': CelestialBody.mercury,
    'Libra': CelestialBody.venus,
    'Scorpio': CelestialBody.pluto,
    'Sagittarius': CelestialBody.jupiter,
    'Capricorn': CelestialBody.saturn,
    'Aquarius': CelestialBody.saturn,
    'Pisces': CelestialBody.neptune,
  };

  /// The chart ruler is the planet that rules the Ascendant sign.
  static CelestialBody chartRuler(String risingSign) {
    return _signRulers[risingSign] ?? CelestialBody.sun;
  }

  /// Determine sect: Day chart if Sun is above the horizon, Night otherwise.
  /// Simplified: Sun above horizon ≈ Sun in houses 7-12.
  static Sect determineSect(double sunLon, double ascendant) {
    // Sun is above the horizon when its longitude is between
    // the Descendant (ASC + 180) going clockwise to the Ascendant.
    final desc = (ascendant + 180.0) % 360.0;
    final sunNorm = sunLon % 360.0;

    // Check if Sun is in the upper half (between DESC → ASC going through MC)
    bool aboveHorizon;
    if (desc < ascendant) {
      // DESC is a lower degree than ASC (normal case)
      aboveHorizon = sunNorm >= desc && sunNorm < ascendant;
    } else {
      // Wraps around 360
      aboveHorizon = sunNorm >= desc || sunNorm < ascendant;
    }
    return aboveHorizon ? Sect.day : Sect.night;
  }

  /// Part of Fortune: major Arabic Part.
  /// Day: ASC + Moon - Sun. Night: ASC + Sun - Moon.
  static double partOfFortune(
    double ascendant,
    double sunLon,
    double moonLon,
    Sect sect,
  ) {
    double pof;
    if (sect == Sect.day) {
      pof = ascendant + moonLon - sunLon;
    } else {
      pof = ascendant + sunLon - moonLon;
    }
    return ((pof % 360.0) + 360.0) % 360.0;
  }

  /// Find mutual receptions: planets in each other's ruling signs.
  static List<MutualReception> findMutualReceptions(
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final receptions = <MutualReception>[];
    final bodies = planets.keys.toList();

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final p1 = bodies[i];
        final p2 = bodies[j];
        final sign1 = planets[p1]!.zodiacPosition.sign;
        final sign2 = planets[p2]!.zodiacPosition.sign;

        // p1 is in p2's ruling sign AND p2 is in p1's ruling sign
        final p1Rules = Dignities.domicile[p1] ?? [];
        final p2Rules = Dignities.domicile[p2] ?? [];

        if (p2Rules.contains(sign1) && p1Rules.contains(sign2)) {
          receptions.add(MutualReception(
            planet1: p1,
            planet2: p2,
            sign1: sign1,
            sign2: sign2,
          ));
        }
      }
    }
    return receptions;
  }

  /// Hemisphere and quadrant balance.
  static Map<String, int> hemisphereBalance(
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    int northern = 0, southern = 0, eastern = 0, western = 0;

    for (final pos in planets.values) {
      final h = pos.house;
      // Northern hemisphere: houses 1-6 (below horizon, personal)
      if (h >= 1 && h <= 6) northern++;
      // Southern hemisphere: houses 7-12 (above horizon, public)
      if (h >= 7 && h <= 12) southern++;
      // Eastern hemisphere: houses 10, 11, 12, 1, 2, 3 (self-directed)
      if (h >= 10 || h <= 3) eastern++;
      // Western hemisphere: houses 4, 5, 6, 7, 8, 9 (relationship-oriented)
      if (h >= 4 && h <= 9) western++;
    }

    return {
      'Northern': northern,
      'Southern': southern,
      'Eastern': eastern,
      'Western': western,
    };
  }

  // --- Planetary Speed Status ---
  // Average daily motions in degrees/day for each planet.
  static const _averageDailyMotion = <CelestialBody, double>{
    CelestialBody.sun: 0.986,
    CelestialBody.moon: 13.176,
    CelestialBody.mercury: 1.383,
    CelestialBody.venus: 1.200,
    CelestialBody.mars: 0.524,
    CelestialBody.jupiter: 0.083,
    CelestialBody.saturn: 0.034,
    CelestialBody.uranus: 0.012,
    CelestialBody.neptune: 0.006,
    CelestialBody.pluto: 0.004,
    CelestialBody.chiron: 0.020,
  };

  /// Returns speed status or null if normal.
  /// Stationary: <10% of average (extremely powerful).
  /// Swift: >120% of average (energized).
  static String? speedStatus(CelestialBody body, double dailyMotion) {
    final avg = _averageDailyMotion[body];
    if (avg == null) return null;

    final absMotion = dailyMotion.abs();
    if (absMotion < avg * 0.10) return 'Stationary';
    if (absMotion > avg * 1.20) return 'Swift';
    return null;
  }
}
