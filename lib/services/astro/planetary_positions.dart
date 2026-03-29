import 'dart:math';
import 'chiron.dart';
import 'lilith.dart';

class PlanetaryPositions {
  PlanetaryPositions._();

  static double _normalize(double deg) {
    var d = deg % 360.0;
    if (d < 0) d += 360.0;
    return d;
  }

  static double _rad(double deg) => deg * pi / 180.0;

  static double sunLongitude(double t) {
    final m = _normalize(357.5291092 + 35999.0502909 * t);
    final mRad = _rad(m);
    final c = (1.9146 - 0.004817 * t - 0.000014 * t * t) * sin(mRad) +
        (0.019993 - 0.000101 * t) * sin(2 * mRad) +
        0.00029 * sin(3 * mRad);
    final sunLon = _normalize(280.46646 + 36000.76983 * t + c);
    return sunLon;
  }

  static double moonLongitude(double t) {
    final lp = _normalize(218.3165 + 481267.8813 * t);
    final d = _normalize(297.8502 + 445267.1115 * t);
    final m = _normalize(357.5291 + 35999.0503 * t);
    final mp = _normalize(134.9634 + 477198.8676 * t);
    final f = _normalize(93.2721 + 483202.0175 * t);

    final dR = _rad(d);
    final mR = _rad(m);
    final mpR = _rad(mp);
    final fR = _rad(f);

    var lon = lp +
        6.289 * sin(mpR) +
        1.274 * sin(2 * dR - mpR) +
        0.658 * sin(2 * dR) +
        0.214 * sin(2 * mpR) -
        0.186 * sin(mR) -
        0.114 * sin(2 * fR) +
        0.059 * sin(2 * dR - 2 * mpR) +
        0.057 * sin(2 * dR - mR - mpR);

    return _normalize(lon);
  }

  static double mercuryLongitude(double t) {
    final l = _normalize(252.2509 + 149472.6746 * t);
    final a = _rad(l);
    return _normalize(l +
        23.4400 * sin(a) +
        2.9818 * sin(2 * a) +
        0.5255 * sin(3 * a) -
        0.1558 * sin(4 * a) +
        6.3 * sin(_rad(_normalize(119.0 + 36000.8 * t))));
  }

  static double venusLongitude(double t) {
    final l = _normalize(181.9798 + 58517.8157 * t);
    final a = _rad(l);
    return _normalize(l +
        0.7758 * sin(a) +
        0.0033 * sin(2 * a) +
        0.4689 * sin(_rad(_normalize(357.5 + 35999.1 * t))));
  }

  static double marsLongitude(double t) {
    final l = _normalize(355.4330 + 19140.2993 * t);
    final m = _rad(l);
    return _normalize(l +
        10.6912 * sin(m) +
        0.6228 * sin(2 * m) +
        0.0503 * sin(3 * m) +
        0.3230 * sin(_rad(_normalize(357.5 + 35999.1 * t))));
  }

  static double jupiterLongitude(double t) {
    final l = _normalize(34.3515 + 3034.9057 * t);
    final m = _rad(l);
    return _normalize(l +
        5.5549 * sin(m) +
        0.1683 * sin(2 * m) -
        0.1859 * sin(_rad(_normalize(355.4 + 19140.3 * t))));
  }

  static double saturnLongitude(double t) {
    final l = _normalize(50.0774 + 1222.1138 * t);
    final m = _rad(l);
    return _normalize(l +
        6.3585 * sin(m) +
        0.2204 * sin(2 * m) -
        0.2130 * sin(_rad(_normalize(34.4 + 3034.9 * t))));
  }

  static double uranusLongitude(double t) {
    final l = _normalize(314.0550 + 428.9469 * t);
    final m = _rad(l);
    return _normalize(l +
        1.3324 * sin(m) +
        0.0624 * sin(2 * m));
  }

  static double neptuneLongitude(double t) {
    final l = _normalize(304.3487 + 218.4862 * t);
    final m = _rad(l);
    return _normalize(l +
        0.7737 * sin(m));
  }

  static double plutoLongitude(double t) {
    final l = _normalize(238.9286 + 145.1781 * t);
    final m = _rad(l);
    return _normalize(l +
        6.3358 * sin(m) +
        0.3458 * sin(2 * m));
  }

  static double northNodeLongitude(double t) {
    // Mean Lunar North Node (Ω) — Meeus, Astronomical Algorithms
    final omega = 125.04452 - 1934.136261 * t + 0.0020708 * t * t + t * t * t / 450000.0;
    return _normalize(omega);
  }

  static double southNodeLongitude(double t) {
    return _normalize(northNodeLongitude(t) + 180.0);
  }

  static Map<String, double> allPositions(double t) {
    final sunLon = sunLongitude(t);
    return {
      'sun': sunLon,
      'moon': moonLongitude(t),
      'mercury': mercuryLongitude(t),
      'venus': venusLongitude(t),
      'mars': marsLongitude(t),
      'jupiter': jupiterLongitude(t),
      'saturn': saturnLongitude(t),
      'uranus': uranusLongitude(t),
      'neptune': neptuneLongitude(t),
      'pluto': plutoLongitude(t),
      'northNode': northNodeLongitude(t),
      'southNode': southNodeLongitude(t),
      'chiron': ChironCalculator.chironLongitude(t, sunLon),
      'lilith': LilithCalculator.lilithLongitude(t),
    };
  }

  /// Calculate daily motion (degrees/day) for all bodies.
  static Map<String, double> allSpeeds(double t) {
    final pos1 = allPositions(t);
    final pos2 = allPositions(t + 1.0 / 36525.0); // 1 day later
    final speeds = <String, double>{};
    for (final key in pos1.keys) {
      var diff = pos2[key]! - pos1[key]!;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;
      speeds[key] = diff;
    }
    return speeds;
  }
}
