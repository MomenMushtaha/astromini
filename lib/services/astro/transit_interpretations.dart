class TransitInterpretations {
  TransitInterpretations._();

  /// Keyed by 'transitPlanet_natalPlanet_aspectType'
  /// Returns [title, description, significance]
  static List<String>? get(String key) => _data[key];

  static const _data = <String, List<String>>{
    // === Sun transits to natal Sun ===
    'sun_sun_Conjunction': [
      'Solar Return',
      'The Sun returns to your natal position — your personal new year.',
      'Set intentions for the year ahead. Vitality and self-expression peak.',
    ],
    'sun_sun_Opposition': [
      'Sun Opposition',
      'The Sun opposes your natal Sun — awareness through contrast.',
      'Relationships mirror what you need to integrate. Balance self and other.',
    ],
    'sun_sun_Square': [
      'Sun Square',
      'The Sun squares your natal Sun — a push to grow.',
      'Friction motivates action. Overcome inertia and take charge.',
    ],
    'sun_sun_Trine': [
      'Sun Trine',
      'The Sun trines your natal Sun — natural harmony and flow.',
      'Creativity and confidence flow easily. A good day to shine.',
    ],

    // === Sun transits to natal Moon ===
    'sun_moon_Conjunction': [
      'Sun-Moon Conjunction',
      'The Sun illuminates your emotional world.',
      'Feelings and identity align. Express your needs openly.',
    ],
    'sun_moon_Opposition': [
      'Sun-Moon Opposition',
      'The Sun opposes your natal Moon — head versus heart.',
      'Tension between rational goals and emotional needs. Seek balance.',
    ],
    'sun_moon_Square': [
      'Sun-Moon Square',
      'Inner conflict between willpower and feelings.',
      'Emotional friction demands attention. Don\'t suppress what you feel.',
    ],

    // === Moon transits to natal Sun ===
    'moon_sun_Conjunction': [
      'Lunar Spotlight',
      'The Moon joins your natal Sun — emotional clarity about identity.',
      'A brief but potent moment of alignment. Trust your gut instinct.',
    ],

    // === Mercury transits ===
    'mercury_sun_Conjunction': [
      'Mercury-Sun Alignment',
      'Mercury conjuncts your natal Sun — mental clarity peaks.',
      'Express ideas, sign contracts, have important conversations.',
    ],
    'mercury_moon_Conjunction': [
      'Mercury-Moon Connection',
      'Mercury meets your natal Moon — thoughts and feelings merge.',
      'Journal, share feelings, process emotions through conversation.',
    ],
    'mercury_mercury_Conjunction': [
      'Mercury Return',
      'Mercury returns to its natal position — mental refresh.',
      'Communication style resets. New ideas flow. Good for learning.',
    ],
    'mercury_mercury_Square': [
      'Mercury Square',
      'Mercury squares natal Mercury — mental friction.',
      'Miscommunication possible. Double-check messages and plans.',
    ],

    // === Venus transits ===
    'venus_sun_Conjunction': [
      'Venus Graces Your Sun',
      'Venus conjuncts your natal Sun — charm and attraction peak.',
      'Social magnetism is strong. Favorable for love, beauty, and creativity.',
    ],
    'venus_moon_Conjunction': [
      'Venus-Moon Harmony',
      'Venus meets your natal Moon — emotional warmth overflows.',
      'Nurture relationships. Indulge in comfort and beauty.',
    ],
    'venus_venus_Conjunction': [
      'Venus Return',
      'Venus returns to its natal position — love cycle renews.',
      'Reflect on your values and desires. A fresh start in love and money.',
    ],
    'venus_mars_Conjunction': [
      'Venus-Mars Spark',
      'Venus conjuncts your natal Mars — passion ignites.',
      'Strong romantic and creative energy. Act on desire.',
    ],
    'venus_mars_Opposition': [
      'Venus-Mars Tension',
      'Venus opposes your natal Mars — attraction meets friction.',
      'Magnetic pull in relationships, but watch for impulsive choices.',
    ],
    'venus_venus_Square': [
      'Venus Square',
      'Venus squares natal Venus — values under pressure.',
      'Spending impulses or relationship friction. Reassess what you value.',
    ],

    // === Mars transits ===
    'mars_sun_Conjunction': [
      'Mars Ignites Your Sun',
      'Mars conjuncts your natal Sun — energy and drive surge.',
      'Take bold action. Physical vitality peaks but watch for aggression.',
    ],
    'mars_sun_Square': [
      'Mars-Sun Clash',
      'Mars squares your natal Sun — frustration fuels action.',
      'Anger may surface. Channel it into productive effort, not conflict.',
    ],
    'mars_sun_Opposition': [
      'Mars Opposite Sun',
      'Mars opposes your natal Sun — confrontation with others.',
      'Others may challenge you. Assert boundaries without escalating.',
    ],
    'mars_moon_Conjunction': [
      'Mars-Moon Intensity',
      'Mars meets your natal Moon — emotions run hot.',
      'Passionate feelings surface. Channel intensity into physical activity.',
    ],
    'mars_moon_Square': [
      'Mars-Moon Friction',
      'Mars squares your natal Moon — emotional volatility.',
      'Short temper and sensitivity. Exercise to release tension.',
    ],
    'mars_mars_Conjunction': [
      'Mars Return',
      'Mars returns to its natal position — energy cycle resets.',
      'New assertiveness emerges. Initiate projects and pursue goals.',
    ],
    'mars_venus_Square': [
      'Mars-Venus Square',
      'Mars squares your natal Venus — desire meets resistance.',
      'Romantic tension or creative frustration. Don\'t force outcomes.',
    ],
    'mars_saturn_Square': [
      'Mars-Saturn Square',
      'Mars squares your natal Saturn — effort meets limitation.',
      'Frustration with authority or delays. Patience and discipline required.',
    ],
    'mars_saturn_Conjunction': [
      'Mars-Saturn Discipline',
      'Mars meets your natal Saturn — controlled, focused energy.',
      'Hard work pays off. Structure your ambition carefully.',
    ],

    // === Jupiter transits ===
    'jupiter_sun_Conjunction': [
      'Jupiter Blesses Your Sun',
      'Jupiter conjuncts your natal Sun — expansion and opportunity.',
      'A major growth period. Optimism is justified. Expand your horizons.',
    ],
    'jupiter_sun_Trine': [
      'Jupiter-Sun Trine',
      'Jupiter trines your natal Sun — luck and flow.',
      'Doors open effortlessly. Say yes to opportunities.',
    ],
    'jupiter_sun_Square': [
      'Jupiter-Sun Square',
      'Jupiter squares your natal Sun — overextension risk.',
      'Growth urge is strong but check for overconfidence or excess.',
    ],
    'jupiter_sun_Opposition': [
      'Jupiter Opposite Sun',
      'Jupiter opposes your natal Sun — external growth pressures.',
      'Others offer opportunity but may also inflate expectations.',
    ],
    'jupiter_moon_Conjunction': [
      'Jupiter-Moon Expansion',
      'Jupiter meets your natal Moon — emotional generosity.',
      'Feel-good period. Home, family, and emotional life flourish.',
    ],
    'jupiter_moon_Trine': [
      'Jupiter-Moon Flow',
      'Jupiter trines your natal Moon — emotional abundance.',
      'Contentment and gratitude come naturally. Nurture relationships.',
    ],

    // === Saturn transits ===
    'saturn_sun_Conjunction': [
      'Saturn Meets Your Sun',
      'Saturn conjuncts your natal Sun — a defining test of character.',
      'Major responsibility period. Build structures that will last.',
    ],
    'saturn_sun_Square': [
      'Saturn-Sun Square',
      'Saturn squares your natal Sun — pressure to grow up.',
      'Obstacles test your resolve. What you build now endures.',
    ],
    'saturn_sun_Opposition': [
      'Saturn Opposite Sun',
      'Saturn opposes your natal Sun — accountability from others.',
      'Relationships demand maturity. Meet obligations head-on.',
    ],
    'saturn_moon_Conjunction': [
      'Saturn-Moon Weight',
      'Saturn meets your natal Moon — emotional heaviness.',
      'Loneliness or duty weigh on feelings. Build emotional resilience.',
    ],
    'saturn_moon_Square': [
      'Saturn-Moon Pressure',
      'Saturn squares your natal Moon — emotional restrictions.',
      'Home or family stress. Set boundaries with compassion.',
    ],
    'saturn_saturn_Conjunction': [
      'Saturn Return',
      'Saturn returns to its natal position — a pivotal life passage.',
      'Major life restructuring. What doesn\'t serve you falls away.',
    ],
    'saturn_saturn_Square': [
      'Saturn Square Saturn',
      'Saturn squares natal Saturn — structural pressure.',
      'Career and life direction face a checkpoint. Adjust course.',
    ],
    'saturn_saturn_Opposition': [
      'Saturn Opposition',
      'Saturn opposes natal Saturn — harvest what you\'ve built.',
      'Midpoint review of life structures. Rebalance commitments.',
    ],

    // === Outer planet transits (slower, bigger impact) ===
    'jupiter_saturn_Conjunction': [
      'Jupiter-Saturn Conjunction',
      'Jupiter meets your natal Saturn — expansion meets structure.',
      'Disciplined growth. Build something lasting with optimism.',
    ],
    'jupiter_saturn_Trine': [
      'Jupiter-Saturn Trine',
      'Jupiter trines your natal Saturn — rewarded effort.',
      'Hard work meets opportunity. Steady, sustainable progress.',
    ],
    'saturn_jupiter_Conjunction': [
      'Saturn-Jupiter Meeting',
      'Saturn meets your natal Jupiter — testing your beliefs.',
      'Faith faces reality. Grounded wisdom emerges from the test.',
    ],
  };
}
