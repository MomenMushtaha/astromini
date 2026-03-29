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

  /// Equal House system: each house = 30° from Ascendant.
  static List<double> calculateEqualHouses(double ascDeg) {
    final cusps = <double>[];
    for (int i = 0; i < 12; i++) {
      cusps.add(_normalize(ascDeg + i * 30.0));
    }
    return cusps;
  }

  /// Backward-compatible alias.
  static List<double> calculateHouses(double ascDeg) =>
      calculateEqualHouses(ascDeg);

  /// Placidus house system — unequal houses based on semi-arc division.
  /// Falls back to Equal House for |latitude| > 60° where Placidus fails.
  static List<double> calculatePlacidusHouses(
    double ascDeg,
    double mcDeg,
    double lstDeg,
    double latDeg,
    double oblDeg,
  ) {
    if (latDeg.abs() > 60.0) return calculateEqualHouses(ascDeg);

    final lat = JulianDate.toRadians(latDeg);
    final obl = JulianDate.toRadians(oblDeg);
    final ramc = JulianDate.toRadians(lstDeg);

    final cusps = List<double>.filled(12, 0.0);
    cusps[0] = ascDeg; // 1st house = Ascendant
    cusps[9] = mcDeg; // 10th house = MC
    cusps[3] = _normalize(mcDeg + 180.0); // 4th house = IC
    cusps[6] = _normalize(ascDeg + 180.0); // 7th house = Descendant

    // Placidus intermediate cusps via semi-arc trisection
    // Cusps 11, 12 (above horizon) and 2, 3 (below horizon)
    final offsets = {
      10: pi / 3.0, // 11th cusp: 1/3 of diurnal semi-arc from MC
      11: 2.0 * pi / 3.0, // 12th cusp: 2/3 from MC
      1: pi + pi / 3.0, // 2nd cusp: 1/3 of nocturnal semi-arc from IC
      2: pi + 2.0 * pi / 3.0, // 3rd cusp: 2/3 from IC
    };

    for (final entry in offsets.entries) {
      final houseIdx = entry.key;
      final f = entry.value;

      // Iterative Placidus formula
      double cusp = _normalize(mcDeg + (f * 180.0 / pi));
      for (int iter = 0; iter < 5; iter++) {
        final ramcOffset = ramc + f;
        final tanDec = tan(obl) * sin(ramcOffset);
        final dec = atan(tanDec);
        final ad = asin(tan(lat) * tan(dec));
        double ra;
        if (houseIdx <= 2) {
          // Below horizon cusps
          ra = ramc + f + ad * (f / (pi));
        } else {
          // Above horizon cusps
          ra = ramc + f - ad * (f / (pi));
        }
        final newCusp = atan2(sin(ra), cos(ra) * cos(obl));
        cusp = _normalize(JulianDate.toDegrees(newCusp));
      }
      cusps[houseIdx] = cusp;
    }

    // Fill remaining cusps (4-6, 7-9 are opposites of 10-12, 1-3)
    cusps[4] = _normalize(cusps[10] + 180.0);
    cusps[5] = _normalize(cusps[11] + 180.0);
    cusps[7] = _normalize(cusps[1] + 180.0);
    cusps[8] = _normalize(cusps[2] + 180.0);

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

  /// Vertex: the Ascendant at co-latitude (90° - latitude).
  /// The Vertex is a fated encounter point, always in houses 5-8.
  static double vertex(double lstDeg, double latDeg, double oblDeg) {
    final coLatitude = 90.0 - latDeg;
    return ascendant(lstDeg, coLatitude, oblDeg);
  }

  static double _normalize(double deg) {
    var d = deg % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }
}
