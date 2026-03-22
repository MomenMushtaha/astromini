import 'dart:math';
import '../models/birth_chart.dart';
import '../models/personality_profile.dart';
import '../models/planet_position.dart';

class AIChatService {
  final _random = Random();
  BirthChart? _chart;
  PersonalityProfile? _profile;

  void updateContext(BirthChart? chart, PersonalityProfile? profile) {
    _chart = chart;
    _profile = profile;
  }

  Future<String> generateResponse(String userMessage) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));

    final lower = userMessage.toLowerCase();

    // Chart-aware responses when chart is available
    if (_chart != null) {
      if (_matchesAny(lower, ['chart', 'planet', 'house', 'aspect', 'position', 'placement'])) {
        return _chartBasedResponse(lower);
      }
      if (_matchesAny(lower, ['transit', 'current', 'sky', 'now', 'retrograde'])) {
        return _transitResponse();
      }
      if (_matchesAny(lower, ['sun', 'moon', 'rising', 'ascendant', 'mercury', 'venus', 'mars', 'jupiter', 'saturn'])) {
        return _aspectInterpretation(lower);
      }
    }

    if (_matchesAny(lower, ['love', 'relationship', 'partner', 'dating', 'crush', 'marriage', 'romance'])) {
      return _chart != null ? _personalLoveResponse() : _loveResponse();
    }
    if (_matchesAny(lower, ['career', 'job', 'work', 'money', 'business', 'promotion', 'salary'])) {
      return _chart != null ? _personalCareerResponse() : _careerResponse();
    }
    if (_matchesAny(lower, ['compatible', 'compatibility', 'match', 'together'])) {
      return _compatibilityResponse(lower);
    }
    if (_matchesAny(lower, ['health', 'wellness', 'energy', 'tired', 'stress', 'anxiety'])) {
      return _healthResponse();
    }
    if (_matchesAny(lower, ['today', 'daily', 'horoscope', 'reading', 'forecast'])) {
      return _chart != null ? _personalDailyResponse() : _dailyResponse();
    }
    if (_matchesAny(lower, ['personality', 'profile', 'who am i', 'myself', 'about me'])) {
      return _chart != null ? _personalityResponse() : _generalResponse();
    }
    if (_matchesAny(lower, ['aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'])) {
      return _signResponse(lower);
    }
    if (_matchesAny(lower, ['hello', 'hi', 'hey', 'greetings'])) {
      return _greetingResponse();
    }
    if (_matchesAny(lower, ['thank', 'thanks'])) {
      return _thankYouResponse();
    }

    return _generalResponse();
  }

  bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  String _pick(List<String> options) => options[_random.nextInt(options.length)];

  // --- Chart-based analytical responses ---

  String _chartBasedResponse(String text) {
    final c = _chart!;
    final buf = StringBuffer('\u{1F52D} Birth Chart Analysis:\n\n');

    buf.writeln('Your natal chart shows the following key placements:\n');

    final planets = c.planets.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));

    for (final entry in planets.take(5)) {
      final body = entry.key;
      final pos = entry.value;
      buf.writeln('\u2022 ${body.displayName} at ${pos.zodiacPosition.formatted} in House ${pos.house}${pos.isRetrograde ? " (Retrograde)" : ""}');
    }

    buf.writeln('\nYour Ascendant is at ${c.ascendant.toStringAsFixed(1)}\u00B0 (${c.risingSignName} Rising), giving you a ${_risingTraits(c.risingSignName)} outward persona.');

    if (c.aspects.isNotEmpty) {
      buf.writeln('\nKey aspects: ${c.aspects.take(3).map((a) => "${a.planet1.displayName} ${a.type.displayName} ${a.planet2.displayName} (orb ${a.orb.toStringAsFixed(1)}\u00B0)").join(", ")}.');
    }

    return buf.toString();
  }

  String _transitResponse() {
    final c = _chart!;
    final sunPos = c.planets[CelestialBody.sun]!;
    final moonPos = c.planets[CelestialBody.moon]!;

    return '\u{1F30C} Transit Reading for your chart:\n\n'
        'With your natal Sun at ${sunPos.zodiacPosition.formatted} (House ${sunPos.house}), '
        'current transiting planets are activating your ${_houseArea(sunPos.house)} sector. '
        'Your natal Moon at ${moonPos.zodiacPosition.formatted} suggests emotional shifts around ${_moonTheme(moonPos.zodiacPosition.sign)}.\n\n'
        'Check the Sky Map tab for real-time planetary positions and how they interact with your natal placements.';
  }

  String _aspectInterpretation(String text) {
    final c = _chart!;
    CelestialBody? target;

    if (text.contains('sun')) {
      target = CelestialBody.sun;
    } else if (text.contains('moon')) {
      target = CelestialBody.moon;
    } else if (text.contains('rising') || text.contains('ascendant')) {
      return '\u2B06\uFE0F Your Ascendant at ${c.ascendant.toStringAsFixed(1)}\u00B0 places ${c.risingSignName} on your eastern horizon at birth.\n\n'
          'This means you project ${_risingTraits(c.risingSignName)} energy to the world. '
          'People\'s first impression of you is shaped by ${c.risingSignName} qualities. '
          'Your rising sign acts as a mask — it\'s how you navigate new situations and first encounters.';
    } else if (text.contains('mercury')) {
      target = CelestialBody.mercury;
    } else if (text.contains('venus')) {
      target = CelestialBody.venus;
    } else if (text.contains('mars')) {
      target = CelestialBody.mars;
    } else if (text.contains('jupiter')) {
      target = CelestialBody.jupiter;
    } else if (text.contains('saturn')) {
      target = CelestialBody.saturn;
    }

    if (target != null && c.planets.containsKey(target)) {
      final pos = c.planets[target]!;
      final aspects = c.aspects.where((a) => a.planet1 == target || a.planet2 == target).take(3);

      final buf = StringBuffer('${target.symbol} ${target.displayName} Analysis:\n\n');
      buf.writeln('Position: ${pos.zodiacPosition.formatted} in House ${pos.house}${pos.isRetrograde ? " (Retrograde)" : ""}');
      buf.writeln('Ecliptic longitude: ${pos.eclipticLongitude.toStringAsFixed(2)}\u00B0\n');
      buf.writeln('${_planetMeaning(target)} in ${pos.zodiacPosition.sign} expresses through ${_signEnergy(pos.zodiacPosition.sign)} energy. '
          'In House ${pos.house}, this influence manifests in your ${_houseArea(pos.house)} life area.');

      if (aspects.isNotEmpty) {
        buf.writeln('\nKey aspects:');
        for (final a in aspects) {
          final other = a.planet1 == target ? a.planet2 : a.planet1;
          buf.writeln('\u2022 ${a.type.displayName} ${other.displayName} (orb ${a.orb.toStringAsFixed(1)}\u00B0) — ${_aspectMeaning(a.type.displayName)}');
        }
      }

      return buf.toString();
    }

    return _chartBasedResponse(text);
  }

  String _personalLoveResponse() {
    final c = _chart!;
    final venus = c.planets[CelestialBody.venus];
    final mars = c.planets[CelestialBody.mars];
    final moon = c.planets[CelestialBody.moon];

    final buf = StringBuffer('\u{1F496} Personalized Love Reading:\n\n');

    if (venus != null) {
      buf.writeln('Your Venus at ${venus.zodiacPosition.formatted} (House ${venus.house}) reveals your love language. '
          'Venus in ${venus.zodiacPosition.sign} means you ${_venusStyle(venus.zodiacPosition.sign)}.');
    }
    if (mars != null) {
      buf.writeln('\nMars at ${mars.zodiacPosition.formatted} shows your passion style: ${_marsStyle(mars.zodiacPosition.sign)}.');
    }
    if (moon != null) {
      buf.writeln('\nWith Moon in ${moon.zodiacPosition.sign}, your emotional needs center around ${_moonTheme(moon.zodiacPosition.sign)}.');
    }

    return buf.toString();
  }

  String _personalCareerResponse() {
    final c = _chart!;
    final sun = c.planets[CelestialBody.sun]!;
    final saturn = c.planets[CelestialBody.saturn];
    final jupiter = c.planets[CelestialBody.jupiter];

    final buf = StringBuffer('\u{1F4BC} Personalized Career Reading:\n\n');
    buf.writeln('Sun at ${sun.zodiacPosition.formatted} in House ${sun.house}: Your core identity and purpose align with ${_houseArea(sun.house)} pursuits. '
        'In ${sun.zodiacPosition.sign}, you shine through ${_signEnergy(sun.zodiacPosition.sign)} expression.');

    if (saturn != null) {
      buf.writeln('\nSaturn at ${saturn.zodiacPosition.formatted} (House ${saturn.house}): Your greatest professional growth comes through ${_houseArea(saturn.house)} challenges. Saturn here demands discipline and mastery.');
    }
    if (jupiter != null) {
      buf.writeln('\nJupiter at ${jupiter.zodiacPosition.formatted} (House ${jupiter.house}): Abundance and opportunity flow through ${_houseArea(jupiter.house)} activities. This is where luck expands for you.');
    }

    buf.writeln('\nYour Midheaven at ${c.midheaven.toStringAsFixed(1)}\u00B0 points to your public reputation and career direction.');

    return buf.toString();
  }

  String _personalDailyResponse() {
    final c = _chart!;
    final sun = c.planets[CelestialBody.sun]!;

    return '\u{1F31E} Today\'s Personalized Forecast:\n\n'
        'With your natal Sun at ${sun.zodiacPosition.formatted} (House ${sun.house}), '
        'today\'s transiting energies highlight your ${_houseArea(sun.house)} sector. '
        'The cosmic currents favor ${_signEnergy(sun.zodiacPosition.sign)}-oriented activities.\n\n'
        'As a ${c.risingSignName} rising, you may feel drawn to ${_risingActivity(c.risingSignName)} today. '
        'Trust your ${c.moonSign.sign} Moon instincts when making emotional decisions.\n\n'
        'Element balance: ${c.elementBalance.entries.map((e) => "${e.key}: ${e.value}").join(", ")} — '
        '${_dominantElement(c.elementBalance)} energy dominates your chart, shaping today\'s themes.';
  }

  String _personalityResponse() {
    if (_profile != null) {
      return '\u2728 Your Cosmic Profile Summary:\n\n'
          '${_profile!.overallSummary}\n\n'
          'Strengths: ${_profile!.strengths.join(", ")}\n\n'
          'Growth areas: ${_profile!.challenges.join(", ")}\n\n'
          'Visit the Profile tab for the full detailed breakdown of your planetary influences.';
    }

    final c = _chart!;
    return '\u2728 Quick Profile:\n\n'
        'Sun: ${c.sunSign.formatted} — your core identity\n'
        'Moon: ${c.moonSign.formatted} — your emotional nature\n'
        'Rising: ${c.risingSignName} — how others see you\n\n'
        'Generate your full personality profile by tapping the Profile button on the Chart tab for a deep analysis.';
  }

  // --- Helper lookups ---

  String _risingTraits(String sign) {
    const traits = {
      'Aries': 'bold, assertive, and pioneering',
      'Taurus': 'calm, grounded, and sensual',
      'Gemini': 'curious, communicative, and witty',
      'Cancer': 'nurturing, intuitive, and protective',
      'Leo': 'charismatic, confident, and warm',
      'Virgo': 'analytical, modest, and detail-oriented',
      'Libra': 'charming, diplomatic, and graceful',
      'Scorpio': 'intense, magnetic, and perceptive',
      'Sagittarius': 'adventurous, optimistic, and philosophical',
      'Capricorn': 'ambitious, disciplined, and authoritative',
      'Aquarius': 'unique, progressive, and independent',
      'Pisces': 'dreamy, compassionate, and artistic',
    };
    return traits[sign] ?? 'distinctive';
  }

  String _risingActivity(String sign) {
    const activities = {
      'Aries': 'starting new projects and physical activity',
      'Taurus': 'creating comfort and enjoying the senses',
      'Gemini': 'learning, socializing, and multitasking',
      'Cancer': 'home activities and emotional bonding',
      'Leo': 'creative expression and taking center stage',
      'Virgo': 'organizing, health routines, and problem-solving',
      'Libra': 'partnerships, aesthetics, and finding balance',
      'Scorpio': 'deep research, transformation, and intimacy',
      'Sagittarius': 'exploring new ideas and seeking adventure',
      'Capricorn': 'career advancement and building foundations',
      'Aquarius': 'community, innovation, and unconventional thinking',
      'Pisces': 'meditation, creativity, and spiritual pursuits',
    };
    return activities[sign] ?? 'meaningful pursuits';
  }

  String _houseArea(int house) {
    const areas = {
      1: 'identity and self-image',
      2: 'finances and personal values',
      3: 'communication and learning',
      4: 'home and family',
      5: 'creativity and romance',
      6: 'health and daily routines',
      7: 'partnerships and relationships',
      8: 'transformation and shared resources',
      9: 'travel and higher learning',
      10: 'career and public reputation',
      11: 'community and future goals',
      12: 'spirituality and the subconscious',
    };
    return areas[house] ?? 'life';
  }

  String _moonTheme(String sign) {
    const themes = {
      'Aries': 'independence and emotional directness',
      'Taurus': 'security, comfort, and stability',
      'Gemini': 'intellectual stimulation and variety',
      'Cancer': 'nurturing, belonging, and emotional safety',
      'Leo': 'recognition, warmth, and heartfelt expression',
      'Virgo': 'order, usefulness, and practical care',
      'Libra': 'harmony, fairness, and connection',
      'Scorpio': 'depth, intensity, and emotional truth',
      'Sagittarius': 'freedom, meaning, and adventure',
      'Capricorn': 'achievement, structure, and reliability',
      'Aquarius': 'individuality and emotional detachment',
      'Pisces': 'empathy, imagination, and spiritual connection',
    };
    return themes[sign] ?? 'emotional fulfillment';
  }

  String _signEnergy(String sign) {
    const energies = {
      'Aries': 'fiery, initiative-driven',
      'Taurus': 'earthy, sensual',
      'Gemini': 'airy, intellectual',
      'Cancer': 'watery, nurturing',
      'Leo': 'fiery, creative',
      'Virgo': 'earthy, analytical',
      'Libra': 'airy, harmonizing',
      'Scorpio': 'watery, transformative',
      'Sagittarius': 'fiery, expansive',
      'Capricorn': 'earthy, structural',
      'Aquarius': 'airy, innovative',
      'Pisces': 'watery, spiritual',
    };
    return energies[sign] ?? 'cosmic';
  }

  String _planetMeaning(CelestialBody body) {
    const meanings = {
      CelestialBody.sun: 'Your core identity (Sun)',
      CelestialBody.moon: 'Your emotional nature (Moon)',
      CelestialBody.mercury: 'Your communication style (Mercury)',
      CelestialBody.venus: 'Your love language (Venus)',
      CelestialBody.mars: 'Your drive and passion (Mars)',
      CelestialBody.jupiter: 'Your growth and expansion (Jupiter)',
      CelestialBody.saturn: 'Your discipline and lessons (Saturn)',
      CelestialBody.uranus: 'Your rebellion and innovation (Uranus)',
      CelestialBody.neptune: 'Your dreams and intuition (Neptune)',
      CelestialBody.pluto: 'Your transformation and power (Pluto)',
    };
    return meanings[body] ?? body.displayName;
  }

  String _venusStyle(String sign) {
    const styles = {
      'Aries': 'love passionately and chase what you want boldly',
      'Taurus': 'express love through touch, gifts, and unwavering loyalty',
      'Gemini': 'connect through words, humor, and intellectual spark',
      'Cancer': 'love deeply through nurturing and emotional security',
      'Leo': 'love dramatically with grand gestures and warmth',
      'Virgo': 'show love through acts of service and thoughtful details',
      'Libra': 'seek harmony, beauty, and equal partnership in love',
      'Scorpio': 'love with intensity, depth, and total devotion',
      'Sagittarius': 'need freedom and shared adventures in love',
      'Capricorn': 'express love through commitment and building together',
      'Aquarius': 'value uniqueness and friendship in romantic bonds',
      'Pisces': 'love unconditionally with deep empathy and devotion',
    };
    return styles[sign] ?? 'express love in your unique way';
  }

  String _marsStyle(String sign) {
    const styles = {
      'Aries': 'direct, assertive, and quick to act on desire',
      'Taurus': 'slow-burning, sensual, and deeply physical',
      'Gemini': 'mentally stimulated, playful, and versatile',
      'Cancer': 'protective, emotionally driven, and intuitive',
      'Leo': 'confident, warm, and dramatically passionate',
      'Virgo': 'precise, attentive, and service-oriented',
      'Libra': 'charming, considerate, and harmony-seeking',
      'Scorpio': 'magnetic, intense, and transformatively passionate',
      'Sagittarius': 'adventurous, spontaneous, and freedom-loving',
      'Capricorn': 'controlled, ambitious, and enduringly passionate',
      'Aquarius': 'unconventional, experimental, and intellectually driven',
      'Pisces': 'dreamy, selfless, and spiritually connected',
    };
    return styles[sign] ?? 'uniquely passionate';
  }

  String _aspectMeaning(String aspectName) {
    const meanings = {
      'Conjunction': 'intense blending of energies, amplification',
      'Sextile': 'harmonious flow, natural talent and opportunity',
      'Square': 'creative tension, challenge that drives growth',
      'Trine': 'effortless harmony, natural gifts and ease',
      'Opposition': 'polarity and balance, seeing both sides',
    };
    return meanings[aspectName] ?? 'cosmic influence';
  }

  String _dominantElement(Map<String, int> balance) {
    var max = 0;
    var dominant = 'Fire';
    for (final e in balance.entries) {
      if (e.value > max) {
        max = e.value;
        dominant = e.key;
      }
    }
    return dominant;
  }

  // --- Generic responses (no chart needed) ---

  String _greetingResponse() => _pick([
        'Welcome, dear seeker! \u2728 The stars have been expecting you. I am your celestial guide — ask me anything about your zodiac sign, love life, career path, or what the cosmos has in store for you today.${_chart != null ? "\n\nI can see your birth chart — ask me about your specific placements for precise analysis!" : ""}',
        'Greetings, stargazer! \u2B50 I sense a curious spirit. The celestial realm is open to you. What mysteries of the zodiac shall we explore together?${_chart != null ? " I have your chart data ready for detailed readings." : ""}',
      ]);

  String _thankYouResponse() => _pick([
        'The stars are always here to guide you. \u2728 May the cosmic energy continue to light your path. Return whenever you need celestial wisdom!',
        'You are most welcome, dear one. \u{1F31F} Remember, the universe always has your back. Until we meet again under the stars!',
      ]);

  String _loveResponse() => _pick([
        '\u{1F496} Venus is casting a warm glow over your love sector. The stars suggest that open and honest communication will deepen your romantic connections. If you\'re single, a meaningful encounter could be just around the corner. If partnered, plan something special that speaks to both your hearts.\n\nGenerate your birth chart for a personalized love reading based on your Venus and Mars placements!',
        '\u{1F496} The cosmic love forecast is bright! The planetary alignment encourages vulnerability and authentic expression. Share your true feelings without fear. The universe rewards those who love courageously.',
      ]);

  String _careerResponse() => _pick([
        '\u{1F4BC} Jupiter\'s influence is expanding your professional horizons. Now is the time to think bigger about your career ambitions. Trust your expertise and don\'t undersell your talents.\n\nFor a reading based on your exact Saturn, Jupiter, and Midheaven positions, generate your birth chart first!',
        '\u{1F4BC} Saturn\'s steady influence rewards discipline and persistence. Your career efforts are building toward something substantial. Stay committed to your vision.',
      ]);

  String _compatibilityResponse(String text) {
    final signs = ['aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'];
    final mentioned = signs.where((s) => text.contains(s)).toList();

    if (mentioned.length >= 2) {
      final a = mentioned[0][0].toUpperCase() + mentioned[0].substring(1);
      final b = mentioned[1][0].toUpperCase() + mentioned[1].substring(1);
      final score = (mentioned[0].hashCode ^ mentioned[1].hashCode).abs() % 40 + 60;
      return '\u{1F52E} Cosmic Compatibility: $a & $b\n\nCompatibility Score: $score%\n\nThis pairing brings ${score > 80 ? "powerful synergy" : "interesting dynamics"}! $a\'s ${_elementOf(mentioned[0])} energy ${score > 80 ? "harmonizes beautifully" : "creates fascinating tension"} with $b\'s ${_elementOf(mentioned[1])} nature.\n\nFor deep synastry analysis based on exact planetary positions, use the Compatibility Scanner on the Chart tab!';
    }

    return '\u{1F52E} I\'d love to do a compatibility reading! Tell me which two zodiac signs you\'d like me to analyze — for example, "Are Leo and Aquarius compatible?"\n\nFor a detailed chart-to-chart comparison, use the Compatibility Scanner feature!';
  }

  String _elementOf(String sign) {
    const elements = {
      'aries': 'Fire', 'leo': 'Fire', 'sagittarius': 'Fire',
      'taurus': 'Earth', 'virgo': 'Earth', 'capricorn': 'Earth',
      'gemini': 'Air', 'libra': 'Air', 'aquarius': 'Air',
      'cancer': 'Water', 'scorpio': 'Water', 'pisces': 'Water',
    };
    return elements[sign] ?? 'cosmic';
  }

  String _healthResponse() => _pick([
        '\u{1F331} The celestial energies favor holistic wellness today. Focus on grounding activities: walks in nature, deep breathing, or meditation. Drink plenty of water to channel the moon\'s purifying energy. Rest when your body asks for it.',
        '\u{1F331} The stars encourage a mind-body reset. Prioritize sleep and nourishing foods. A creative outlet — art, music, dance — can serve as powerful medicine for the soul.',
      ]);

  String _dailyResponse() => _pick([
        '\u{1F31E} Today\'s Cosmic Forecast:\n\nThe sun illuminates your path with clarity and purpose. It\'s an excellent day for decision-making and setting intentions. Trust the signs the universe sends you.\n\nGenerate your birth chart for a personalized daily reading!',
        '\u{1F31E} Today\'s Celestial Reading:\n\nThe planetary alignment creates a portal of opportunity. Your creative energy is heightened, making this ideal for artistic expression or innovative thinking.',
      ]);

  String _signResponse(String text) {
    final signs = ['aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'];
    final found = signs.firstWhere((s) => text.contains(s), orElse: () => '');
    if (found.isEmpty) return _generalResponse();

    final name = found[0].toUpperCase() + found.substring(1);
    final element = _elementOf(found);

    return '\u2728 $name Insight:\n\nAs a $element sign, $name carries the essence of ${element == "Fire" ? "passion and courage" : element == "Earth" ? "stability and wisdom" : element == "Air" ? "intellect and communication" : "intuition and emotion"}. Right now, the planetary transits are activating your growth sector.\n\nWould you like a detailed love, career, or health reading for $name? Or perhaps a compatibility check with another sign?';
  }

  String _generalResponse() {
    final extra = _chart != null
        ? '\n\n\u{1F52D} I have your birth chart loaded! Ask me about your specific planetary placements, aspects, or houses for precise, data-driven analysis.'
        : '\n\nGenerate your birth chart in the Chart tab for personalized readings based on your exact planetary positions!';

    return _pick([
      '\u{1F52E} The cosmic energies are swirling with possibility! I can offer guidance on:\n\n\u2B50 Daily horoscope readings\n\u{1F496} Love & relationship insights\n\u{1F4BC} Career & financial guidance\n\u{1F331} Health & wellness wisdom\n\u{1F52E} Zodiac compatibility checks\n\u2728 Sign personality deep-dives\n\nWhat area of your life would you like the stars to illuminate?$extra',
      '\u{1F30C} The astral plane holds many answers! You can ask me about your zodiac sign\'s traits, today\'s forecast, love compatibility, career guidance, or wellness.$extra',
    ]);
  }
}
