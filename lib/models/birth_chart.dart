import 'birth_data.dart';
import 'planet_position.dart';
import 'aspect.dart';

class BirthChart {
  final BirthData birthData;
  final Map<CelestialBody, PlanetPosition> planets;
  final List<double> houseCusps;
  final double ascendant;
  final double midheaven;
  final List<Aspect> aspects;

  const BirthChart({
    required this.birthData,
    required this.planets,
    required this.houseCusps,
    required this.ascendant,
    required this.midheaven,
    required this.aspects,
  });

  ZodiacPosition get sunSign => planets[CelestialBody.sun]!.zodiacPosition;
  ZodiacPosition get moonSign => planets[CelestialBody.moon]!.zodiacPosition;
  ZodiacPosition get risingSign =>
      planets[CelestialBody.sun]!.zodiacPosition; // Simplified: use ASC

  String get risingSignName {
    final ascDeg = ascendant % 360;
    final signIndex = (ascDeg / 30).floor();
    return _signNames[signIndex];
  }

  Map<String, int> get elementBalance {
    final counts = {'Fire': 0, 'Earth': 0, 'Air': 0, 'Water': 0};
    for (final pos in planets.values) {
      final element = _signElement(pos.zodiacPosition.sign);
      counts[element] = (counts[element] ?? 0) + 1;
    }
    return counts;
  }

  static String _signElement(String sign) {
    const elements = {
      'Aries': 'Fire', 'Leo': 'Fire', 'Sagittarius': 'Fire',
      'Taurus': 'Earth', 'Virgo': 'Earth', 'Capricorn': 'Earth',
      'Gemini': 'Air', 'Libra': 'Air', 'Aquarius': 'Air',
      'Cancer': 'Water', 'Scorpio': 'Water', 'Pisces': 'Water',
    };
    return elements[sign] ?? 'Fire';
  }

  static const _signNames = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];
}
