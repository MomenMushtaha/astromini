import 'dart:math';

/// Calculates planetary declination and detects out-of-bounds conditions.
class DeclinationCalculator {
  DeclinationCalculator._();

  /// Calculate the declination of a body given its ecliptic longitude.
  /// This assumes ~0° ecliptic latitude (adequate for planets near the ecliptic).
  static double declination(double eclipticLon, double obliquity) {
    final lonRad = eclipticLon * pi / 180.0;
    final oblRad = obliquity * pi / 180.0;
    return asin(sin(oblRad) * sin(lonRad)) * 180.0 / pi;
  }

  /// A planet is out-of-bounds when its declination exceeds
  /// the Sun's maximum declination (~23.44°).
  static bool isOutOfBounds(double dec) {
    return dec.abs() > 23.44;
  }
}
