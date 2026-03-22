import '../../models/planet_position.dart';
import '../../models/transit_alert.dart';

class TransitData {
  TransitData._();

  static final List<TransitAlert> _transits = [
    TransitAlert(
      title: 'Mercury Retrograde',
      description: 'Mercury appears to move backward through the zodiac, affecting communication, technology, and travel plans.',
      planet: CelestialBody.mercury,
      startDate: DateTime(2026, 3, 15),
      endDate: DateTime(2026, 4, 7),
      type: TransitType.retrograde,
      significance: 'Review contracts, back up data, avoid major purchases. Double-check all communications.',
    ),
    TransitAlert(
      title: 'Venus enters Taurus',
      description: 'Venus moves into its home sign of Taurus, enhancing sensuality, financial stability, and appreciation for beauty.',
      planet: CelestialBody.venus,
      startDate: DateTime(2026, 4, 1),
      endDate: DateTime(2026, 4, 25),
      type: TransitType.ingress,
      significance: 'Favorable period for investments, romantic connections, and creative pursuits.',
    ),
    TransitAlert(
      title: 'Mars in Leo',
      description: 'Mars energizes Leo, boosting confidence, creativity, and the drive for recognition.',
      planet: CelestialBody.mars,
      startDate: DateTime(2026, 3, 10),
      endDate: DateTime(2026, 4, 22),
      type: TransitType.ingress,
      significance: 'Channel boldness into creative projects. Watch for ego conflicts.',
    ),
    TransitAlert(
      title: 'Jupiter-Saturn Sextile',
      description: 'Jupiter and Saturn form a harmonious sextile, blending expansion with discipline.',
      planet: CelestialBody.jupiter,
      startDate: DateTime(2026, 3, 20),
      endDate: DateTime(2026, 4, 15),
      type: TransitType.conjunction,
      significance: 'Excellent for long-term planning, business ventures, and structured growth.',
    ),
    TransitAlert(
      title: 'Neptune Retrograde',
      description: 'Neptune turns retrograde, turning spiritual focus inward and dissolving illusions.',
      planet: CelestialBody.neptune,
      startDate: DateTime(2026, 7, 4),
      endDate: DateTime(2026, 12, 10),
      type: TransitType.retrograde,
      significance: 'Dreams become more vivid. Reassess spiritual practices and creative visions.',
    ),
    TransitAlert(
      title: 'Saturn in Pisces',
      description: 'Saturn continues its journey through Pisces, bringing structure to spiritual and creative matters.',
      planet: CelestialBody.saturn,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2026, 5, 25),
      type: TransitType.ingress,
      significance: 'Discipline meets intuition. Solidify creative dreams into reality.',
    ),
    TransitAlert(
      title: 'Pluto in Aquarius',
      description: 'Pluto continues transforming Aquarius themes: technology, community, and collective evolution.',
      planet: CelestialBody.pluto,
      startDate: DateTime(2024, 11, 20),
      endDate: DateTime(2043, 3, 8),
      type: TransitType.ingress,
      significance: 'Generational shift toward decentralized power and technological transformation.',
    ),
  ];

  static List<TransitAlert> getActiveAndUpcoming() {
    return _transits
        .where((t) => t.isActive || t.isUpcoming)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  static List<TransitAlert> get allTransits => List.unmodifiable(_transits);
}
