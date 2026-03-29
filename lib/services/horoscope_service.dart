import 'dart:math';
import 'package:intl/intl.dart';
import '../models/birth_chart.dart';
import '../models/horoscope.dart';
import '../models/planet_position.dart';
import 'astro/astro_engine.dart';
import 'astro/moon_phase.dart';
import 'astro/transit_calculator.dart';
import 'astro/void_of_course.dart';

class HoroscopeService {
  // Fallback templates when no notable transits found
  static const _fallbackDaily = [
    'The stars align in your favor today. Trust your instincts and take that leap of faith you\'ve been contemplating. The universe is sending you powerful energy for new beginnings.',
    'Today brings a wave of clarity to your life. Old patterns are dissolving, making room for fresh perspectives. Pay attention to synchronicities around you.',
    'A powerful cosmic shift is underway. Your intuition is heightened, and creative energy flows freely. Use this time to express yourself authentically.',
    'The celestial bodies encourage patience today. Not everything needs to happen at once. Take time to nurture your inner world and reconnect with your deeper purpose.',
    'An unexpected opportunity may present itself. Stay open-minded and flexible. The universe often delivers its gifts in surprising packages.',
    'Today\'s planetary alignment boosts your communication skills. Share your ideas boldly — someone important is listening. Your words carry extra weight right now.',
    'The moon\'s influence brings emotional depth today. Embrace vulnerability as a strength. Deep connections are forged through authentic expression.',
    'Cosmic energy supports transformation. Release what no longer serves you and welcome new chapters. You are more resilient than you realize.',
  ];

  static const _fallbackLove = [
    'Venus smiles upon your love life. Whether single or partnered, open your heart to deeper emotional connections.',
    'Communication is key in love today. Express your feelings openly and listen with compassion.',
    'The stars encourage self-love today. Confidence is magnetic.',
    'A romantic surprise may be on the horizon. Stay present and attentive.',
  ];

  static const _fallbackCareer = [
    'Professional momentum is building. Your hard work is about to pay off.',
    'A collaborative opportunity emerges. Working with others amplifies your strengths.',
    'Innovation is your superpower today. Think outside the box.',
    'Financial wisdom is highlighted. Review your goals and adjust your strategy.',
  ];

  static const _fallbackHealth = [
    'Your vitality is strong. Channel this energy into physical activity that brings you joy.',
    'Rest and rejuvenation are called for. Listen to your body\'s signals.',
    'Mental clarity comes through movement. A walk in nature can unlock solutions.',
    'Nourish yourself with intention today. Quality inputs create quality outputs.',
  ];

