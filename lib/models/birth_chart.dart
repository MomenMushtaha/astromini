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
  final String? moonPhase;

  const BirthChart({
    required this.birthData,
    required this.planets,
    required this.houseCusps,
    required this.ascendant,
    required this.midheaven,
    required this.aspects,
    this.moonPhase,
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

  Map<String, int> get modalityBalance {
    final counts = {'Cardinal': 0, 'Fixed': 0, 'Mutable': 0};
    for (final pos in planets.values) {
      final modality = _signModality(pos.zodiacPosition.sign);
      counts[modality] = (counts[modality] ?? 0) + 1;
    }
    return counts;
  }

  List<String> get stelliums {
    final result = <String>[];

    // Check by sign
    final signGroups = <String, List<String>>{};
    for (final entry in planets.entries) {
      final sign = entry.value.zodiacPosition.sign;
      signGroups.putIfAbsent(sign, () => []).add(entry.key.displayName);
    }
    for (final entry in signGroups.entries) {
      if (entry.value.length >= 3) {
        result.add('Stellium in ${entry.key} (${entry.value.join(', ')})');
      }
    }

    // Check by house
    final houseGroups = <int, List<String>>{};
    for (final entry in planets.entries) {
      final house = entry.value.house;
      houseGroups.putIfAbsent(house, () => []).add(entry.key.displayName);
    }
    for (final entry in houseGroups.entries) {
      if (entry.value.length >= 3) {
        result.add('Stellium in House ${entry.key} (${entry.value.join(', ')})');
      }
    }

    return result;
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

  static String _signModality(String sign) {
    const modalities = {
      'Aries': 'Cardinal', 'Cancer': 'Cardinal', 'Libra': 'Cardinal', 'Capricorn': 'Cardinal',
      'Taurus': 'Fixed', 'Leo': 'Fixed', 'Scorpio': 'Fixed', 'Aquarius': 'Fixed',
      'Gemini': 'Mutable', 'Virgo': 'Mutable', 'Sagittarius': 'Mutable', 'Pisces': 'Mutable',
    };
    return modalities[sign] ?? 'Cardinal';
  }

  static const _signNames = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];
}
