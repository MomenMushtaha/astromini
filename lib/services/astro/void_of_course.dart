/// Detects Void of Course Moon — when the Moon makes no major aspects
/// to any planet before leaving its current sign.
class VoidOfCourseMoon {
  VoidOfCourseMoon._();

  static const _majorAspectAngles = [0.0, 60.0, 90.0, 120.0, 180.0];
  static const _aspectOrb = 8.0;

  /// Check if the Moon is void of course.
  /// [moonLon] is Moon's current ecliptic longitude.
  /// [moonSpeed] is Moon's daily motion in degrees.
  /// [planetPositions] are all other body longitudes (excluding Moon).
  static bool isVoidOfCourse(
    double moonLon,
    double moonSpeed,
    Map<String, double> planetPositions,
  ) {
    if (moonSpeed.abs() < 0.001) return false; // Safety

    // Current Moon sign: which 30° sector
    final currentSignStart = (moonLon / 30.0).floor() * 30.0;
    final signEnd = currentSignStart + 30.0;

    // Degrees remaining in current sign
    final degreesLeft = signEnd - moonLon;
    if (degreesLeft <= 0) return false;

    // Check if Moon will make any major aspect before leaving the sign
    // Sample Moon positions at 0.5° intervals until sign boundary
    final steps = (degreesLeft / 0.5).ceil();
    for (int step = 1; step <= steps; step++) {
      final futureMoonLon = (moonLon + step * 0.5) % 360.0;

      // Check if still in same sign
      if (((futureMoonLon / 30.0).floor() * 30.0) != currentSignStart) break;

      for (final planetLon in planetPositions.values) {
        var sep = (futureMoonLon - planetLon).abs();
        if (sep > 180) sep = 360 - sep;

        for (final angle in _majorAspectAngles) {
          if ((sep - angle).abs() <= _aspectOrb) {
            return false; // Moon will make an aspect before leaving the sign
          }
        }
      }
    }

    return true; // No aspects found — Moon is void of course
  }
}