  Horoscope getHoroscope(String signName, {BirthChart? chart}) {
    final currentPositions = AstroEngine.currentPositions();
    final now = DateTime.now();
    final seed = signName.hashCode + now.day;
    final seeded = Random(seed);

    // Calculate current moon phase
    final sunPos = currentPositions[CelestialBody.sun]!;
    final moonPos = currentPositions[CelestialBody.moon]!;
    final moonPhase = MoonPhaseCalculator.calculatePhase(
      sunPos.eclipticLongitude,
      moonPos.eclipticLongitude,
    );

    // Get transit alerts
    final transits = chart != null
        ? TransitCalculator.calculateTransits(
            currentPositions,
            natalPositions: chart.planets,
          )
        : TransitCalculator.calculateGenericTransits(
            currentPositions,
            signName,
          );

    final keyTransitStrings = transits
        .take(5)
        .map((t) => t.title)
        .toList();

    // Generate readings based on transits
    final dailyReading = _buildDailyReading(transits, moonPhase, signName, seeded);
    final loveReading = _buildLoveReading(transits, currentPositions, signName, seeded);
    final careerReading = _buildCareerReading(transits, currentPositions, signName, seeded);
    final healthReading = _buildHealthReading(moonPhase, currentPositions, seeded);

    // Derive mood from moon phase
    final mood = _moodFromPhase(moonPhase);

    // Derive lucky number from dominant transit angle
    final luckyNumber = transits.isNotEmpty
        ? '${(transits.first.title.hashCode.abs() % 99) + 1}'
        : '${seeded.nextInt(99) + 1}';

    // Derive lucky color from moon sign element
    final luckyColor = _colorFromElement(
      _elementOf(moonPos.zodiacPosition.sign),
    );

    // Transit context summary
    final transitContext = transits.isNotEmpty
        ? 'Key transit: ${transits.first.title}. ${transits.first.significance}'
        : null;

    // Void of Course Moon check
    String? vocWarning;
    final moonSpeed = moonPos.dailyMotion ?? 13.0;
    final planetLons = <String, double>{};
    for (final entry in currentPositions.entries) {
      if (entry.key != CelestialBody.moon) {
        planetLons[entry.key.name] = entry.value.eclipticLongitude;
      }
    }
    if (VoidOfCourseMoon.isVoidOfCourse(
        moonPos.eclipticLongitude, moonSpeed, planetLons)) {
      vocWarning = 'The Moon is currently Void of Course — '
          'not the best time to start new ventures, sign contracts, or '
          'make major decisions. Use this period for rest, reflection, '
          'and completing existing tasks.';
    }

    return Horoscope(
      sign: signName,
      date: DateFormat('MMMM d, yyyy').format(now),
      dailyReading: dailyReading,
      loveReading: loveReading,
      careerReading: careerReading,
      healthReading: healthReading,
      luckyNumber: luckyNumber,
      luckyColor: luckyColor,
      mood: mood,
      compatibility: (seeded.nextInt(40) + 60) / 100,
      transitContext: transitContext,
      moonPhaseToday: '${MoonPhaseCalculator.phaseEmoji(moonPhase)} $moonPhase',
      keyTransits: keyTransitStrings.isEmpty ? null : keyTransitStrings,
      voidOfCourseMoonWarning: vocWarning,
    );
  }

  String _buildDailyReading(
    List transits,
    String moonPhase,
    String signName,
    Random seeded,
  ) {
    final parts = <String>[];

    // Moon phase context
    parts.add(
      '${MoonPhaseCalculator.phaseEmoji(moonPhase)} Today\'s $moonPhase '
      '${MoonPhaseCalculator.phaseDescription(moonPhase).split('.').first}.',
    );

    // Top transit influence
    if (transits.isNotEmpty) {
      final top = transits.first;
      parts.add('${top.description} ${top.significance}');
    }

    // Outer planet transits (Uranus, Neptune, Pluto) — long-term themes
    final outerTransits = transits.where((t) =>
        t.planet == CelestialBody.uranus ||
        t.planet == CelestialBody.neptune ||
        t.planet == CelestialBody.pluto).toList();
    if (outerTransits.isNotEmpty && outerTransits.first != transits.firstOrNull) {
      final outer = outerTransits.first;
      parts.add('Long-term theme: ${outer.description}');
    }

    if (parts.length < 2) {
      parts.add(_fallbackDaily[seeded.nextInt(_fallbackDaily.length)]);
    }

    return parts.join(' ');
  }

  String _buildLoveReading(
    List transits,
    Map<CelestialBody, PlanetPosition> positions,
    String signName,
    Random seeded,
  ) {
    // Check for Venus or Mars transits
    final venusTransit = transits.where(
      (t) => t.planet == CelestialBody.venus,
    );
    if (venusTransit.isNotEmpty) {
      final vt = venusTransit.first;
      return '${vt.description} ${vt.significance}';
    }

    final marsTransit = transits.where(
      (t) => t.planet == CelestialBody.mars,
    );
    if (marsTransit.isNotEmpty) {
      final mt = marsTransit.first;
      return 'Passion is highlighted: ${mt.description}';
    }

    // Venus sign context
    final venus = positions[CelestialBody.venus];
    if (venus != null) {
      return 'Venus in ${venus.zodiacPosition.sign} colors today\'s romantic energy with '
          '${_venusEnergy(venus.zodiacPosition.sign)}. '
          '${_fallbackLove[seeded.nextInt(_fallbackLove.length)]}';
    }

    return _fallbackLove[seeded.nextInt(_fallbackLove.length)];
  }

