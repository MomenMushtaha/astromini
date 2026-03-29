import '../../models/aspect_pattern.dart';
import '../../models/planet_position.dart';

/// Interpretations for major aspect patterns.
class PatternInterpretations {
  PatternInterpretations._();

  static String getDescription(
    AspectPatternType type, {
    String? element,
    CelestialBody? apex,
  }) {
    switch (type) {
      case AspectPatternType.grandTrine:
        return _grandTrineByElement(element);
      case AspectPatternType.tSquare:
        return _tSquareByApex(apex);
      case AspectPatternType.grandCross:
        return 'A Grand Cross creates persistent tension from four planets in mutual conflict. '
            'This is the chart of someone forged by pressure — driven, resilient, and '
            'perpetually balancing competing demands. The key is channeling this '
            'cardinal energy into decisive action rather than paralysis.';
      case AspectPatternType.yod:
        return 'A Yod (Finger of God) with ${apex?.displayName ?? 'the apex planet'} at the tip — '
            'a pattern of fated adjustments and crisis-driven growth. '
            'The apex planet carries a special mission that may not become clear until midlife. '
            'There is a sense of destiny and the feeling of being pushed toward a specific purpose.';
      case AspectPatternType.kite:
        return 'A Kite pattern adds a focused outlet to the Grand Trine\'s natural flow. '
            'The opposing planet acts as a rudder, directing talent toward achievement. '
            'This combines easy gifts with productive ambition — '
            'one of the most constructive patterns in astrology.';
      case AspectPatternType.mysticRectangle:
        return 'A Mystic Rectangle balances tension (oppositions) with harmony (trines and sextiles). '
            'This creates a dynamic stability — the ability to navigate conflict with grace '
            'and find practical resolution. Often indicates diplomatic talent and inner equilibrium.';
    }
  }

  static String _grandTrineByElement(String? element) {
    switch (element) {
      case 'Fire':
        return 'A Grand Trine in Fire — natural confidence, creative self-expression, '
            'and infectious enthusiasm flow effortlessly. The risk is complacency; '
            'this gift must be actively channeled into creative pursuits to avoid arrogance.';
      case 'Earth':
        return 'A Grand Trine in Earth — practical mastery, material stability, '
            'and an innate sense of how to build lasting structures. Physical talents '
            'and financial instincts come naturally, but watch for resistance to change.';
      case 'Air':
        return 'A Grand Trine in Air — intellectual brilliance, social fluency, '
            'and the ability to synthesize diverse ideas effortlessly. Communication gifts '
            'are strong, but must be grounded in action to produce tangible results.';
      case 'Water':
        return 'A Grand Trine in Water — deep emotional intelligence, psychic sensitivity, '
            'and an intuitive understanding of the human condition. Creativity and empathy '
            'flow naturally, but boundaries must be maintained to avoid emotional overwhelm.';
      default:
        return 'A Grand Trine — three planets in harmonious flow, creating natural talent '
            'and ease in the areas of life they touch. The gift must be consciously '
            'developed to avoid complacency.';
    }
  }

  static String _tSquareByApex(CelestialBody? apex) {
    if (apex == null) {
      return 'A T-Square — dynamic tension that drives achievement through challenge. '
          'The apex planet is the focal point of resolution.';
    }

    final name = apex.displayName;
    const personalPlanets = {
      CelestialBody.sun, CelestialBody.moon, CelestialBody.mercury,
      CelestialBody.venus, CelestialBody.mars,
    };
    const socialPlanets = {CelestialBody.jupiter, CelestialBody.saturn};

    if (personalPlanets.contains(apex)) {
      return 'A T-Square with $name at the apex — personal identity and self-expression '
          'are the pressure point. This drives relentless self-improvement and the '
          'development of strong character through repeated challenges.';
    } else if (socialPlanets.contains(apex)) {
      return 'A T-Square with $name at the apex — social role and worldly ambition '
          'are the pressure point. This creates powerful drive for achievement, status, '
          'or philosophical understanding through confronting obstacles.';
    } else {
      return 'A T-Square with $name at the apex — transformation and evolution '
          'at the deepest level are demanded. This placement generates intense inner '
          'pressure that catalyzes profound psychological and spiritual growth.';
    }
  }
}
