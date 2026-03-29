import '../../models/aspect.dart';
import '../../models/aspect_pattern.dart';
import '../../models/planet_position.dart';
import 'pattern_interpretations.dart';

/// Detects major aspect patterns in a birth chart.
class AspectPatternDetector {
  AspectPatternDetector._();

  static List<AspectPattern> detectPatterns(
    List<Aspect> aspects,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final patterns = <AspectPattern>[];

    patterns.addAll(_findGrandTrines(aspects, planets));
    patterns.addAll(_findTSquares(aspects, planets));
    patterns.addAll(_findGrandCrosses(aspects));
    patterns.addAll(_findYods(aspects, planets));
    patterns.addAll(_findKites(aspects, planets));
    patterns.addAll(_findMysticRectangles(aspects));

    return patterns;
  }

  /// Grand Trine: 3 planets each in mutual trine.
  static List<AspectPattern> _findGrandTrines(
    List<Aspect> aspects,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final trines = aspects.where((a) => a.type == AspectType.trine).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    for (int i = 0; i < trines.length; i++) {
      for (int j = i + 1; j < trines.length; j++) {
        // Find shared planet between two trines
        final shared = _sharedPlanet(trines[i], trines[j]);
        if (shared == null) continue;

        // Get the other two planets
        final p2 = _otherPlanet(trines[i], shared);
        final p3 = _otherPlanet(trines[j], shared);

        // Check if p2 and p3 are also in trine
        if (_hasAspect(trines, p2, p3)) {
          final trio = [shared, p2, p3]..sort((a, b) => a.index.compareTo(b.index));
          final key = trio.map((p) => p.name).join('-');
          if (seen.add(key)) {
            // Determine element
            final element = _commonElement(trio, planets);
            patterns.add(AspectPattern(
              type: AspectPatternType.grandTrine,
              planets: trio,
              element: element,
              description: PatternInterpretations.getDescription(
                AspectPatternType.grandTrine, element: element,
              ),
            ));
          }
        }
      }
    }
    return patterns;
  }

  /// T-Square: 2 planets in opposition + 3rd square to both.
  static List<AspectPattern> _findTSquares(
    List<Aspect> aspects,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final oppositions = aspects.where((a) => a.type == AspectType.opposition).toList();
    final squares = aspects.where((a) => a.type == AspectType.square).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    for (final opp in oppositions) {
      for (final body in planets.keys) {
        if (body == opp.planet1 || body == opp.planet2) continue;
        if (_hasAspect(squares, body, opp.planet1) &&
            _hasAspect(squares, body, opp.planet2)) {
          final trio = [opp.planet1, opp.planet2, body]
            ..sort((a, b) => a.index.compareTo(b.index));
          final key = trio.map((p) => p.name).join('-');
          if (seen.add(key)) {
            patterns.add(AspectPattern(
              type: AspectPatternType.tSquare,
              planets: trio,
              apex: body,
              description: PatternInterpretations.getDescription(
                AspectPatternType.tSquare, apex: body,
              ),
            ));
          }
        }
      }
    }
    return patterns;
  }

  /// Grand Cross: 4 planets forming 2 oppositions and 4 squares.
  static List<AspectPattern> _findGrandCrosses(List<Aspect> aspects) {
    final oppositions = aspects.where((a) => a.type == AspectType.opposition).toList();
    final squares = aspects.where((a) => a.type == AspectType.square).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    for (int i = 0; i < oppositions.length; i++) {
      for (int j = i + 1; j < oppositions.length; j++) {
        final opp1 = oppositions[i];
        final opp2 = oppositions[j];
        final allPlanets = {opp1.planet1, opp1.planet2, opp2.planet1, opp2.planet2};
        if (allPlanets.length != 4) continue;

        // Check all 4 square connections exist
        final planetList = allPlanets.toList();
        int squareCount = 0;
        for (int a = 0; a < planetList.length; a++) {
          for (int b = a + 1; b < planetList.length; b++) {
            if (_hasAspect(squares, planetList[a], planetList[b])) squareCount++;
          }
        }
        if (squareCount >= 4) {
          final sorted = planetList..sort((a, b) => a.index.compareTo(b.index));
          final key = sorted.map((p) => p.name).join('-');
          if (seen.add(key)) {
            patterns.add(AspectPattern(
              type: AspectPatternType.grandCross,
              planets: sorted,
              description: PatternInterpretations.getDescription(
                AspectPatternType.grandCross,
              ),
            ));
          }
        }
      }
    }
    return patterns;
  }

  /// Yod: 2 planets in sextile + 3rd quincunx to both. 3rd = apex.
  static List<AspectPattern> _findYods(
    List<Aspect> aspects,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final sextiles = aspects.where((a) => a.type == AspectType.sextile).toList();
    final quincunxes = aspects.where((a) => a.type == AspectType.quincunx).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    for (final sex in sextiles) {
      for (final body in planets.keys) {
        if (body == sex.planet1 || body == sex.planet2) continue;
        if (_hasAspect(quincunxes, body, sex.planet1) &&
            _hasAspect(quincunxes, body, sex.planet2)) {
          final trio = [sex.planet1, sex.planet2, body]
            ..sort((a, b) => a.index.compareTo(b.index));
          final key = trio.map((p) => p.name).join('-');
          if (seen.add(key)) {
            patterns.add(AspectPattern(
              type: AspectPatternType.yod,
              planets: trio,
              apex: body,
              description: PatternInterpretations.getDescription(
                AspectPatternType.yod, apex: body,
              ),
            ));
          }
        }
      }
    }
    return patterns;
  }