  String _buildCareerReading(
    List transits,
    Map<CelestialBody, PlanetPosition> positions,
    String signName,
    Random seeded,
  ) {
    // Check for Saturn or Jupiter transits
    final saturnTransit = transits.where(
      (t) => t.planet == CelestialBody.saturn,
    );
    if (saturnTransit.isNotEmpty) {
      final st = saturnTransit.first;
      return '${st.description} ${st.significance}';
    }

    final jupiterTransit = transits.where(
      (t) => t.planet == CelestialBody.jupiter,
    );
    if (jupiterTransit.isNotEmpty) {
      final jt = jupiterTransit.first;
      return 'Professional growth is highlighted: ${jt.description}';
    }

    // Mercury context for communication
    final mercury = positions[CelestialBody.mercury];
    if (mercury != null && mercury.isRetrograde) {
      return 'Mercury retrograde in ${mercury.zodiacPosition.sign} advises caution in business communications. '
          'Review contracts and double-check details before committing.';
    }

    return _fallbackCareer[seeded.nextInt(_fallbackCareer.length)];
  }

  String _buildHealthReading(
    String moonPhase,
    Map<CelestialBody, PlanetPosition> positions,
    Random seeded,
  ) {
    // Moon phase health advice
    if (moonPhase == 'Full Moon' || moonPhase == 'New Moon') {
      return moonPhase == 'Full Moon'
          ? 'The Full Moon amplifies physical energy but may disrupt sleep. '
              'Ground yourself with calming activities and stay hydrated.'
          : 'The New Moon favors rest and restoration. '
              'Begin new health routines — your body is receptive to change.';
    }

    if (moonPhase.contains('Waning')) {
      return 'The waning moon supports detox and release. '
          'Focus on rest, stretching, and letting go of tension.';
    }

    if (moonPhase.contains('Waxing')) {
      return 'The waxing moon builds energy. '
          'Increase activity levels gradually and fuel your body well.';
    }

    return _fallbackHealth[seeded.nextInt(_fallbackHealth.length)];
  }

  String _moodFromPhase(String moonPhase) {
    switch (moonPhase) {
      case 'New Moon': return 'Reflective';
      case 'Waxing Crescent': return 'Hopeful';
      case 'First Quarter': return 'Determined';
      case 'Waxing Gibbous': return 'Focused';
      case 'Full Moon': return 'Energetic';
      case 'Waning Gibbous': return 'Grateful';
      case 'Third Quarter': return 'Releasing';
      case 'Waning Crescent': return 'Tranquil';
      default: return 'Balanced';
    }
  }

  String _colorFromElement(String element) {
    switch (element) {
      case 'Fire': return 'Crimson Red';
      case 'Earth': return 'Emerald Green';
      case 'Air': return 'Celestial Blue';
      case 'Water': return 'Ocean Teal';
      default: return 'Silver Moon';
    }
  }

  String _elementOf(String sign) {
    const elements = {
      'Aries': 'Fire', 'Leo': 'Fire', 'Sagittarius': 'Fire',
      'Taurus': 'Earth', 'Virgo': 'Earth', 'Capricorn': 'Earth',
      'Gemini': 'Air', 'Libra': 'Air', 'Aquarius': 'Air',
      'Cancer': 'Water', 'Scorpio': 'Water', 'Pisces': 'Water',
    };
    return elements[sign] ?? 'Fire';
  }

  String _venusEnergy(String sign) {
    const energies = {
      'Aries': 'passionate pursuit and bold attraction',
      'Taurus': 'sensual warmth and steady devotion',
      'Gemini': 'playful curiosity and intellectual flirtation',
      'Cancer': 'nurturing tenderness and emotional safety',
      'Leo': 'dramatic romance and generous affection',
      'Virgo': 'thoughtful care and quiet devotion',
      'Libra': 'harmonious partnership and aesthetic pleasure',
      'Scorpio': 'intense magnetism and transformative bonds',
      'Sagittarius': 'adventurous connection and expansive love',
      'Capricorn': 'committed loyalty and enduring partnership',
      'Aquarius': 'unconventional attraction and intellectual spark',
      'Pisces': 'dreamy romance and spiritual union',
    };
    return energies[sign] ?? 'deep connection';
  }
}
