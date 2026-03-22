import 'package:flutter/material.dart';

class ZodiacSign {
  final String name;
  final String symbol;
  final String dateRange;
  final String element;
  final String rulingPlanet;
  final String traits;
  final String description;
  final Color color;
  final IconData icon;

  const ZodiacSign({
    required this.name,
    required this.symbol,
    required this.dateRange,
    required this.element,
    required this.rulingPlanet,
    required this.traits,
    required this.description,
    required this.color,
    required this.icon,
  });

  static const List<ZodiacSign> all = [
    ZodiacSign(
      name: 'Aries',
      symbol: '\u2648',
      dateRange: 'Mar 21 - Apr 19',
      element: 'Fire',
      rulingPlanet: 'Mars',
      traits: 'Courageous, Energetic, Confident',
      description:
          'Aries is the first sign of the zodiac. Bold and ambitious, Aries dives headfirst into even the most challenging situations.',
      color: Color(0xFFE53935),
      icon: Icons.local_fire_department,
    ),
    ZodiacSign(
      name: 'Taurus',
      symbol: '\u2649',
      dateRange: 'Apr 20 - May 20',
      element: 'Earth',
      rulingPlanet: 'Venus',
      traits: 'Reliable, Patient, Devoted',
      description:
          'Taurus is an earth sign represented by the bull. They enjoy relaxing in serene environments surrounded by soft sounds and soothing aromas.',
      color: Color(0xFF43A047),
      icon: Icons.landscape,
    ),
    ZodiacSign(
      name: 'Gemini',
      symbol: '\u264A',
      dateRange: 'May 21 - Jun 20',
      element: 'Air',
      rulingPlanet: 'Mercury',
      traits: 'Adaptable, Curious, Witty',
      description:
          'Gemini is spontaneous and playful with an insatiable curiosity. The celestial twins represent dual nature and versatility.',
      color: Color(0xFFFDD835),
      icon: Icons.air,
    ),
    ZodiacSign(
      name: 'Cancer',
      symbol: '\u264B',
      dateRange: 'Jun 21 - Jul 22',
      element: 'Water',
      rulingPlanet: 'Moon',
      traits: 'Intuitive, Emotional, Protective',
      description:
          'Cancer is a cardinal water sign. Cancers are deeply intuitive and sentimental, highly protective of those they love.',
      color: Color(0xFF90CAF9),
      icon: Icons.water_drop,
    ),
    ZodiacSign(
      name: 'Leo',
      symbol: '\u264C',
      dateRange: 'Jul 23 - Aug 22',
      element: 'Fire',
      rulingPlanet: 'Sun',
      traits: 'Creative, Passionate, Generous',
      description:
          'Leo is represented by the lion. These vivacious fire signs are the kings and queens of the celestial jungle.',
      color: Color(0xFFFF8F00),
      icon: Icons.wb_sunny,
    ),
    ZodiacSign(
      name: 'Virgo',
      symbol: '\u264D',
      dateRange: 'Aug 23 - Sep 22',
      element: 'Earth',
      rulingPlanet: 'Mercury',
      traits: 'Analytical, Practical, Diligent',
      description:
          'Virgo is an earth sign historically represented by the goddess of wheat. Virgos are logical and systematic in their approach to life.',
      color: Color(0xFF8D6E63),
      icon: Icons.eco,
    ),
    ZodiacSign(
      name: 'Libra',
      symbol: '\u264E',
      dateRange: 'Sep 23 - Oct 22',
      element: 'Air',
      rulingPlanet: 'Venus',
      traits: 'Diplomatic, Fair, Social',
      description:
          'Libra is an air sign represented by the scales. They are obsessed with symmetry and strive to create equilibrium in all areas of life.',
      color: Color(0xFFAB47BC),
      icon: Icons.balance,
    ),
    ZodiacSign(
      name: 'Scorpio',
      symbol: '\u264F',
      dateRange: 'Oct 23 - Nov 21',
      element: 'Water',
      rulingPlanet: 'Pluto',
      traits: 'Passionate, Resourceful, Brave',
      description:
          'Scorpio is a water sign that derives its strength from the psychic and emotional realm. Scorpios are known for their incredible passion and power.',
      color: Color(0xFFD32F2F),
      icon: Icons.whatshot,
    ),
    ZodiacSign(
      name: 'Sagittarius',
      symbol: '\u2650',
      dateRange: 'Nov 22 - Dec 21',
      element: 'Fire',
      rulingPlanet: 'Jupiter',
      traits: 'Adventurous, Optimistic, Honest',
      description:
          'Sagittarius is represented by the archer. Always on a quest for knowledge, they launch their many pursuits like blazing arrows.',
      color: Color(0xFF7E57C2),
      icon: Icons.explore,
    ),
    ZodiacSign(
      name: 'Capricorn',
      symbol: '\u2651',
      dateRange: 'Dec 22 - Jan 19',
      element: 'Earth',
      rulingPlanet: 'Saturn',
      traits: 'Disciplined, Ambitious, Practical',
      description:
          'Capricorn is the last earth sign. They are skilled at navigating both the material and emotional realms with steadfast determination.',
      color: Color(0xFF546E7A),
      icon: Icons.terrain,
    ),
    ZodiacSign(
      name: 'Aquarius',
      symbol: '\u2652',
      dateRange: 'Jan 20 - Feb 18',
      element: 'Air',
      rulingPlanet: 'Uranus',
      traits: 'Progressive, Independent, Humanitarian',
      description:
          'Aquarius is the most humanitarian sign. These revolutionary thinkers fervently support the power of the people.',
      color: Color(0xFF00ACC1),
      icon: Icons.waves,
    ),
    ZodiacSign(
      name: 'Pisces',
      symbol: '\u2653',
      dateRange: 'Feb 19 - Mar 20',
      element: 'Water',
      rulingPlanet: 'Neptune',
      traits: 'Compassionate, Intuitive, Artistic',
      description:
          'Pisces is the most intuitive and mystical sign. As the final sign, they have absorbed every lesson learned by all the other signs.',
      color: Color(0xFF26A69A),
      icon: Icons.auto_awesome,
    ),
  ];
}
