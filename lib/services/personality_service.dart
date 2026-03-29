import '../models/birth_chart.dart';
import '../models/chart_analysis_result.dart';
import '../models/personality_profile.dart';
import '../models/planet_position.dart';
import 'astro/dignities.dart';
import 'astro/interpretation_data.dart';
import 'astro/moon_phase.dart';

class PersonalityService {
  PersonalityService._();

  static PersonalityProfile generate(BirthChart chart) {
    final sun = chart.planets[CelestialBody.sun]!;
    final moon = chart.planets[CelestialBody.moon]!;
    final risingSign = chart.risingSignName;

    final sunAnalysis = InterpretationData.sunSign[sun.zodiacPosition.sign] ??
        'Your Sun sign shapes your core identity and life purpose.';
    final moonAnalysis =
        InterpretationData.moonSign[moon.zodiacPosition.sign] ??
            'Your Moon sign governs your emotional landscape.';
    final risingAnalysis = InterpretationData.risingSigns[risingSign] ??
        'Your Rising sign determines how others perceive you.';

    final influences = <PlanetaryInfluence>[];
    for (final entry in chart.planets.entries) {
      final body = entry.key;
      final pos = entry.value;
      var interp = InterpretationData
              .planetSign['${body.name}_${pos.zodiacPosition.sign}'] ??
          '${body.displayName} in ${pos.zodiacPosition.sign} influences your ${_planetDomain(body)}.';

      // Add dignity information
      final dignity = Dignities.getDignity(body, pos.zodiacPosition.sign);
      if (dignity != null) {
        interp = '${body.displayName} in ${pos.zodiacPosition.sign} ($dignity) — '
            '${Dignities.dignityDescription(dignity)}. $interp';
      }

      influences.add(PlanetaryInfluence(
        planet: body,
        sign: pos.zodiacPosition.sign,
        house: pos.house,
        interpretation: interp,
      ));
    }

    final elementBal = chart.elementBalance;
    final total = elementBal.values.fold(0, (a, b) => a + b).toDouble();
    final elementBalance = elementBal
        .map((key, value) => MapEntry(key, total > 0 ? value / total : 0.25));

    final dominant = elementBal.entries.reduce(
        (a, b) => a.value > b.value ? a : b);

    final strengths = _generateStrengths(sun.zodiacPosition.sign,
        moon.zodiacPosition.sign, dominant.key);
    final challenges = _generateChallenges(sun.zodiacPosition.sign,
        moon.zodiacPosition.sign, dominant.key);

    // Modality balance
    final modalBal = chart.modalityBalance;
    final dominantModality = modalBal.entries.reduce(
        (a, b) => a.value > b.value ? a : b);

    // Stelliums
    final stelliums = chart.stelliums;

    // Moon phase at birth
    final moonPhaseAtBirth = chart.moonPhase;
    final moonPhaseNote = moonPhaseAtBirth != null
        ? '\n\nBorn under a ${MoonPhaseCalculator.phaseEmoji(moonPhaseAtBirth)} $moonPhaseAtBirth: '
          '${MoonPhaseCalculator.phaseDescription(moonPhaseAtBirth)}'
        : '';

    // Stellium note
    final stelliumNote = stelliums.isNotEmpty
        ? '\n\n${stelliums.join('. ')} — concentrating energy in these areas of life.'
        : '';

    // Chart analysis results
    final analysis = chart.analysis;
    String? chartRulerAnalysis;
    String? aspectPatternAnalysis;
    String? chartShapeAnalysis;
    List<String>? fixedStarNotes;
    String? sectAnalysis;

    if (analysis != null) {
      // Chart ruler
      final ruler = analysis.chartRuler;
      final rulerPos = chart.planets[ruler];
      if (rulerPos != null) {
        chartRulerAnalysis = 'Your chart ruler is ${ruler.displayName} '
            '(ruling your $risingSign Ascendant), placed in '
            '${rulerPos.zodiacPosition.sign} in house ${rulerPos.house}. '
            'This planet\'s condition colors your entire life expression and '
            'directs how you engage with the world.';
      }

      // Sect
      final sectName = analysis.sect == Sect.day ? 'Day' : 'Night';
      final benefic = analysis.sect == Sect.day ? 'Jupiter' : 'Venus';
      final malefic = analysis.sect == Sect.day ? 'Saturn' : 'Mars';
      sectAnalysis = 'You were born with a $sectName chart. '
          '$benefic is your most supportive planet (sect benefic), while '
          '$malefic operates more constructively in this sect. '
          '${analysis.sect == Sect.day ? 'Solar themes of visibility, purpose, and conscious action are emphasized.' : 'Lunar themes of intuition, inner life, and emotional processing are emphasized.'}';

      // Aspect patterns
      if (analysis.aspectPatterns.isNotEmpty) {
        final descriptions = analysis.aspectPatterns
            .map((p) => '${p.type.displayName}: ${p.description}')
            .toList();
        aspectPatternAnalysis = descriptions.join('\n\n');
      }

      // Chart shape
      final shape = analysis.chartShape;
      chartShapeAnalysis = '${shape.type.displayName} chart pattern: ${shape.description}';

      // Fixed star conjunctions
      if (analysis.fixedStarConjunctions.isNotEmpty) {
        fixedStarNotes = analysis.fixedStarConjunctions
            .map((s) => '${s.starName} conjunct ${s.planet.displayName} '
                '(orb ${s.orb.toStringAsFixed(1)}°): ${s.interpretation}')
            .toList();
      }

      // Mutual receptions — add to summary
      if (analysis.mutualReceptions.isNotEmpty) {
        final mrNotes = analysis.mutualReceptions
            .map((mr) => '${mr.planet1.displayName} in ${mr.sign1} and '
                '${mr.planet2.displayName} in ${mr.sign2} are in mutual reception, '
                'strengthening both planets')
            .join('. ');
        chartRulerAnalysis = '${chartRulerAnalysis ?? ''}\n\n$mrNotes.';
      }
    }

    final summary = 'With your Sun in ${sun.zodiacPosition.sign} '
        '(${sun.zodiacPosition.formatted}), Moon in ${moon.zodiacPosition.sign} '
        '(${moon.zodiacPosition.formatted}), and $risingSign Rising, you possess '
        'a unique blend of ${_elementQuality(dominant.key)} energy. '
        'Your dominant element is ${dominant.key} with ${dominant.value} out of '
        '${elementBal.values.fold(0, (a, b) => a + b)} planetary placements, '
        'giving you a natural affinity for ${_elementAffinity(dominant.key)}. '
        'Your dominant modality is ${dominantModality.key}, making you '
        '${_modalityQuality(dominantModality.key)}.\n\n'
        '$sunAnalysis\n\n$moonAnalysis'
        '$moonPhaseNote$stelliumNote';

    return PersonalityProfile(
      chart: chart,
      sunSignAnalysis: sunAnalysis,
      moonSignAnalysis: moonAnalysis,
      risingSignAnalysis: risingAnalysis,
      planetaryInfluences: influences,
      overallSummary: summary,
      strengths: strengths,
      challenges: challenges,
      loveStyle: _loveStyle(
          chart.planets[CelestialBody.venus]!.zodiacPosition.sign,
          chart.planets[CelestialBody.mars]!.zodiacPosition.sign),
      careerAptitude: _careerAptitude(
          sun.zodiacPosition.sign,
          chart.planets[CelestialBody.saturn]!.zodiacPosition.sign),
      elementBalance: elementBalance,
      modalityBalance: modalBal,
      stelliums: stelliums.isEmpty ? null : stelliums,
      moonPhaseAtBirth: moonPhaseAtBirth,
      chartRulerAnalysis: chartRulerAnalysis,
      aspectPatternAnalysis: aspectPatternAnalysis,
      chartShapeAnalysis: chartShapeAnalysis,
      fixedStarNotes: fixedStarNotes,
      sectAnalysis: sectAnalysis,
    );
  }

