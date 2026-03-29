/// Black Moon Lilith (Mean Lunar Apogee) calculator.
/// Lilith represents the point where the Moon's orbit is farthest from Earth.
class LilithCalculator {
  LilithCalculator._();

  static double _normalize(double deg) {
    var d = deg % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }

  /// Calculate Mean Black Moon Lilith longitude.
  /// [t] is Julian centuries from J2000.0.
  static double lilithLongitude(double t) {
    // Mean lunar apogee (Black Moon Lilith)
    // Based on Meeus, Astronomical Algorithms
    final lon = 83.3532430 + 4069.0137111 * t -
        0.0103238 * t * t -
        t * t * t / 80053.0 +
        t * t * t * t / 18999000.0;
    return _normalize(lon);
  }
}
