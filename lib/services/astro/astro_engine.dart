import '../../models/birth_chart.dart';
import '../../models/birth_data.dart';
import '../../models/planet_position.dart';
import '../../models/chart_analysis_result.dart';
import 'aspects.dart';
import 'aspect_patterns.dart';
import 'chart_analysis.dart';
import 'chart_shape.dart';
import 'combustion.dart';
import 'declination.dart';
import 'dignities.dart';
import 'fixed_stars.dart';
import 'house_system.dart';
import 'julian_date.dart';
import 'moon_phase.dart';
import 'planetary_positions.dart';
import 'void_of_course.dart';
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
    final houseCusps = HouseSystem.calculatePlacidusHouses(
      asc, mc, lstDeg, birthData.latitude, obl,
    );

    // Calculate planetary positions and daily motions
    final rawPositions = PlanetaryPositions.allPositions(t);
    final speeds = PlanetaryPositions.allSpeeds(t);

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
      'northNode': CelestialBody.northNode,
      'southNode': CelestialBody.southNode,
      'chiron': CelestialBody.chiron,
      'lilith': CelestialBody.lilith,
    };

    // Determine rising sign and sect
    final risingSign = _signNameFromDeg(asc);
    final sunLon = rawPositions['sun']!;
    final sect = ChartAnalysis.determineSect(sunLon, asc);

    // Find mutual receptions (need a first pass of positions)
    final tempPlanets = <CelestialBody, PlanetPosition>{};
    for (final entry in rawPositions.entries) {
      final body = bodyMap[entry.key]!;
      tempPlanets[body] = PlanetPosition(
        body: body,
        eclipticLongitude: entry.value,
        zodiacPosition: ZodiacUtil.getPosition(entry.value),
        house: HouseSystem.getHouse(entry.value, houseCusps),
      );
    }
    final mutualReceptions = ChartAnalysis.findMutualReceptions(tempPlanets);
    final mrBodies = <CelestialBody>{};
    for (final mr in mutualReceptions) {
      mrBodies.add(mr.planet1);
      mrBodies.add(mr.planet2);
    }

    // Build full planet positions with all metadata
    final planets = <CelestialBody, PlanetPosition>{};
    final dailyMotions = <CelestialBody, double>{};

    for (final entry in rawPositions.entries) {
      final body = bodyMap[entry.key]!;
      final lon = entry.value;
      final speed = speeds[entry.key] ?? 0.0;
      dailyMotions[body] = speed;

      // Retrograde detection
      final isRetro = (body == CelestialBody.northNode || body == CelestialBody.southNode)
          ? true
          : speed < 0 && body != CelestialBody.sun && body != CelestialBody.moon;

      final zodPos = ZodiacUtil.getPosition(lon);
      final house = HouseSystem.getHouse(lon, houseCusps);

      // Declination
      final dec = DeclinationCalculator.declination(lon, obl);

      // Combustion status
      final combStatus = CombustionCalculator.combustionStatus(
        body, lon, sunLon, isRetrograde: isRetro,
      );

      // Speed status
      final spdStatus = ChartAnalysis.speedStatus(body, speed);

      // Decan
      final decan = Dignities.decanLabel(zodPos.sign, zodPos.degree);

      // Comprehensive dignity score
      final digScore = Dignities.dignityScore(
        body: body,
        sign: zodPos.sign,
        degree: zodPos.degree,
        sect: sect,
        combustionStatus: combStatus,
        isMutualReception: mrBodies.contains(body),
      );

      planets[body] = PlanetPosition(
        body: body,
        eclipticLongitude: lon,
        zodiacPosition: zodPos,
        house: house,
        isRetrograde: isRetro,
        dailyMotion: speed,
        declination: dec,
        decan: decan.isNotEmpty ? decan : null,
        dignityScore: digScore,
        combustionStatus: combStatus,
        speedStatus: spdStatus,
      );
    }

    // Calculate aspects with applying/separating
    final aspects = AspectCalculator.calculateAspects(
      planets,
      dailyMotions: dailyMotions,
    );

    // Detect aspect patterns
    final aspectPatterns = AspectPatternDetector.detectPatterns(aspects, planets);

    // Moon phase
    final moonPhase = MoonPhaseCalculator.calculatePhase(
      rawPositions['sun']!,
      rawPositions['moon']!,
    );

    // Chart ruler
    final chartRuler = ChartAnalysis.chartRuler(risingSign);

    // Part of Fortune
    final pofLon = ChartAnalysis.partOfFortune(
      asc, sunLon, rawPositions['moon']!, sect,
    );
    final pofPos = PlanetPosition(
      body: CelestialBody.sun, // placeholder body
      eclipticLongitude: pofLon,
      zodiacPosition: ZodiacUtil.getPosition(pofLon),
      house: HouseSystem.getHouse(pofLon, houseCusps),
    );

    // Vertex
    final vertexLon = HouseSystem.vertex(lstDeg, birthData.latitude, obl);
    final vertexPos = PlanetPosition(
      body: CelestialBody.sun, // placeholder body
      eclipticLongitude: vertexLon,
      zodiacPosition: ZodiacUtil.getPosition(vertexLon),
      house: HouseSystem.getHouse(vertexLon, houseCusps),
    );

    // Hemisphere balance
    final hemisphereBalance = ChartAnalysis.hemisphereBalance(planets);

    // Chart shape
    final chartShape = ChartShapeDetector.detectShape(planets);

    // Fixed star conjunctions
    final fixedStarConjunctions = FixedStars.findConjunctions(planets, t);

    // Void of Course Moon (for the birth moment)
    final moonOnlyPositions = Map<String, double>.from(rawPositions)
      ..remove('moon');
    final isVocMoon = VoidOfCourseMoon.isVoidOfCourse(
      rawPositions['moon']!,
      speeds['moon'] ?? 13.0,
      moonOnlyPositions,
    );

    // Assemble chart analysis
    final analysis = ChartAnalysisResult(
      chartRuler: chartRuler,
      sect: sect,
      partOfFortune: pofPos,
      vertex: vertexPos,
      mutualReceptions: mutualReceptions,
      aspectPatterns: aspectPatterns,
      hemisphereBalance: hemisphereBalance,
      chartShape: chartShape,
      fixedStarConjunctions: fixedStarConjunctions,
      isVoidOfCourseMoon: isVocMoon,
    );

    return BirthChart(
      birthData: birthData,
      planets: planets,
      houseCusps: houseCusps,
      ascendant: asc,
      midheaven: mc,
      aspects: aspects,
      moonPhase: moonPhase,
      analysis: analysis,
    );
  }

  /// Calculate current planetary positions (for sky map)
  static Map<CelestialBody, PlanetPosition> currentPositions() {
    final now = DateTime.now().toUtc();
    final jd = JulianDate.fromDateTime(now);
    final t = JulianDate.toJulianCentury(jd);

    final rawPositions = PlanetaryPositions.allPositions(t);
    final speeds = PlanetaryPositions.allSpeeds(t);

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
      'northNode': CelestialBody.northNode,
      'southNode': CelestialBody.southNode,
      'chiron': CelestialBody.chiron,
      'lilith': CelestialBody.lilith,
    };

    final planets = <CelestialBody, PlanetPosition>{};
    for (final entry in rawPositions.entries) {
      final body = bodyMap[entry.key]!;
      final lon = entry.value;
      final speed = speeds[entry.key] ?? 0.0;
      final isRetro = (body == CelestialBody.northNode || body == CelestialBody.southNode)
          ? true
          : speed < 0 && body != CelestialBody.sun && body != CelestialBody.moon;

      planets[body] = PlanetPosition(
        body: body,
        eclipticLongitude: lon,
        zodiacPosition: ZodiacUtil.getPosition(lon),
        house: 1, // No houses for sky map
        isRetrograde: isRetro,
        dailyMotion: speed,
      );
    }

    return planets;
  }

  static String _signNameFromDeg(double deg) {
    const signs = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
    ];
    final idx = ((deg % 360) / 30).floor();
    return signs[idx];
  }
}
