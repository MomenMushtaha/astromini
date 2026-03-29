/// Natal aspect interpretations: meanings for planet-planet aspects in a birth chart.
/// Keyed by 'planet1_planet2_aspectType' (alphabetical planet order).
class NatalAspectInterpretations {
  NatalAspectInterpretations._();

  static List<String>? get(String key) => _data[key];

  // Returns [title, interpretation]
  static const _data = <String, List<String>>{
    // --- Sun aspects ---
    'sun_moon_conjunction': ['Sun-Moon Conjunction', 'Unified will and emotions. You are wholehearted and direct, with instincts that align with your conscious goals. New Moon birth — a fresh start energy.'],
    'sun_moon_opposition': ['Sun-Moon Opposition', 'Inner tension between who you are and what you need. Relationships serve as mirrors, and you may feel pulled between independence and emotional security.'],
    'sun_moon_trine': ['Sun-Moon Trine', 'Easy harmony between your ego and emotions. You feel comfortable in your own skin with a natural confidence that puts others at ease.'],
    'sun_moon_square': ['Sun-Moon Square', 'Dynamic friction between will and feelings. Your desires and emotional needs often conflict, creating restless ambition and deep motivation for growth.'],
    'sun_mercury_conjunction': ['Sun-Mercury Conjunction', 'Mind and identity are fused — you communicate with authority and think through the lens of your core self. Strong intellect but may struggle to see other perspectives.'],
    'sun_venus_conjunction': ['Sun-Venus Conjunction', 'Charm, grace, and aesthetic sensibility are woven into your identity. You attract beauty and harmony naturally and value peace in relationships.'],
    'sun_venus_sextile': ['Sun-Venus Sextile', 'Social grace and creative talent support your self-expression. You easily attract allies and find pleasure in artistic pursuits.'],
    'sun_mars_conjunction': ['Sun-Mars Conjunction', 'Powerful drive and assertiveness are central to your identity. You are a natural leader with courage and competitive fire.'],
    'sun_mars_opposition': ['Sun-Mars Opposition', 'Confrontation and competition define key relationships. You project your fighting spirit outward and attract strong-willed partners.'],
    'sun_mars_trine': ['Sun-Mars Trine', 'Confident, energetic, and decisive. Your will and action are naturally aligned, giving you the ability to pursue goals with sustained vigor.'],
    'sun_mars_square': ['Sun-Mars Square', 'Intense inner friction between ego and aggression. You are driven and combative, with a powerful need to prove yourself through action.'],
    'sun_jupiter_conjunction': ['Sun-Jupiter Conjunction', 'Expansive personality with natural optimism, generosity, and a philosophical bent. You aim high and often succeed through sheer confidence.'],
    'sun_jupiter_opposition': ['Sun-Jupiter Opposition', 'Grand ambitions that may outstrip practical reality. Others mirror your need for growth, and partnerships expand your worldview.'],
    'sun_jupiter_trine': ['Sun-Jupiter Trine', 'Luck, abundance, and good fortune seem to follow you. Broad-minded and generous, you inspire confidence in others.'],
    'sun_jupiter_square': ['Sun-Jupiter Square', 'Excess and overconfidence are temptations. Your faith in yourself is strong, but learning restraint and follow-through is the growth edge.'],
    'sun_saturn_conjunction': ['Sun-Saturn Conjunction', 'Serious, responsible, and mature beyond your years. You take on heavy burdens early in life but build enduring structures through discipline.'],
    'sun_saturn_opposition': ['Sun-Saturn Opposition', 'Authority figures and external limitations define your journey. Mastery comes through accepting responsibility rather than resisting it.'],
    'sun_saturn_trine': ['Sun-Saturn Trine', 'Disciplined ambition with the patience to build lasting achievements. Your sense of duty and practical wisdom earn deep respect over time.'],
    'sun_saturn_square': ['Sun-Saturn Square', 'Deep insecurity drives relentless effort. Obstacles and delays feel personal, but you develop extraordinary resilience and competence through struggle.'],
    'sun_uranus_conjunction': ['Sun-Uranus Conjunction', 'A radical individualist. Your identity is fused with originality, and you feel compelled to break free from convention.'],
    'sun_uranus_trine': ['Sun-Uranus Trine', 'Innovation and individuality come naturally. You embrace change with excitement and inspire others through your unique vision.'],
    'sun_uranus_square': ['Sun-Uranus Square', 'Restless rebellion against anything that constrains your freedom. Your life unfolds in sudden turns that force you to reinvent yourself.'],
    'sun_neptune_conjunction': ['Sun-Neptune Conjunction', 'Dreamy, intuitive, and deeply creative. Your identity dissolves into the collective, giving you artistic vision but sometimes confusion about who you are.'],
    'sun_neptune_trine': ['Sun-Neptune Trine', 'Imagination and compassion flow naturally into your self-expression. You have an effortless connection to the spiritual and creative dimensions.'],
    'sun_neptune_square': ['Sun-Neptune Square', 'Idealism and disillusionment cycle through your life. You must learn to distinguish vision from fantasy and find grounding for your dreams.'],
    'sun_pluto_conjunction': ['Sun-Pluto Conjunction', 'Magnetic intensity and transformative power define you. You undergo profound personal reinventions and wield significant psychological influence.'],
    'sun_pluto_trine': ['Sun-Pluto Trine', 'Deep personal power that manifests as quiet authority. You instinctively understand power dynamics and can transform situations from within.'],
    'sun_pluto_square': ['Sun-Pluto Square', 'Power struggles and control issues fuel profound transformation. You are forged by crisis and emerge stronger each time.'],

    // --- Moon aspects ---
    'moon_mercury_conjunction': ['Moon-Mercury Conjunction', 'Emotions and intellect are intertwined. You think about your feelings and feel about your thoughts — excellent for writing and counseling.'],
    'moon_mercury_trine': ['Moon-Mercury Trine', 'Emotional intelligence expressed through clear communication. You instinctively know how to make others feel heard and understood.'],
    'moon_mercury_square': ['Moon-Mercury Square', 'Inner conflict between head and heart. Your thoughts can be colored by emotional bias, but this tension drives powerful self-awareness.'],
    'moon_venus_conjunction': ['Moon-Venus Conjunction', 'Deeply affectionate and aesthetically attuned. Your emotional nature craves beauty, comfort, and loving connections.'],
    'moon_venus_trine': ['Moon-Venus Trine', 'Emotional grace and natural charm. You create warm, harmonious environments and attract love with effortless magnetism.'],
    'moon_venus_square': ['Moon-Venus Square', 'Tension between emotional needs and desires. You may overindulge or people-please, learning to balance self-care with giving.'],
    'moon_mars_conjunction': ['Moon-Mars Conjunction', 'Passionate emotions that demand action. You feel things intensely and respond with courage, though impulsiveness may need tempering.'],
    'moon_mars_opposition': ['Moon-Mars Opposition', 'Emotional conflicts play out in relationships. You attract intense dynamics that force you to balance assertion with vulnerability.'],
    'moon_mars_trine': ['Moon-Mars Trine', 'Emotional courage and protective instincts work in harmony. You act decisively on feelings and defend those you love fiercely.'],
    'moon_mars_square': ['Moon-Mars Square', 'Volatile emotions and quick temper. Inner anger or frustration needs physical outlets; this aspect drives tremendous emotional strength.'],
    'moon_jupiter_conjunction': ['Moon-Jupiter Conjunction', 'Expansive emotions and generous spirit. You feel things on a grand scale and your optimism is genuinely uplifting to others.'],
    'moon_jupiter_trine': ['Moon-Jupiter Trine', 'Emotional abundance and faith in life. You attract good fortune through your open heart and generous nature.'],
    'moon_jupiter_square': ['Moon-Jupiter Square', 'Emotional excess — feelings are magnified and can lead to overreaction or unrealistic expectations. Learning moderation is key.'],
    'moon_saturn_conjunction': ['Moon-Saturn Conjunction', 'Emotional restraint and early maturity. You may have felt emotionally unsupported early in life, developing deep resilience.'],
    'moon_saturn_opposition': ['Moon-Saturn Opposition', 'Emotional security is sought through external achievements. Duty and feelings often conflict until you learn to nurture yourself.'],
    'moon_saturn_trine': ['Moon-Saturn Trine', 'Emotional stability and practical wisdom. You handle feelings with maturity and provide steady support to those around you.'],
    'moon_saturn_square': ['Moon-Saturn Square', 'Deep emotional insecurity drives overcompensation. You build strong walls but must learn to let trusted people past them.'],
    'moon_uranus_conjunction': ['Moon-Uranus Conjunction', 'Emotionally unpredictable and craving freedom. Your feelings change rapidly and you need space to process them independently.'],
    'moon_uranus_trine': ['Moon-Uranus Trine', 'Emotional originality and intuitive flashes of insight. You embrace unconventional emotional expression and thrive on novelty.'],
    'moon_uranus_square': ['Moon-Uranus Square', 'Emotional disruptions and sudden changes in domestic life. You may struggle with commitment but crave authentic connections.'],
    'moon_neptune_conjunction': ['Moon-Neptune Conjunction', 'Psychically sensitive and deeply empathic. Your emotions are oceanic — boundless compassion mixed with vulnerability to absorption.'],
    'moon_neptune_trine': ['Moon-Neptune Trine', 'Gentle intuition and creative imagination. You sense others\' feelings effortlessly and channel emotions into art and healing.'],
    'moon_neptune_square': ['Moon-Neptune Square', 'Emotional confusion and idealization of others. You must develop discernment to avoid absorbing others\' pain as your own.'],
    'moon_pluto_conjunction': ['Moon-Pluto Conjunction', 'Emotional intensity at the extreme. You experience feelings as transformative forces and possess powerful psychological insight.'],
    'moon_pluto_trine': ['Moon-Pluto Trine', 'Emotional depth and regenerative power. You naturally transform emotional pain into wisdom and help others do the same.'],
    'moon_pluto_square': ['Moon-Pluto Square', 'Emotional power struggles and obsessive feelings. Profound transformation comes through confronting your deepest fears and attachments.'],

    // --- Venus-Mars aspects ---
    'venus_mars_conjunction': ['Venus-Mars Conjunction', 'Desire and attraction fused — you are magnetically passionate with a strong drive for creative and romantic fulfillment.'],
    'venus_mars_opposition': ['Venus-Mars Opposition', 'The eternal dance of desire and receptivity plays out in relationships. You attract through contrast and learn through partnership dynamics.'],
    'venus_mars_trine': ['Venus-Mars Trine', 'Harmonious blend of masculine and feminine energies. You pursue what you love with grace and attract partners who complement your nature.'],
    'venus_mars_square': ['Venus-Mars Square', 'Tension between what you want and what you desire. Romantic and creative friction that generates passionate but sometimes turbulent connections.'],
    'venus_mars_sextile': ['Venus-Mars Sextile', 'Cooperative attraction energies. You have a natural talent for balancing assertion with charm in love and creative endeavors.'],
    'venus_mars_quincunx': ['Venus-Mars Quincunx', 'An awkward adjustment between love and desire. Relationships require conscious effort to align what you want with what makes you happy.'],
    'venus_mars_semiSextile': ['Venus-Mars Semi-Sextile', 'Subtle tension between affection and action. You are learning to integrate gentleness with assertiveness, one small step at a time.'],

    // --- Jupiter-Saturn aspects ---
    'jupiter_saturn_conjunction': ['Jupiter-Saturn Conjunction', 'Expansion meets structure — a generational marker that combines vision with discipline. You build grand things within realistic frameworks.'],
    'jupiter_saturn_opposition': ['Jupiter-Saturn Opposition', 'Faith and doubt, optimism and caution in perpetual dialogue. Your life swings between expansion and contraction until you find the middle way.'],
    'jupiter_saturn_trine': ['Jupiter-Saturn Trine', 'Practical wisdom and measured optimism. You have an excellent sense of timing, knowing when to expand and when to consolidate.'],
    'jupiter_saturn_square': ['Jupiter-Saturn Square', 'Ambition thwarted by circumstances, or excessive caution limiting growth. The tension drives you to find the exact right balance of risk and prudence.'],

    // --- Mercury-outer planet aspects ---
    'mercury_jupiter_conjunction': ['Mercury-Jupiter Conjunction', 'A vast and philosophical mind. You think in big pictures and communicate with enthusiasm, though details may sometimes be overlooked.'],
    'mercury_jupiter_trine': ['Mercury-Jupiter Trine', 'Mental optimism and the gift of inspiring communication. Ideas flow easily and you naturally see the positive angle in any situation.'],
    'mercury_jupiter_square': ['Mercury-Jupiter Square', 'Mental overexpansion — you promise more than you can deliver and must learn to focus your abundant ideas into achievable goals.'],
    'mercury_saturn_conjunction': ['Mercury-Saturn Conjunction', 'A disciplined, careful mind. You think methodically and communicate with authority, though mental pessimism may need conscious management.'],
    'mercury_saturn_trine': ['Mercury-Saturn Trine', 'Structured thinking and patient learning. Your mind builds solid intellectual frameworks and your words carry weight.'],
    'mercury_saturn_square': ['Mercury-Saturn Square', 'Mental blocks and self-doubt that drive you to become exceptionally thorough and precise. Mastery comes through persistent study.'],
    'mercury_uranus_conjunction': ['Mercury-Uranus Conjunction', 'Lightning-fast mind with original ideas. You think in quantum leaps and may struggle with conventional education systems.'],
    'mercury_uranus_trine': ['Mercury-Uranus Trine', 'Inventive thinking that easily grasps new technologies and unconventional concepts. Your mind is ahead of its time.'],
    'mercury_uranus_square': ['Mercury-Uranus Square', 'Mentally restless and contrarian. Brilliant flashes of insight compete with scattered thinking — learning to focus is the growth edge.'],
    'mercury_neptune_conjunction': ['Mercury-Neptune Conjunction', 'A poetic, imaginative mind that thinks in symbols and images. You are naturally psychic but must guard against mental confusion.'],
    'mercury_neptune_trine': ['Mercury-Neptune Trine', 'Creative and intuitive thinking. Your mind naturally translates feelings into words and concepts, excelling in art and counseling.'],
    'mercury_neptune_square': ['Mercury-Neptune Square', 'Confusion between fact and fantasy. Your imagination is powerful but needs grounding in reality to produce clear communication.'],
    'mercury_pluto_conjunction': ['Mercury-Pluto Conjunction', 'A penetrating mind that sees beneath the surface. You are a natural researcher and detective, drawn to hidden truths.'],
    'mercury_pluto_trine': ['Mercury-Pluto Trine', 'Deep analytical ability and persuasive communication. You understand power dynamics instinctively and speak with transformative impact.'],
    'mercury_pluto_square': ['Mercury-Pluto Square', 'Obsessive thinking and the compulsion to uncover secrets. Your mental intensity can be overwhelming but drives profound insight.'],

    // --- Saturn-outer planet aspects ---
    'saturn_uranus_conjunction': ['Saturn-Uranus Conjunction', 'A generational aspect combining tradition with revolution. You build new structures by reinventing old ones.'],
    'saturn_uranus_trine': ['Saturn-Uranus Trine', 'Innovation within structure. You have the rare ability to implement revolutionary ideas in practical, lasting ways.'],
    'saturn_uranus_square': ['Saturn-Uranus Square', 'Tension between freedom and responsibility. Your generation faces the challenge of reforming institutions without destroying stability.'],
    'saturn_neptune_conjunction': ['Saturn-Neptune Conjunction', 'Dreams crystallized into reality. You give form to visions and bring spiritual ideals into material expression.'],
    'saturn_neptune_trine': ['Saturn-Neptune Trine', 'Practical idealism. You naturally bridge the gap between what is and what could be, building real-world structures for spiritual goals.'],
    'saturn_neptune_square': ['Saturn-Neptune Square', 'Disillusionment and the collapse of false structures. Your generation must distinguish between authentic ideals and convenient fantasies.'],
    'saturn_pluto_conjunction': ['Saturn-Pluto Conjunction', 'A generation marked by intense restructuring of power. You understand that real authority requires willingness to face destruction and rebuild.'],
    'saturn_pluto_trine': ['Saturn-Pluto Trine', 'Strategic power and the ability to endure transformative pressures. You build with an awareness of cycles of creation and destruction.'],
    'saturn_pluto_square': ['Saturn-Pluto Square', 'Power crises that force fundamental restructuring. Your generation confronts the dark side of authority and institutional corruption.'],
  };

  /// Lookup a natal aspect interpretation.
  /// Normalizes planet order alphabetically by name.
  static List<String>? lookup(String planet1, String planet2, String aspectType) {
    // Ensure alphabetical order for consistent key lookup
    final sorted = [planet1, planet2]..sort();
    final key = '${sorted[0]}_${sorted[1]}_$aspectType';
    return _data[key];
  }
}