  static String _planetDomain(CelestialBody body) {
    switch (body) {
      case CelestialBody.sun: return 'core identity';
      case CelestialBody.moon: return 'emotional nature';
      case CelestialBody.mercury: return 'communication style';
      case CelestialBody.venus: return 'love and values';
      case CelestialBody.mars: return 'drive and ambition';
      case CelestialBody.jupiter: return 'growth and expansion';
      case CelestialBody.saturn: return 'discipline and structure';
      case CelestialBody.uranus: return 'innovation and change';
      case CelestialBody.neptune: return 'imagination and spirituality';
      case CelestialBody.pluto: return 'transformation and power';
      case CelestialBody.northNode: return 'karmic path and destiny';
      case CelestialBody.southNode: return 'karmic release and past patterns';
      case CelestialBody.chiron: return 'deepest wound and healing gift';
      case CelestialBody.lilith: return 'primal instincts and shadow self';
    }
  }

  static String _modalityQuality(String modality) {
    switch (modality) {
      case 'Cardinal': return 'a natural initiator and leader';
      case 'Fixed': return 'persistent, determined, and deeply committed';
      case 'Mutable': return 'adaptable, versatile, and open to change';
      default: return 'balanced in approach';
    }
  }

  static String _elementQuality(String element) {
    switch (element) {
      case 'Fire': return 'passionate and dynamic';
      case 'Earth': return 'grounded and practical';
      case 'Air': return 'intellectual and communicative';
      case 'Water': return 'intuitive and emotional';
      default: return 'balanced';
    }
  }

