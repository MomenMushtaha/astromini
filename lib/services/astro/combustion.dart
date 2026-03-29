import '../../models/planet_position.dart';

/// Detects combustion status — planets too close to the Sun.
/// Cazimi (in the Sun's heart): extremely powerful.
/// Combust: weakened by Sun's overwhelming light.
/// Under the Beams: slightly diminished.
class CombustionCalculator {
  CombustionCalculator._();

  static double _angularDistance(double lon1, double lon2) {
    var diff = (lon1 - lon2).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  /// Returns combustion status or null if planet is free from Sun's influence.
  static String? combustionStatus(
    CelestialBody body,
    double bodyLon,
    double sunLon, {
    bool isRetrograde = false,
  }) {
    // Sun, Moon, and nodes are exempt
    if (body == CelestialBody.sun ||
        body == CelestialBody.moon ||
        body == CelestialBody.northNode ||
        body == CelestialBody.southNode) {
      return null;
    }

    final dist = _angularDistance(bodyLon, sunLon);

    // Cazimi: within 0°17' (0.283°) — planet in the heart of the Sun
    if (dist <= 0.283) return 'Cazimi';

    // Combust: within 8°30' for most planets
    // Mercury gets 14° when retrograde, 12° when direct (closer to Sun more often)
    final combustOrb = (body == CelestialBody.mercury)
        ? (isRetrograde ? 14.0 : 12.0)
        : 8.5;
    if (dist <= combustOrb) return 'Combust';

    // Under the Beams: within 17°
    if (dist <= 17.0) return 'Under the Beams';

    return null;
  }
}
