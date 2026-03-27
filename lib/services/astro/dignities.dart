import '../../models/planet_position.dart';

class Dignities {
  Dignities._();

  /// Planets in their ruling sign(s) — strongest natural expression.
  static const domicile = <CelestialBody, List<String>>{
    CelestialBody.sun: ['Leo'],
    CelestialBody.moon: ['Cancer'],
    CelestialBody.mercury: ['Gemini', 'Virgo'],
    CelestialBody.venus: ['Taurus', 'Libra'],
    CelestialBody.mars: ['Aries', 'Scorpio'],
    CelestialBody.jupiter: ['Sagittarius', 'Pisces'],
    CelestialBody.saturn: ['Capricorn', 'Aquarius'],
    CelestialBody.uranus: ['Aquarius'],
    CelestialBody.neptune: ['Pisces'],
    CelestialBody.pluto: ['Scorpio'],
  };

  /// Planets in their exaltation sign — elevated, honored expression.
  static const exaltation = <CelestialBody, String>{
    CelestialBody.sun: 'Aries',
    CelestialBody.moon: 'Taurus',
    CelestialBody.mercury: 'Virgo',
    CelestialBody.venus: 'Pisces',
    CelestialBody.mars: 'Capricorn',
    CelestialBody.jupiter: 'Cancer',
    CelestialBody.saturn: 'Libra',
    CelestialBody.uranus: 'Scorpio',
    CelestialBody.neptune: 'Cancer',
    CelestialBody.pluto: 'Leo',
  };

  /// Planets in detriment — opposite of domicile, weakened expression.
  static const detriment = <CelestialBody, List<String>>{
    CelestialBody.sun: ['Aquarius'],
    CelestialBody.moon: ['Capricorn'],
    CelestialBody.mercury: ['Sagittarius', 'Pisces'],
    CelestialBody.venus: ['Aries', 'Scorpio'],
    CelestialBody.mars: ['Taurus', 'Libra'],
    CelestialBody.jupiter: ['Gemini', 'Virgo'],
    CelestialBody.saturn: ['Cancer', 'Leo'],
    CelestialBody.uranus: ['Leo'],
    CelestialBody.neptune: ['Virgo'],
    CelestialBody.pluto: ['Taurus'],
  };

  /// Planets in fall — opposite of exaltation, most challenged expression.
  static const fall = <CelestialBody, String>{
    CelestialBody.sun: 'Libra',
    CelestialBody.moon: 'Scorpio',
    CelestialBody.mercury: 'Pisces',
    CelestialBody.venus: 'Virgo',
    CelestialBody.mars: 'Cancer',
    CelestialBody.jupiter: 'Capricorn',
    CelestialBody.saturn: 'Aries',
    CelestialBody.uranus: 'Taurus',
    CelestialBody.neptune: 'Capricorn',
    CelestialBody.pluto: 'Aquarius',
  };

  /// Returns the dignity of a planet in a given sign, or null if none.
  static String? getDignity(CelestialBody body, String sign) {
    if (domicile[body]?.contains(sign) == true) return 'Domicile';
    if (exaltation[body] == sign) return 'Exalted';
    if (detriment[body]?.contains(sign) == true) return 'Detriment';
    if (fall[body] == sign) return 'Fall';
    return null;
  }

  /// Human-readable description of what a dignity means.
  static String dignityDescription(String dignity) {
    switch (dignity) {
      case 'Domicile':
        return 'at home — expresses its energy naturally and powerfully';
      case 'Exalted':
        return 'honored — elevated expression, operating at its highest potential';
      case 'Detriment':
        return 'challenged — must work harder to express its nature';
      case 'Fall':
        return 'uncomfortable — struggles to find its footing, requires conscious effort';
      default:
        return 'has a special relationship with this sign';
    }
  }
}
