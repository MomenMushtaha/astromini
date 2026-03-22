import '../../models/birth_chart.dart';
import '../../models/birth_data.dart';
import '../../models/planet_position.dart';
import 'aspects.dart';
import 'house_system.dart';
import 'julian_date.dart';
import 'planetary_positions.dart';
import 'zodiac_util.dart';

class AstroEngine {
  AstroEngine._();

  static BirthChart calculateChart(BirthData birthData) {
    final utc = birthData.birthDateTimeUtc;
    final jd = JulianDate.fromDateTime(utc);
    final t = JulianDate.toJulianCentury(jd);
    final obl = JulianDate.obliquity(t);
    final lstDeg = JulianDate.lst(jd, birthData.longitude);

    // Calculate Ascendant and Midheaven
    final asc = HouseSystem.ascendant(lstDeg, birthData.latitude, obl);
    final mc = HouseSystem.midheaven(lstDeg, obl);
    final houseCusps = HouseSystem.calculateHouses(asc);

    // Calculate planetary positions
    final rawPositions = PlanetaryPositions.allPositions(t);

    // Check retrogrades (compare with position 1 day later)
    final tNext = JulianDate.toJulianCentury(jd + 1);
    final nextPositions = PlanetaryPositions.allPositions(tNext);

    final bodyMap = <String, CelestialBody>{
      'sun': CelestialBody.sun,
      'moon': CelestialBody.moon,
      'mercury': CelestialBody.mercury,
      'venus': CelestialBody.venus,
      'mars': CelestialBody.mars,
      'jupiter': CelestialBody.jupiter,
      'saturn': CelestialBody.saturn,
      'uranus': CelestialBody.uranus,
      'neptune': CelestialBody.neptune,
      'pluto': CelestialBody.pluto,
    };

    final planets = <CelestialBody, PlanetPosition>{};
    for (final entry in rawPositions.entries) {
      final body = bodyMap[entry.key]!;
      final lon = entry.value;
      final nextLon = nextPositions[entry.key]!;

      // Retrograde if longitude decreased (accounting for 360 wrap)
      var diff = nextLon - lon;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;
      final isRetro = diff < 0 && body != CelestialBody.sun && body != CelestialBody.moon;

      planets[body] = PlanetPosition(
        body: body,
        eclipticLongitude: lon,
        zodiacPosition: ZodiacUtil.getPosition(lon),
        house: HouseSystem.getHouse(lon, houseCusps),
        isRetrograde: isRetro,
      );
    }

    // Calculate aspects
    final aspects = AspectCalculator.calculateAspects(planets);

    return BirthChart(
      birthData: birthData,
      planets: planets,
      houseCusps: houseCusps,
      ascendant: asc,
      midheaven: mc,
      aspects: aspects,
    );
  }

  /// Calculate current planetary positions (for sky map)
  static Map<CelestialBody, PlanetPosition> currentPositions() {
    final now = DateTime.now().toUtc();
    final jd = JulianDate.fromDateTime(now);
    final t = JulianDate.toJulianCentury(jd);

    final rawPositions = PlanetaryPositions.allPositions(t);
    final tNext = JulianDate.toJulianCentury(jd + 1);
    final nextPositions = PlanetaryPositions.allPositions(tNext);

    final bodyMap = <String, CelestialBody>{
      'sun': CelestialBody.sun,
      'moon': CelestialBody.moon,
      'mercury': CelestialBody.mercury,
      'venus': CelestialBody.venus,
      'mars': CelestialBody.mars,
      'jupiter': CelestialBody.jupiter,
      'saturn': CelestialBody.saturn,
      'uranus': CelestialBody.uranus,
      'neptune': CelestialBody.neptune,
      'pluto': CelestialBody.pluto,
    };

    final planets = <CelestialBody, PlanetPosition>{};
    for (final entry in rawPositions.entries) {
      final body = bodyMap[entry.key]!;
      final lon = entry.value;
      final nextLon = nextPositions[entry.key]!;
      var diff = nextLon - lon;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;
      final isRetro = diff < 0 && body != CelestialBody.sun && body != CelestialBody.moon;

      planets[body] = PlanetPosition(
        body: body,
        eclipticLongitude: lon,
        zodiacPosition: ZodiacUtil.getPosition(lon),
        house: 1, // No houses for sky map
        isRetrograde: isRetro,
      );
    }

    return planets;
  }
}
