import 'dart:math';

import 'julian_date.dart';

class HouseSystem {
  HouseSystem._();

  static double ascendant(double lstDeg, double latDeg, double oblDeg) {
    final lst = JulianDate.toRadians(lstDeg);
    final lat = JulianDate.toRadians(latDeg);
    final obl = JulianDate.toRadians(oblDeg);

    final y = -cos(lst);
    final x = sin(obl) * tan(lat) + cos(obl) * sin(lst);
    var asc = atan2(y, x);
    asc = JulianDate.toDegrees(asc);
    return _normalize(asc);
  }

  static double midheaven(double lstDeg, double oblDeg) {
    final lst = JulianDate.toRadians(lstDeg);
    final obl = JulianDate.toRadians(oblDeg);

    var mc = atan2(sin(lst), cos(lst) * cos(obl));
    mc = JulianDate.toDegrees(mc);
    return _normalize(mc);
  }

  /// Returns 12 house cusps in ecliptic longitude degrees.
  /// Uses Equal House system (simpler, reliable, widely used).
  static List<double> calculateHouses(double ascDeg) {
    final cusps = <double>[];
    for (int i = 0; i < 12; i++) {
      cusps.add(_normalize(ascDeg + i * 30.0));
    }
    return cusps;
  }

  /// Determine which house a planet at the given longitude is in (1-12).
  static int getHouse(double longitude, List<double> cusps) {
    for (int i = 0; i < 12; i++) {
      final next = (i + 1) % 12;
      final start = cusps[i];
      final end = cusps[next];

      if (start < end) {
        if (longitude >= start && longitude < end) return i + 1;
      } else {
        // Wraps around 360
        if (longitude >= start || longitude < end) return i + 1;
      }
    }
    return 1;
  }

  static double _normalize(double deg) {
    var d = deg % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }
}