  static String _elementAffinity(String element) {
    switch (element) {
      case 'Fire': return 'leadership, creativity, and bold action';
      case 'Earth': return 'stability, material achievement, and sensory experience';
      case 'Air': return 'ideas, social connection, and abstract thinking';
      case 'Water': return 'emotional depth, empathy, and spiritual insight';
      default: return 'versatility';
    }
  }

  static List<String> _generateStrengths(
      String sun, String moon, String element) {
    final list = <String>[];
    list.addAll(_signStrengths[sun] ?? ['Resilient', 'Determined']);
    if (element == 'Fire') list.add('Natural leader');
    if (element == 'Earth') list.add('Reliable and steady');
    if (element == 'Air') list.add('Quick-witted communicator');
    if (element == 'Water') list.add('Deeply empathic');
    return list.take(5).toList();
  }

  static List<String> _generateChallenges(
      String sun, String moon, String element) {
    final list = <String>[];
    list.addAll(_signChallenges[sun] ?? ['Overthinking', 'Stubbornness']);
    if (element == 'Fire') list.add('Impatience');
    if (element == 'Earth') list.add('Resistance to change');
    if (element == 'Air') list.add('Emotional detachment');
    if (element == 'Water') list.add('Emotional overwhelm');
    return list.take(4).toList();
  }

  static String _loveStyle(String venus, String mars) {
    return 'With Venus in $venus, you express love through '
        '${_venusStyle[venus] ?? "deep connection and loyalty"}. '
        'Mars in $mars drives your passion with '
        '${_marsStyle[mars] ?? "steady determination and focus"}.';
  }

  static String _careerAptitude(String sun, String saturn) {
    return 'Your Sun in $sun gives you natural talent for '
        '${_sunCareer[sun] ?? "leadership and creative expression"}. '
        'Saturn in $saturn structures your professional growth through '
        '${_saturnLesson[saturn] ?? "discipline and perseverance"}.';
  }

  static const _signStrengths = {
    'Aries': ['Bold initiative', 'Courageous', 'Pioneering spirit'],
    'Taurus': ['Unwavering loyalty', 'Patient', 'Sensory intelligence'],
    'Gemini': ['Versatile intellect', 'Adaptable', 'Engaging communicator'],
    'Cancer': ['Nurturing nature', 'Strong intuition', 'Emotional depth'],
    'Leo': ['Magnetic charisma', 'Generous heart', 'Creative vision'],
    'Virgo': ['Analytical precision', 'Service-oriented', 'Methodical'],
    'Libra': ['Diplomatic grace', 'Aesthetic sense', 'Fair-minded'],
    'Scorpio': ['Penetrating insight', 'Transformative power', 'Resilient'],
    'Sagittarius': ['Philosophical wisdom', 'Adventurous', 'Optimistic'],
    'Capricorn': ['Strategic ambition', 'Disciplined', 'Pragmatic'],
    'Aquarius': ['Innovative vision', 'Humanitarian values', 'Independent'],
    'Pisces': ['Compassionate soul', 'Artistic sensitivity', 'Intuitive'],
  };

