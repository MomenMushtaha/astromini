import 'dart:math';
import 'package:intl/intl.dart';
import '../models/horoscope.dart';

class HoroscopeService {
  static const _dailyReadings = [
    'The stars align in your favor today. Trust your instincts and take that leap of faith you\'ve been contemplating. The universe is sending you powerful energy for new beginnings.',
    'Today brings a wave of clarity to your life. Old patterns are dissolving, making room for fresh perspectives. Pay attention to synchronicities around you.',
    'A powerful cosmic shift is underway. Your intuition is heightened, and creative energy flows freely. Use this time to express yourself authentically.',
    'The celestial bodies encourage patience today. Not everything needs to happen at once. Take time to nurture your inner world and reconnect with your deeper purpose.',
    'An unexpected opportunity may present itself. Stay open-minded and flexible. The universe often delivers its gifts in surprising packages.',
    'Today\'s planetary alignment boosts your communication skills. Share your ideas boldly — someone important is listening. Your words carry extra weight right now.',
    'The moon\'s influence brings emotional depth today. Embrace vulnerability as a strength. Deep connections are forged through authentic expression.',
    'Cosmic energy supports transformation. Release what no longer serves you and welcome new chapters. You are more resilient than you realize.',
  ];

  static const _loveReadings = [
    'Venus smiles upon your love life. Whether single or partnered, open your heart to deeper emotional connections. Romance is in the air.',
    'Communication is key in love today. Express your feelings openly and listen with compassion. A heartfelt conversation could transform your relationship.',
    'The stars encourage self-love today. Before seeking connection with others, nurture the relationship you have with yourself. Confidence is magnetic.',
    'A romantic surprise may be on the horizon. Stay present and attentive to the subtle signals around you. Love often whispers before it shouts.',
  ];

  static const _careerReadings = [
    'Professional momentum is building. Your hard work is about to pay off in ways you didn\'t expect. Stay focused and maintain your high standards.',
    'A collaborative opportunity emerges. Working with others amplifies your strengths. Be open to partnerships that complement your skillset.',
    'Innovation is your superpower today. Think outside the box and propose that unconventional idea. Decision-makers are receptive to fresh approaches.',
    'Financial wisdom is highlighted. Review your goals and adjust your strategy. Small, consistent steps lead to remarkable achievements.',
  ];

  static const _healthReadings = [
    'Your vitality is strong. Channel this energy into physical activity that brings you joy. Mind-body connection is especially powerful now.',
    'Rest and rejuvenation are called for. Listen to your body\'s signals and honor your need for downtime. Recovery is productive.',
    'Mental clarity comes through movement. A walk in nature or gentle exercise can unlock solutions to problems that have been on your mind.',
    'Nourish yourself with intention today. Pay attention to what you consume — food, media, conversations. Quality inputs create quality outputs.',
  ];

  static const _moods = [
    'Energetic',
    'Reflective',
    'Optimistic',
    'Passionate',
    'Tranquil',
    'Adventurous',
    'Inspired',
    'Determined',
  ];

  static const _colors = [
    'Royal Purple',
    'Celestial Blue',
    'Golden Amber',
    'Emerald Green',
    'Rose Quartz',
    'Silver Moon',
    'Crimson Red',
    'Ocean Teal',
  ];

  Horoscope getHoroscope(String signName) {
    final seed = signName.hashCode + DateTime.now().day;
    final seeded = Random(seed);

    return Horoscope(
      sign: signName,
      date: DateFormat('MMMM d, yyyy').format(DateTime.now()),
      dailyReading: _dailyReadings[seeded.nextInt(_dailyReadings.length)],
      loveReading: _loveReadings[seeded.nextInt(_loveReadings.length)],
      careerReading: _careerReadings[seeded.nextInt(_careerReadings.length)],
      healthReading: _healthReadings[seeded.nextInt(_healthReadings.length)],
      luckyNumber: '${seeded.nextInt(99) + 1}',
      luckyColor: _colors[seeded.nextInt(_colors.length)],
      mood: _moods[seeded.nextInt(_moods.length)],
      compatibility: (seeded.nextInt(40) + 60) / 100,
    );
  }
}
