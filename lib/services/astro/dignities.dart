import '../../models/planet_position.dart';
import '../../models/chart_analysis_result.dart';

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

  // --- Decanates (Chaldean order) ---
  // Each sign has 3 decans of 10° each, ruled by planets in Chaldean order.
  static const _decans = <String, List<CelestialBody>>{
    'Aries':       [CelestialBody.mars, CelestialBody.sun, CelestialBody.jupiter],
    'Taurus':      [CelestialBody.venus, CelestialBody.mercury, CelestialBody.saturn],
    'Gemini':      [CelestialBody.mercury, CelestialBody.venus, CelestialBody.saturn],
    'Cancer':      [CelestialBody.moon, CelestialBody.pluto, CelestialBody.neptune],
    'Leo':         [CelestialBody.sun, CelestialBody.jupiter, CelestialBody.mars],
    'Virgo':       [CelestialBody.mercury, CelestialBody.saturn, CelestialBody.venus],
    'Libra':       [CelestialBody.venus, CelestialBody.saturn, CelestialBody.mercury],
    'Scorpio':     [CelestialBody.pluto, CelestialBody.neptune, CelestialBody.moon],
    'Sagittarius': [CelestialBody.jupiter, CelestialBody.mars, CelestialBody.sun],
    'Capricorn':   [CelestialBody.saturn, CelestialBody.venus, CelestialBody.mercury],
    'Aquarius':    [CelestialBody.saturn, CelestialBody.mercury, CelestialBody.venus],
    'Pisces':      [CelestialBody.neptune, CelestialBody.moon, CelestialBody.pluto],
  };

  /// Returns the decan ruler and label for a planet at a given degree in a sign.
  static String decanLabel(String sign, int degree) {
    final idx = degree < 10 ? 0 : (degree < 20 ? 1 : 2);
    final rulers = _decans[sign];
    if (rulers == null) return '';
    final ordinal = ['1st', '2nd', '3rd'][idx];
    return '$ordinal Decan (${rulers[idx].displayName})';
  }

  /// Returns the decan ruler planet.
  static CelestialBody? decanRuler(String sign, int degree) {
    final idx = degree < 10 ? 0 : (degree < 20 ? 1 : 2);
    return _decans[sign]?[idx];
  }

  // --- Triplicity Rulers ---
  // Day and night rulers for each element (traditional Dorothean scheme).
  static CelestialBody? triplicityRuler(String sign, Sect sect) {
    const signElements = {
      'Aries': 'Fire', 'Leo': 'Fire', 'Sagittarius': 'Fire',
      'Taurus': 'Earth', 'Virgo': 'Earth', 'Capricorn': 'Earth',
      'Gemini': 'Air', 'Libra': 'Air', 'Aquarius': 'Air',
      'Cancer': 'Water', 'Scorpio': 'Water', 'Pisces': 'Water',
    };
    final element = signElements[sign];
    if (element == null) return null;

    const rulers = <String, Map<Sect, CelestialBody>>{
      'Fire':  {Sect.day: CelestialBody.sun, Sect.night: CelestialBody.jupiter},
      'Earth': {Sect.day: CelestialBody.venus, Sect.night: CelestialBody.moon},
      'Air':   {Sect.day: CelestialBody.saturn, Sect.night: CelestialBody.mercury},
      'Water': {Sect.day: CelestialBody.mars, Sect.night: CelestialBody.moon},
    };
    return rulers[element]?[sect];
  }

  // --- Egyptian Terms (Bounds) ---
  // 5 unequal divisions per sign, each ruled by a traditional planet.
  static const _terms = <String, List<(int, CelestialBody)>>{
    'Aries':       [(6, CelestialBody.jupiter), (12, CelestialBody.venus), (20, CelestialBody.mercury), (25, CelestialBody.mars), (30, CelestialBody.saturn)],
    'Taurus':      [(8, CelestialBody.venus), (14, CelestialBody.mercury), (22, CelestialBody.jupiter), (27, CelestialBody.saturn), (30, CelestialBody.mars)],
    'Gemini':      [(6, CelestialBody.mercury), (12, CelestialBody.jupiter), (17, CelestialBody.venus), (24, CelestialBody.mars), (30, CelestialBody.saturn)],
    'Cancer':      [(7, CelestialBody.mars), (13, CelestialBody.venus), (19, CelestialBody.mercury), (26, CelestialBody.jupiter), (30, CelestialBody.saturn)],
    'Leo':         [(6, CelestialBody.jupiter), (11, CelestialBody.venus), (18, CelestialBody.saturn), (24, CelestialBody.mercury), (30, CelestialBody.mars)],
    'Virgo':       [(7, CelestialBody.mercury), (17, CelestialBody.venus), (21, CelestialBody.jupiter), (28, CelestialBody.mars), (30, CelestialBody.saturn)],
    'Libra':       [(6, CelestialBody.saturn), (14, CelestialBody.mercury), (21, CelestialBody.jupiter), (28, CelestialBody.venus), (30, CelestialBody.mars)],
    'Scorpio':     [(7, CelestialBody.mars), (11, CelestialBody.venus), (19, CelestialBody.mercury), (24, CelestialBody.jupiter), (30, CelestialBody.saturn)],
    'Sagittarius': [(12, CelestialBody.jupiter), (17, CelestialBody.venus), (21, CelestialBody.mercury), (26, CelestialBody.saturn), (30, CelestialBody.mars)],
    'Capricorn':   [(7, CelestialBody.mercury), (14, CelestialBody.jupiter), (22, CelestialBody.venus), (26, CelestialBody.saturn), (30, CelestialBody.mars)],
    'Aquarius':    [(7, CelestialBody.mercury), (13, CelestialBody.venus), (20, CelestialBody.jupiter), (25, CelestialBody.mars), (30, CelestialBody.saturn)],
    'Pisces':      [(12, CelestialBody.venus), (16, CelestialBody.jupiter), (19, CelestialBody.mercury), (28, CelestialBody.mars), (30, CelestialBody.saturn)],
  };

  /// Returns the term (bound) ruler for a degree within a sign.
  static CelestialBody? termRuler(String sign, int degree) {
    final bounds = _terms[sign];
    if (bounds == null) return null;
    for (final (endDeg, ruler) in bounds) {
      if (degree < endDeg) return ruler;
    }
    return bounds.last.$2;
  }

  // --- Comprehensive Dignity Score ---
  // Weighted point system combining all dignity factors.
  static int dignityScore({
    required CelestialBody body,
    required String sign,
    required int degree,
    Sect? sect,
    String? combustionStatus,
    bool isMutualReception = false,
  }) {
    int score = 0;

    // Essential dignities
    final dignity = getDignity(body, sign);
    if (dignity == 'Domicile') {
      score += 5;
    } else if (dignity == 'Exalted') {
      score += 4;
    } else if (dignity == 'Detriment') {
      score -= 5;
    } else if (dignity == 'Fall') {
      score -= 4;
    }

    // Triplicity
    if (sect != null && triplicityRuler(sign, sect) == body) {
      score += 3;
    }

    // Term
    if (termRuler(sign, degree) == body) {
      score += 2;
    }

    // Decan
    if (decanRuler(sign, degree) == body) {
      score += 1;
    }

    // Mutual reception
    if (isMutualReception) {
      score += 4;
    }

    // Combustion
    if (combustionStatus == 'Cazimi') {
      score += 5;
    } else if (combustionStatus == 'Combust') {
      score -= 5;
    } else if (combustionStatus == 'Under the Beams') {
      score -= 2;
    }

    // Peregrine: no essential dignity at all
    if (dignity == null &&
        (sect == null || triplicityRuler(sign, sect) != body) &&
        termRuler(sign, degree) != body &&
        decanRuler(sign, degree) != body) {
      score -= 5;
    }

    return score;
  }

  /// Human-readable label for a dignity score.
  static String dignityScoreLabel(int score) {
    if (score >= 8) return 'Very Strong';
    if (score >= 4) return 'Strong';
    if (score >= 0) return 'Moderate';
    if (score >= -4) return 'Weak';
    return 'Very Weak';
  }
}