  static const _signChallenges = {
    'Aries': ['Impulsiveness', 'Short temper'],
    'Taurus': ['Stubbornness', 'Possessiveness'],
    'Gemini': ['Inconsistency', 'Restlessness'],
    'Cancer': ['Mood swings', 'Over-sensitivity'],
    'Leo': ['Need for validation', 'Pride'],
    'Virgo': ['Perfectionism', 'Self-criticism'],
    'Libra': ['Indecisiveness', 'People-pleasing'],
    'Scorpio': ['Jealousy', 'Control issues'],
    'Sagittarius': ['Over-promising', 'Bluntness'],
    'Capricorn': ['Workaholism', 'Emotional guardedness'],
    'Aquarius': ['Emotional detachment', 'Contrarianism'],
    'Pisces': ['Escapism', 'Boundary issues'],
  };

  static const _venusStyle = {
    'Aries': 'passionate pursuit and direct expression',
    'Taurus': 'sensual touch, gifts, and unwavering devotion',
    'Gemini': 'witty banter, intellectual stimulation, and variety',
    'Cancer': 'nurturing care, emotional safety, and home-building',
    'Leo': 'grand romantic gestures and lavish affection',
    'Virgo': 'acts of service and thoughtful attention to detail',
    'Libra': 'harmony, beauty, and partnership equality',
    'Scorpio': 'intense soul-deep bonds and emotional honesty',
    'Sagittarius': 'shared adventures and philosophical connection',
    'Capricorn': 'committed dedication and building together',
    'Aquarius': 'intellectual freedom and unconventional connection',
    'Pisces': 'romantic idealism and spiritual merging',
  };

  static const _marsStyle = {
    'Aries': 'direct, fiery action and competitive energy',
    'Taurus': 'slow-burning sensuality and persistent effort',
    'Gemini': 'mental stimulation and verbal sparring',
    'Cancer': 'protective instincts and emotional intensity',
    'Leo': 'dramatic flair and confident assertion',
    'Virgo': 'precise, methodical pursuit of goals',
    'Libra': 'strategic charm and diplomatic maneuvering',
    'Scorpio': 'magnetic intensity and unwavering focus',
    'Sagittarius': 'enthusiastic exploration and bold risk-taking',
    'Capricorn': 'calculated ambition and endurance',
    'Aquarius': 'unconventional methods and collective causes',
    'Pisces': 'flowing adaptability and creative channeling',
  };

  static const _sunCareer = {
    'Aries': 'entrepreneurship, sports, and competitive fields',
    'Taurus': 'finance, luxury goods, and agriculture',
    'Gemini': 'media, writing, and technology',
    'Cancer': 'healthcare, hospitality, and counseling',
    'Leo': 'entertainment, management, and the arts',
    'Virgo': 'healthcare, analysis, and quality assurance',
    'Libra': 'law, diplomacy, and design',
    'Scorpio': 'research, psychology, and investigation',
    'Sagittarius': 'education, travel, and publishing',
    'Capricorn': 'business, government, and engineering',
    'Aquarius': 'technology, social innovation, and science',
    'Pisces': 'arts, healing, and spiritual guidance',
  };

  static const _saturnLesson = {
    'Aries': 'patience and measured leadership',
    'Taurus': 'financial wisdom and material discipline',
    'Gemini': 'focused communication and intellectual depth',
    'Cancer': 'emotional maturity and family responsibility',
    'Leo': 'humble confidence and earned recognition',
    'Virgo': 'practical mastery and service excellence',
    'Libra': 'commitment and fair judgment',
    'Scorpio': 'trust, vulnerability, and power management',
    'Sagittarius': 'grounded optimism and ethical structure',
    'Capricorn': 'ambitious persistence and institutional building',
    'Aquarius': 'disciplined innovation and community structure',
    'Pisces': 'spiritual discipline and creative perseverance',
  };
}