  /// Kite: Grand Trine + 1 planet opposing one trine planet and sextile the other two.
  static List<AspectPattern> _findKites(
    List<Aspect> aspects,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    final trines = aspects.where((a) => a.type == AspectType.trine).toList();
    final sextiles = aspects.where((a) => a.type == AspectType.sextile).toList();
    final oppositions = aspects.where((a) => a.type == AspectType.opposition).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    // First find Grand Trines
    final grandTrineGroups = <List<CelestialBody>>[];
    for (int i = 0; i < trines.length; i++) {
      for (int j = i + 1; j < trines.length; j++) {
        final shared = _sharedPlanet(trines[i], trines[j]);
        if (shared == null) continue;
        final p2 = _otherPlanet(trines[i], shared);
        final p3 = _otherPlanet(trines[j], shared);
        if (_hasAspect(trines, p2, p3)) {
          grandTrineGroups.add([shared, p2, p3]);
        }
      }
    }

    for (final trio in grandTrineGroups) {
      for (final body in planets.keys) {
        if (trio.contains(body)) continue;
        // Check if body opposes one and sextiles the other two
        for (final target in trio) {
          final others = trio.where((p) => p != target).toList();
          if (_hasAspect(oppositions, body, target) &&
              _hasAspect(sextiles, body, others[0]) &&
              _hasAspect(sextiles, body, others[1])) {
            final quad = [...trio, body]..sort((a, b) => a.index.compareTo(b.index));
            final key = quad.map((p) => p.name).join('-');
            if (seen.add(key)) {
              patterns.add(AspectPattern(
                type: AspectPatternType.kite,
                planets: quad,
                apex: body,
                description: PatternInterpretations.getDescription(
                  AspectPatternType.kite,
                ),
              ));
            }
          }
        }
      }
    }
    return patterns;
  }

  /// Mystic Rectangle: 2 oppositions + 2 trines + 2 sextiles.
  static List<AspectPattern> _findMysticRectangles(List<Aspect> aspects) {
    final oppositions = aspects.where((a) => a.type == AspectType.opposition).toList();
    final trines = aspects.where((a) => a.type == AspectType.trine).toList();
    final sextiles = aspects.where((a) => a.type == AspectType.sextile).toList();
    final patterns = <AspectPattern>[];
    final seen = <String>{};

    for (int i = 0; i < oppositions.length; i++) {
      for (int j = i + 1; j < oppositions.length; j++) {
        final opp1 = oppositions[i];
        final opp2 = oppositions[j];
        final allPlanets = {opp1.planet1, opp1.planet2, opp2.planet1, opp2.planet2};
        if (allPlanets.length != 4) continue;

        // Count trines and sextiles among the 4 planets
        final planetList = allPlanets.toList();
        int trineCount = 0;
        int sextileCount = 0;
        for (int a = 0; a < planetList.length; a++) {
          for (int b = a + 1; b < planetList.length; b++) {
            if (_hasAspect(trines, planetList[a], planetList[b])) trineCount++;
            if (_hasAspect(sextiles, planetList[a], planetList[b])) sextileCount++;
          }
        }
        if (trineCount >= 2 && sextileCount >= 2) {
          final sorted = planetList..sort((a, b) => a.index.compareTo(b.index));
          final key = sorted.map((p) => p.name).join('-');
          if (seen.add(key)) {
            patterns.add(AspectPattern(
              type: AspectPatternType.mysticRectangle,
              planets: sorted,
              description: PatternInterpretations.getDescription(
                AspectPatternType.mysticRectangle,
              ),
            ));
          }
        }
      }
    }
    return patterns;
  }

  // --- Helpers ---

  static CelestialBody? _sharedPlanet(Aspect a1, Aspect a2) {
    if (a1.planet1 == a2.planet1 || a1.planet1 == a2.planet2) return a1.planet1;
    if (a1.planet2 == a2.planet1 || a1.planet2 == a2.planet2) return a1.planet2;
    return null;
  }

  static CelestialBody _otherPlanet(Aspect a, CelestialBody shared) {
    return a.planet1 == shared ? a.planet2 : a.planet1;
  }

  static bool _hasAspect(List<Aspect> aspects, CelestialBody p1, CelestialBody p2) {
    return aspects.any((a) =>
        (a.planet1 == p1 && a.planet2 == p2) ||
        (a.planet1 == p2 && a.planet2 == p1));
  }

  static String? _commonElement(
    List<CelestialBody> bodies,
    Map<CelestialBody, PlanetPosition> planets,
  ) {
    const signElements = {
      'Aries': 'Fire', 'Leo': 'Fire', 'Sagittarius': 'Fire',
      'Taurus': 'Earth', 'Virgo': 'Earth', 'Capricorn': 'Earth',
      'Gemini': 'Air', 'Libra': 'Air', 'Aquarius': 'Air',
      'Cancer': 'Water', 'Scorpio': 'Water', 'Pisces': 'Water',
    };

    final elements = bodies
        .map((b) => signElements[planets[b]?.zodiacPosition.sign])
        .toSet();
    return elements.length == 1 ? elements.first : null;
  }
}
