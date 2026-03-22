import 'dart:math';
import '../models/social_post.dart';

class SocialFeedService {
  List<SocialPost> generatePosts() {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final rng = Random(seed);

    final posts = <SocialPost>[];
    for (int i = 0; i < 40; i++) {
      final sign = _signs[rng.nextInt(_signs.length)];
      final type = PostType.values[rng.nextInt(PostType.values.length)];
      final alias = _generateAlias(sign, rng);
      final content = _generateContent(type, sign, rng);
      final hoursAgo = rng.nextInt(48) + 1;

      posts.add(SocialPost(
        id: 'post_${seed}_$i',
        authorAlias: alias,
        authorSign: sign,
        content: content,
        timestamp: now.subtract(Duration(hours: hoursAgo)),
        type: type,
        reactions: rng.nextInt(50) + 1,
      ));
    }

    posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return posts;
  }

  String _generateAlias(String sign, Random rng) {
    final adj = _adjectives[rng.nextInt(_adjectives.length)];
    final num = rng.nextInt(99) + 1;
    return '$adj$sign$num';
  }

  String _generateContent(PostType type, String sign, Random rng) {
    switch (type) {
      case PostType.reading:
        return _readings[rng.nextInt(_readings.length)]
            .replaceAll('{sign}', sign);
      case PostType.question:
        return _questions[rng.nextInt(_questions.length)]
            .replaceAll('{sign}', sign);
      case PostType.insight:
        return _insights[rng.nextInt(_insights.length)]
            .replaceAll('{sign}', sign);
    }
  }

  static const _signs = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  static const _adjectives = [
    'Cosmic', 'Stellar', 'Lunar', 'Solar', 'Mystic',
    'Astral', 'Celestial', 'Starry', 'Nova', 'Nebula',
  ];

  static const _readings = [
    'Just pulled my daily reading as a {sign} \u2014 today is about trusting the process. The universe is aligning in our favor.',
    'Fellow {sign} here. Today\u0027s transit hit different. Saturn is teaching us patience and the rewards are coming.',
    'My {sign} reading for this week: focus on communication. Mercury is amplifying our natural strengths right now.',
    '{sign} energy is STRONG today. I can feel the cosmic shift. Anyone else picking up on this vibration?',
    'Received an incredible reading about {sign} and career this month. Jupiter is opening doors we didn\u0027t even know existed.',
    'As a {sign}, I\u0027m feeling the Venus transit deeply. Love energy is shifting in the most beautiful way.',
  ];

  static const _questions = [
    'Any other {sign} feeling the Mercury retrograde energy already? How are you preparing?',
    '{sign} + Scorpio compatibility \u2014 anyone have experience with this pairing? I need real talk, not just sun sign stuff.',
    'When did you discover you were a {sign}? Did it change how you saw yourself?',
    'What crystal do you recommend for {sign} energy during this transit season?',
    'Fellow {sign} people \u2014 what\u0027s your rising sign? I\u0027m curious about the combinations in this community.',
    'Is anyone else\u0027s {sign} moon sign causing emotional overwhelm this week? Looking for coping strategies.',
  ];

  static const _insights = [
    'Hot take: {sign} is the most misunderstood sign. We\u0027re not what the memes say \u2014 there\u0027s so much depth beneath the surface.',
    'Something I\u0027ve learned as a {sign}: our biggest strength is also our biggest challenge. The key is balance.',
    'The {sign} archetype teaches us about the cycle of growth. Every challenge is preparation for the next level.',
    'Unpopular opinion: {sign} season is actually the most transformative time of the zodiac year for everyone.',
    'After years of studying astrology, I realize {sign} placements are about evolution, not personality boxes.',
    'Pro tip for {sign}: journal during the full moon. Our sign processes emotions through reflection, not reaction.',
  ];
}
