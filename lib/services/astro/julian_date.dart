import 'dart:math';

class JulianDate {
  JulianDate._();

  static double fromDateTime(DateTime dt) {
    final utc = dt.toUtc();
    int y = utc.year;
    int m = utc.month;
    final double d = utc.day +
        utc.hour / 24.0 +
        utc.minute / 1440.0 +
        utc.second / 86400.0;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();

    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Julian centuries since J2000.0 (Jan 1 2000 12:00 UTC)
  static double toJulianCentury(double jd) {
    return (jd - 2451545.0) / 36525.0;
  }

  /// Greenwich Mean Sidereal Time in degrees
  static double gmst(double jd) {
    final t = toJulianCentury(jd);
    var theta = 280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        t * t * t / 38710000.0;
    return _normalize(theta);
  }

  /// Local Sidereal Time in degrees
  static double lst(double jd, double longitude) {
    return _normalize(gmst(jd) + longitude);
  }

  /// Obliquity of the ecliptic in degrees
  static double obliquity(double t) {
    return 23.439291 - 0.0130042 * t - 1.64e-7 * t * t + 5.04e-7 * t * t * t;
  }

  static double _normalize(double degrees) {
    var d = degrees % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }

  static double toRadians(double degrees) => degrees * pi / 180.0;
  static double toDegrees(double radians) => radians * 180.0 / pi;
}
