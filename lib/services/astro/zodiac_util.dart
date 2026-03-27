import '../../models/planet_position.dart';

class ZodiacUtil {
  ZodiacUtil._();

  static const signNames = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  static const signSymbols = [
    '\u2648', '\u2649', '\u264A', '\u264B', '\u264C', '\u264D',
    '\u264E', '\u264F', '\u2650', '\u2651', '\u2652', '\u2653',
  ];

  static const signElements = {
    'Aries': 'Fire', 'Leo': 'Fire', 'Sagittarius': 'Fire',
    'Taurus': 'Earth', 'Virgo': 'Earth', 'Capricorn': 'Earth',
    'Gemini': 'Air', 'Libra': 'Air', 'Aquarius': 'Air',
    'Cancer': 'Water', 'Scorpio': 'Water', 'Pisces': 'Water',
  };

  static ZodiacPosition getPosition(double eclipticLongitude) {
    var lon = eclipticLongitude % 360.0;
    if (lon < 0) lon += 360.0;

    final signIndex = (lon / 30.0).floor();
    final degreeInSign = lon - signIndex * 30.0;
    final degree = degreeInSign.floor();
    final minute = ((degreeInSign - degree) * 60).round();

    return ZodiacPosition(
      sign: signNames[signIndex],
      degree: degree,
      minute: minute,
    );
  }

  static int signIndex(String signName) {
    return signNames.indexOf(signName);
  }

  static String symbolFor(String signName) {
    final idx = signNames.indexOf(signName);
    return idx >= 0 ? signSymbols[idx] : '?';
  }

  static String elementFor(String signName) {
    return signElements[signName] ?? 'Fire';
  }

  static const signModalities = {
    'Aries': 'Cardinal', 'Cancer': 'Cardinal', 'Libra': 'Cardinal', 'Capricorn': 'Cardinal',
    'Taurus': 'Fixed', 'Leo': 'Fixed', 'Scorpio': 'Fixed', 'Aquarius': 'Fixed',
    'Gemini': 'Mutable', 'Virgo': 'Mutable', 'Sagittarius': 'Mutable', 'Pisces': 'Mutable',
  };

  static String modalityFor(String signName) {
    return signModalities[signName] ?? 'Cardinal';
  }
}
