import 'dart:math';

/// Chiron position calculator using simplified orbital elements.
/// Chiron orbits between Saturn and Uranus with a ~50.7 year period.
class ChironCalculator {
  ChironCalculator._();

  static double _normalize(double deg) {
    var d = deg % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }

  static double _rad(double deg) => deg * pi / 180.0;

  /// Calculate Chiron's geocentric ecliptic longitude.
  /// [t] is Julian centuries from J2000.0, [sunLon] is Sun's ecliptic longitude.
  static double chironLongitude(double t, double sunLon) {
    // Orbital elements at epoch J2000.0
    const a = 13.648; // semi-major axis (AU)
    const e = 0.37891; // eccentricity
    const i = 6.930; // inclination (degrees)
    const omega = 339.432; // longitude of perihelion (degrees)
    const node = 209.213; // longitude of ascending node (degrees)
    const L0 = 209.39; // mean longitude at epoch (degrees)
    const n = 0.01943; // mean daily motion (degrees/day)

    // Days since J2000.0
    final days = t * 36525.0;

    // Mean anomaly
    final M = _normalize(L0 + n * days - omega);
    final mRad = _rad(M);

    // Solve Kepler's equation: E - e*sin(E) = M (iteratively)
    var E = mRad;
    for (int iter = 0; iter < 8; iter++) {
      E = mRad + e * sin(E);
    }

    // True anomaly
    final sinV = sqrt(1 - e * e) * sin(E) / (1 - e * cos(E));
    final cosV = (cos(E) - e) / (1 - e * cos(E));
    final v = atan2(sinV, cosV);

    // Heliocentric ecliptic longitude
    final omegaRad = _rad(omega);
    final nodeRad = _rad(node);
    final iRad = _rad(i);

    // Argument of latitude
    final u = v + omegaRad - nodeRad;

    // Heliocentric ecliptic longitude
    final helioLon = _normalize(
      atan2(cos(iRad) * sin(u), cos(u)) * 180.0 / pi + node,
    );

    // Heliocentric radius
    final r = a * (1 - e * cos(E));

    // Convert to geocentric (approximate: Earth at 1 AU opposite Sun)
    final helioRad = _rad(helioLon);
    final sunRad = _rad(sunLon);

    // Geocentric correction
    final earthSunDist = 1.0; // AU approximately
    final dx = r * cos(helioRad) - earthSunDist * cos(sunRad + pi);
    final dy = r * sin(helioRad) - earthSunDist * sin(sunRad + pi);
    final geoLon = atan2(dy, dx) * 180.0 / pi;

    return _normalize(geoLon);
  }
}
