class MoonPhaseCalculator {
  MoonPhaseCalculator._();

  /// Calculate moon phase from Sun and Moon ecliptic longitudes.
  /// Returns one of 8 phase names.
  static String calculatePhase(double sunLon, double moonLon) {
    var elongation = (moonLon - sunLon) % 360.0;
    if (elongation < 0) elongation += 360.0;

    if (elongation < 22.5) return 'New Moon';
    if (elongation < 67.5) return 'Waxing Crescent';
    if (elongation < 112.5) return 'First Quarter';
    if (elongation < 157.5) return 'Waxing Gibbous';
    if (elongation < 202.5) return 'Full Moon';
    if (elongation < 247.5) return 'Waning Gibbous';
    if (elongation < 292.5) return 'Third Quarter';
    if (elongation < 337.5) return 'Waning Crescent';
    return 'New Moon';
  }

  static String phaseEmoji(String phase) {
    switch (phase) {
      case 'New Moon': return '\u{1F311}';
      case 'Waxing Crescent': return '\u{1F312}';
      case 'First Quarter': return '\u{1F313}';
      case 'Waxing Gibbous': return '\u{1F314}';
      case 'Full Moon': return '\u{1F315}';
      case 'Waning Gibbous': return '\u{1F316}';
      case 'Third Quarter': return '\u{1F317}';
      case 'Waning Crescent': return '\u{1F318}';
      default: return '\u{1F311}';
    }
  }

  static String phaseDescription(String phase) {
    switch (phase) {
      case 'New Moon':
        return 'A time for setting intentions and planting seeds. Energy is inward, reflective, and ripe for new beginnings.';
      case 'Waxing Crescent':
        return 'Momentum builds. Take the first steps toward your intentions. Courage and initiative are favored.';
      case 'First Quarter':
        return 'A turning point that demands action and decision. Challenges arise to test your commitment.';
      case 'Waxing Gibbous':
        return 'Refine and adjust your approach. Trust the process and make necessary course corrections.';
      case 'Full Moon':
        return 'Culmination and revelation. Emotions run high, truths surface, and results manifest. A time of harvest.';
      case 'Waning Gibbous':
        return 'Share wisdom and gratitude. Reflect on what you have achieved and give back to others.';
      case 'Third Quarter':
        return 'Release and let go. Clear away what no longer serves you to make space for the next cycle.';
      case 'Waning Crescent':
        return 'Rest, surrender, and heal. The cycle completes — honor endings before the next new beginning.';
      default:
        return 'The lunar cycle influences your emotional tides and inner rhythm.';
    }
  }
}
