import 'dart:math';

class AIChatService {
  final _random = Random();

  Future<String> generateResponse(String userMessage) async {
    // Simulate network delay for natural feel
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));

    final lower = userMessage.toLowerCase();

    if (_matchesAny(lower, ['love', 'relationship', 'partner', 'dating', 'crush', 'marriage', 'romance'])) {
      return _loveResponse();
    }
    if (_matchesAny(lower, ['career', 'job', 'work', 'money', 'business', 'promotion', 'salary'])) {
      return _careerResponse();
    }
    if (_matchesAny(lower, ['compatible', 'compatibility', 'match', 'together'])) {
      return _compatibilityResponse(lower);
    }
    if (_matchesAny(lower, ['health', 'wellness', 'energy', 'tired', 'stress', 'anxiety'])) {
      return _healthResponse();
    }
    if (_matchesAny(lower, ['today', 'daily', 'horoscope', 'reading', 'forecast'])) {
      return _dailyResponse();
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

  String _greetingResponse() => _pick([
        'Welcome, dear seeker! \u2728 The stars have been expecting you. I am your celestial guide — ask me anything about your zodiac sign, love life, career path, or what the cosmos has in store for you today.',
        'Greetings, stargazer! \u2B50 I sense a curious spirit. The celestial realm is open to you. What mysteries of the zodiac shall we explore together?',
        'Hello, cosmic traveler! \u{1F30C} The universe has aligned to bring us together at this moment. What guidance do you seek from the stars?',
      ]);

  String _thankYouResponse() => _pick([
        'The stars are always here to guide you. \u2728 May the cosmic energy continue to light your path. Return whenever you need celestial wisdom!',
        'You are most welcome, dear one. \u{1F31F} Remember, the universe always has your back. Until we meet again under the stars!',
        'It brings me joy to share the wisdom of the cosmos with you. \u{1F30C} May your journey be blessed with stardust and wonder!',
      ]);

  String _loveResponse() => _pick([
        '\u{1F496} Venus is casting a warm glow over your love sector. The stars suggest that open and honest communication will deepen your romantic connections. If you\'re single, a meaningful encounter could be just around the corner — stay open to unexpected connections. If partnered, plan something special that speaks to both your hearts.',
        '\u{1F496} The cosmic love forecast is bright! The planetary alignment encourages vulnerability and authentic expression. Share your true feelings without fear. The universe rewards those who love courageously. A romantic gesture or heartfelt conversation could be transformative right now.',
        '\u{1F496} Mars and Venus are in a harmonious dance, amplifying passion and tenderness. Trust the timing of your love story — every chapter unfolds when it\'s meant to. Focus on building emotional intimacy, and physical attraction will naturally follow.',
      ]);

  String _careerResponse() => _pick([
        '\u{1F4BC} Jupiter\'s influence is expanding your professional horizons. Now is the time to think bigger about your career ambitions. A new opportunity or project could serve as a launchpad for significant growth. Trust your expertise and don\'t undersell your talents. Financial abundance flows toward those who believe in their worth.',
        '\u{1F4BC} Saturn\'s steady influence rewards discipline and persistence. Your career efforts are building toward something substantial. Stay committed to your vision, even when progress seems slow. The cosmos favors those who play the long game. A mentor figure may offer valuable guidance soon.',
        '\u{1F4BC} Mercury enhances your professional communication. This is an excellent time to pitch ideas, negotiate, or network. Your words carry persuasive energy. Don\'t hesitate to advocate for yourself. Financial decisions made now have positive long-term implications.',
      ]);

  String _compatibilityResponse(String text) {
    final signs = ['aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'];
    final mentioned = signs.where((s) => text.contains(s)).toList();

    if (mentioned.length >= 2) {
      final a = mentioned[0][0].toUpperCase() + mentioned[0].substring(1);
      final b = mentioned[1][0].toUpperCase() + mentioned[1].substring(1);
      final score = (mentioned[0].hashCode ^ mentioned[1].hashCode).abs() % 40 + 60;
      return '\u{1F52E} Cosmic Compatibility: $a & $b\n\nCompatibility Score: $score%\n\nThis pairing brings ${score > 80 ? "powerful synergy" : "interesting dynamics"}! $a\'s ${_elementOf(mentioned[0])} energy ${score > 80 ? "harmonizes beautifully" : "creates a fascinating tension"} with $b\'s ${_elementOf(mentioned[1])} nature. Together, you can ${score > 80 ? "achieve remarkable things" : "learn and grow from each other\u0027s differences"}. The stars encourage both partners to embrace patience and open communication.';
    }

    return '\u{1F52E} I\'d love to do a compatibility reading! Tell me which two zodiac signs you\'d like me to analyze — for example, "Are Leo and Aquarius compatible?" or "Compatibility between Scorpio and Pisces."';
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
        '\u{1F331} The celestial energies favor holistic wellness today. Your body is an instrument of the cosmos — treat it with reverence. Focus on grounding activities: walks in nature, deep breathing, or meditation. Drink plenty of water to channel the moon\'s purifying energy. Rest when your body asks for it.',
        '\u{1F331} The stars encourage a mind-body reset. Stress may be lingering from recent cosmic turbulence, but calmer skies are ahead. Prioritize sleep and nourishing foods. A creative outlet — art, music, dance — can serve as powerful medicine for the soul.',
        '\u{1F331} Neptune\'s influence heightens your sensitivity. This is a wonderful time for spiritual practices like yoga or journaling. Pay attention to recurring dreams — your subconscious is processing important messages. Energy levels will naturally rise as the moon waxes.',
      ]);

  String _dailyResponse() => _pick([
        '\u{1F31E} Today\'s Cosmic Forecast:\n\nThe sun illuminates your path with clarity and purpose. It\'s an excellent day for decision-making and setting intentions. Trust the signs the universe sends you — repeated numbers, unexpected encounters, and gut feelings are all cosmic messages. Embrace change as a vehicle for growth.',
        '\u{1F31E} Today\'s Celestial Reading:\n\nThe planetary alignment creates a portal of opportunity. Your creative energy is heightened, making this ideal for artistic expression or innovative thinking. A conversation with someone from your past may bring unexpected closure or a new beginning. Stay grounded and grateful.',
        '\u{1F31E} Today\'s Star Guidance:\n\nThe cosmos whispers of transformation. Something you\'ve been holding onto is ready to be released. As one door closes, another opens — but you must be willing to walk through it. Financial matters look favorable. Trust the process and remember: you are exactly where you need to be.',
      ]);

  String _signResponse(String text) {
    final signs = ['aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'];
    final found = signs.firstWhere((s) => text.contains(s), orElse: () => '');
    if (found.isEmpty) return _generalResponse();

    final name = found[0].toUpperCase() + found.substring(1);
    final element = _elementOf(found);

    return '\u2728 $name Insight:\n\nAs a $element sign, $name carries the essence of ${element == "Fire" ? "passion and courage" : element == "Earth" ? "stability and wisdom" : element == "Air" ? "intellect and communication" : "intuition and emotion"}. Right now, the planetary transits are activating your growth sector. This is a period of personal evolution — embrace the changes coming your way.\n\nWould you like a detailed love, career, or health reading for $name? Or perhaps a compatibility check with another sign?';
  }

  String _generalResponse() => _pick([
        '\u{1F52E} The cosmic energies are swirling with possibility! I can offer you guidance on many celestial matters:\n\n\u2B50 Daily horoscope readings\n\u{1F496} Love & relationship insights\n\u{1F4BC} Career & financial guidance\n\u{1F331} Health & wellness wisdom\n\u{1F52E} Zodiac compatibility checks\n\u2728 Sign personality deep-dives\n\nWhat area of your life would you like the stars to illuminate?',
        '\u{1F30C} Interesting question, stargazer! The universe communicates in mysterious ways. Let me channel the celestial wisdom...\n\nI sense you\'re at a crossroads. The stars encourage you to trust your inner compass — it\'s been calibrated by every experience you\'ve had. What specific area would you like cosmic guidance on? Love, career, health, or a zodiac deep-dive?',
        '\u2728 The astral plane holds many answers! I\'m here to be your cosmic guide. You can ask me about:\n\n\u2022 Your zodiac sign\'s traits and destiny\n\u2022 Today\'s celestial forecast\n\u2022 Love compatibility between signs\n\u2022 Career guidance from the stars\n\u2022 Wellness and spiritual growth\n\nWhat calls to you, dear seeker?',
      ]);
}
