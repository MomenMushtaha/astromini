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

    // === Uranus transits ===
    'uranus_sun_Conjunction': ['Uranus Conjunct Sun', 'A once-in-84-years revolution in identity. Sudden awakenings force you to reinvent yourself completely.', 'Life-altering; embrace radical authenticity.'],
    'uranus_sun_Opposition': ['Uranus Opposite Sun', 'Others bring unexpected upheaval. Relationships or external events shatter comfortable routines.', 'Major; midlife awakening energy.'],
    'uranus_sun_Square': ['Uranus Square Sun', 'Restless friction demands change. You feel trapped by your current identity and must break free.', 'Significant; quarter-life or three-quarter-life crisis.'],
    'uranus_sun_Trine': ['Uranus Trine Sun', 'Exciting innovations align with your core self. Change feels liberating rather than disruptive.', 'Positive; fresh energy and opportunities.'],
    'uranus_moon_Conjunction': ['Uranus Conjunct Moon', 'Emotional earthquakes. Your inner world is disrupted, forcing emotional liberation and new domestic patterns.', 'Life-altering; emotional revolution.'],
    'uranus_moon_Opposition': ['Uranus Opposite Moon', 'Others trigger emotional upheaval. Relationships and family dynamics undergo sudden shifts.', 'Major; emotional freedom vs security.'],
    'uranus_moon_Square': ['Uranus Square Moon', 'Inner restlessness and mood swings. You crave emotional freedom but fear the instability it brings.', 'Significant; domestic disruptions.'],
    'uranus_moon_Trine': ['Uranus Trine Moon', 'Exciting emotional breakthroughs. New insights about your needs come as pleasant surprises.', 'Positive; emotional liberation.'],
    'uranus_venus_Conjunction': ['Uranus Conjunct Venus', 'Love life electrified. Sudden attractions, unconventional relationships, or creative breakthroughs.', 'Major; romantic revolution.'],
    'uranus_venus_Opposition': ['Uranus Opposite Venus', 'Partners bring unexpected change to your value system. Relationships may begin or end suddenly.', 'Major; values redefined.'],
    'uranus_venus_Square': ['Uranus Square Venus', 'Restless desire for excitement in love. Financial or relational instability demands flexibility.', 'Significant; creative tension.'],
    'uranus_mars_Conjunction': ['Uranus Conjunct Mars', 'Explosive energy and the drive for radical action. Sudden courage to break free from constraints.', 'Major; impulsive but liberating.'],
    'uranus_mars_Square': ['Uranus Square Mars', 'Volatile energy that demands an outlet. Accident-prone if suppressed; revolutionary if channeled.', 'Significant; manage impulsiveness.'],
    'uranus_saturn_Conjunction': ['Uranus Conjunct Saturn', 'Structures crumble to make way for innovation. Old systems cannot withstand the pressure for change.', 'Life-altering; institutional revolution.'],
    'uranus_saturn_Opposition': ['Uranus Opposite Saturn', 'Freedom versus duty reaches a breaking point. What you\'ve built is tested by forces demanding evolution.', 'Major; structural transformation.'],
    'uranus_saturn_Square': ['Uranus Square Saturn', 'Tension between stability and change creates frustration. Something must give — and usually it\'s the status quo.', 'Significant; systemic tension.'],

    // === Neptune transits ===
    'neptune_sun_Conjunction': ['Neptune Conjunct Sun', 'Identity dissolves and reforms over years. You may feel lost before discovering a more spiritual or creative self.', 'Life-altering; spiritual awakening.'],
    'neptune_sun_Opposition': ['Neptune Opposite Sun', 'Others seem enchanting or deceptive. Confusion about identity comes through relationships and projections.', 'Major; discernment needed.'],
    'neptune_sun_Square': ['Neptune Square Sun', 'Disillusionment with who you thought you were. Dreams and reality collide, demanding you release false identities.', 'Significant; ego dissolution.'],
    'neptune_sun_Trine': ['Neptune Trine Sun', 'Creative and spiritual inspiration flows easily. Your imagination enhances your identity in beautiful ways.', 'Positive; inspired living.'],
    'neptune_moon_Conjunction': ['Neptune Conjunct Moon', 'Emotional boundaries dissolve. Deep compassion and psychic sensitivity emerge, but vulnerability to deception increases.', 'Life-altering; emotional awakening.'],
    'neptune_moon_Opposition': ['Neptune Opposite Moon', 'Others trigger emotional confusion or idealization. You must learn where your feelings end and theirs begin.', 'Major; boundary lessons.'],
    'neptune_moon_Square': ['Neptune Square Moon', 'Emotional fog and confusion. Past wounds surface for healing, but clarity is elusive. Trust intuition over logic.', 'Significant; inner work required.'],
    'neptune_moon_Trine': ['Neptune Trine Moon', 'Gentle expansion of emotional awareness. Compassion, creativity, and spiritual connection deepen naturally.', 'Positive; emotional enrichment.'],
    'neptune_venus_Conjunction': ['Neptune Conjunct Venus', 'Romance becomes transcendent or illusory. Art and beauty take on spiritual dimensions. Beware idealization.', 'Major; divine love or deception.'],
    'neptune_venus_Opposition': ['Neptune Opposite Venus', 'Partners may not be who they seem. Values are tested by glamour and fantasy. Seek clarity in love.', 'Major; romantic fog.'],
    'neptune_venus_Square': ['Neptune Square Venus', 'Unrealistic expectations in love and finances. Creative gifts emerge through learning to distinguish dreams from reality.', 'Significant; artistic growth through pain.'],
    'neptune_mars_Conjunction': ['Neptune Conjunct Mars', 'Action becomes inspired or confused. Spiritual warrior energy emerges, but motivation may feel directionless.', 'Major; channeled vs scattered energy.'],
    'neptune_mars_Square': ['Neptune Square Mars', 'Willpower undermined by confusion or escapism. Energy leaks require spiritual discipline to redirect.', 'Significant; willpower tested.'],
    'neptune_saturn_Conjunction': ['Neptune Conjunct Saturn', 'Structures dissolve. What seemed solid reveals its illusory nature. Spiritual rebuilding replaces material certainty.', 'Life-altering; faith vs fear.'],
    'neptune_saturn_Square': ['Neptune Square Saturn', 'Reality and dreams conflict painfully. Disillusionment with institutions or authority figures demands inner authority.', 'Significant; existential questioning.'],

    // === Pluto transits ===
    'pluto_sun_Conjunction': ['Pluto Conjunct Sun', 'The most powerful transit possible. Complete ego death and rebirth. You emerge as a fundamentally different person.', 'Life-altering; total transformation.'],
    'pluto_sun_Opposition': ['Pluto Opposite Sun', 'Power struggles with others force deep self-examination. Control issues surface for confrontation and resolution.', 'Major; power dynamics exposed.'],
    'pluto_sun_Square': ['Pluto Square Sun', 'Intense pressure to transform. External power struggles reflect inner patterns that must change. Resistance is futile.', 'Significant; forced evolution.'],
    'pluto_sun_Trine': ['Pluto Trine Sun', 'Deep empowerment flows naturally. You access personal power with ease and influence situations from a place of authenticity.', 'Positive; quiet authority.'],
    'pluto_moon_Conjunction': ['Pluto Conjunct Moon', 'Emotional transformation at the deepest level. Family patterns, childhood wounds, and emotional habits are purged and renewed.', 'Life-altering; emotional rebirth.'],
    'pluto_moon_Opposition': ['Pluto Opposite Moon', 'Intense emotional dynamics with others reveal your deepest patterns. Relationships become catalysts for psychological transformation.', 'Major; emotional power struggles.'],
    'pluto_moon_Square': ['Pluto Square Moon', 'Emotional crisis forces confrontation with unconscious patterns. Control and vulnerability themes demand resolution.', 'Significant; shadow work.'],
    'pluto_moon_Trine': ['Pluto Trine Moon', 'Deep emotional renewal and psychological insight come naturally. You process intense feelings with wisdom and emerge stronger.', 'Positive; emotional empowerment.'],
    'pluto_venus_Conjunction': ['Pluto Conjunct Venus', 'Love becomes transformative obsession. Relationships undergo death and rebirth. Values are fundamentally reshaped.', 'Life-altering; love as alchemy.'],
    'pluto_venus_Opposition': ['Pluto Opposite Venus', 'Partners bring intense transformation. Jealousy, desire, and power dynamics in love demand radical honesty.', 'Major; relationship crucible.'],
    'pluto_venus_Square': ['Pluto Square Venus', 'Obsessive desire and compulsive attachments surface for healing. Love demands confrontation with your shadow side.', 'Significant; desire vs integrity.'],
    'pluto_mars_Conjunction': ['Pluto Conjunct Mars', 'Will and power reach nuclear intensity. This energy can accomplish extraordinary feats or cause destruction. Channel consciously.', 'Major; raw power unleashed.'],
    'pluto_mars_Square': ['Pluto Square Mars', 'Rage, ambition, and power struggles reach a critical mass. Physical and psychological energy demands a constructive outlet.', 'Significant; directed intensity.'],
    'pluto_saturn_Conjunction': ['Pluto Conjunct Saturn', 'Structures of power are demolished and rebuilt from the foundation. Authority, career, and legacy undergo complete transformation.', 'Life-altering; institutional rebirth.'],
    'pluto_saturn_Opposition': ['Pluto Opposite Saturn', 'External power structures challenge your foundation. What you\'ve built is tested by forces demanding truth and accountability.', 'Major; structural crisis.'],
    'pluto_saturn_Square': ['Pluto Square Saturn', 'Grinding pressure between transformation and stability. The old guard resists the inevitable; something must break through.', 'Significant; power redistribution.'],
  };
}
