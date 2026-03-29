import '../../models/planet_position.dart';
import '../../models/chart_analysis_result.dart';

/// Major fixed stars with ecliptic longitudes (J2000.0 epoch)
/// and annual precession correction.
class FixedStars {
  FixedStars._();

  // Star data: (name, J2000 ecliptic longitude in degrees, magnitude, interpretation)
  static const _stars = <(String, double, double, String)>[
    (
      'Regulus',
      149.83, // 29°50' Leo
      1.4,
      'The Heart of the Lion — kingship, ambition, success, and noble leadership. '
      'Can bring fame and honor but also arrogance if unchecked.'
    ),
    (
      'Sirius',
      104.08, // 14°05' Cancer
      -1.5,
      'The Dog Star — brilliance, fame, devotion, and custodianship. '
      'The brightest star in the sky bestows dazzling talent and notoriety.'
    ),
    (
      'Aldebaran',
      69.78, // 9°47' Gemini
      0.9,
      'The Eye of the Bull — integrity, honor, and eloquence. '
      'A Royal Star demanding moral courage; success comes through honesty.'
    ),
    (
      'Antares',
      249.77, // 9°46' Sagittarius
      1.1,
      'The Heart of the Scorpion — intensity, obsession, and strategic power. '
      'A Royal Star of extremes; can destroy or transform through passion.'
    ),
    (
      'Spica',
      203.83, // 23°50' Libra
      1.0,
      'The Sheaf of Wheat — brilliance, gifts, artistic talent, and harvest. '
      'One of the most benefic stars, bestowing skill and good fortune.'
    ),
    (
      'Fomalhaut',
      333.87, // 3°52' Pisces
      1.2,
      'The Mouth of the Fish — idealism, mysticism, and magic. '
      'A Royal Star of dreams; grants success through lofty vision and spirituality.'
    ),
    (
      'Algol',
      56.17, // 26°10' Taurus
      2.1,
      'The Demon Star — raw intensity, transformation through crisis. '
      'Feared in tradition but represents the power to face darkness and emerge renewed.'
    ),
    (
      'Rigel',
      76.90, // 16°50' Gemini
      0.1,
      'The Foot of Orion — ambition, teaching, and benevolent leadership. '
      'Bestows a restless desire to bring knowledge and civilization to others.'
    ),
    (
      'Betelgeuse',
      88.75, // 28°45' Gemini
      0.5,
      'The Shoulder of Orion — martial honor, prestige through action. '
      'Success through bold ventures, but with risk of sudden reversals.'
    ),
    (
      'Pollux',
      113.22, // 23°13' Cancer
      1.1,
      'The Immortal Twin — subtle power, cruelty or audacity. '
      'Athletic ability and daring, with a darker Martian edge than its twin Castor.'
    ),
    (
      'Procyon',
      115.62, // 25°47' Cancer
      0.4,
      'Before the Dog — quick success and activity followed by reversals. '
      'Imparts restless energy, independence, and a tendency to act before thinking.'
    ),
    (
      'Vega',
      275.17, // 15°19' Capricorn
      0.0,
      'The Falling Eagle — charisma, artistic brilliance, and idealism. '
      'One of the brightest stars, associated with magical ability and musical gifts.'
    ),
    (
      'Altair',
      301.82, // 1°47' Aquarius
      0.8,
      'The Flying Eagle — boldness, confidence, and sudden rise. '
      'Imparts courage and ambition but warns against overreaching pride.'
    ),
    (
      'Deneb',
      305.25, // 5°20' Pisces
      1.3,
      'The Tail of the Swan — intellectual power, artistic refinement. '
      'Bestows a powerful mind and the ability to command attention through ideas.'
    ),
    (
      'Arcturus',
      204.14, // 24°14' Libra
      -0.1,
      'The Bear Watcher — pathfinder, learning through experience. '
      'Brings success through unconventional paths and a pioneering spirit.'
    ),
  ];

  /// Precession rate: ~50.3 arc-seconds per year = 0.01397°/year
  static const _precessionPerYear = 50.3 / 3600.0;

  /// Find fixed star conjunctions with natal planets.
  /// Uses a 1.5° orb (conjunction only — the traditional approach).
  static List<FixedStarConjunction> findConjunctions(
    Map<CelestialBody, PlanetPosition> planets,
    double t, // Julian centuries from J2000.0
  ) {
    final conjunctions = <FixedStarConjunction>[];
    final years = t * 100.0;

    for (final (name, j2000Lon, _, interpretation) in _stars) {
      // Precess star position to the chart's epoch
      final starLon = (j2000Lon + years * _precessionPerYear) % 360.0;

      for (final entry in planets.entries) {
        // Skip nodes, Lilith
        if (entry.key == CelestialBody.northNode ||
            entry.key == CelestialBody.southNode ||
            entry.key == CelestialBody.lilith) {
          continue;
        }

        var sep = (entry.value.eclipticLongitude - starLon).abs();
        if (sep > 180) sep = 360 - sep;

        if (sep <= 1.5) {
          conjunctions.add(FixedStarConjunction(
            starName: name,
            planet: entry.key,
            orb: sep,
            interpretation: interpretation,
          ));
        }
      }
    }

    // Sort by tightest orb first
    conjunctions.sort((a, b) => a.orb.compareTo(b.orb));
    return conjunctions;
  }
}
