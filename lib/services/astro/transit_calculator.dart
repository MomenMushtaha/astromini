import '../../models/aspect.dart';
import '../../models/planet_position.dart';
import '../../models/transit_alert.dart';
import 'transit_interpretations.dart';

class TransitCalculator {
  TransitCalculator._();

  /// Transit orbs are tighter than natal orbs.
  static const _transitOrbs = <AspectType, double>{
    AspectType.conjunction: 8.0,
    AspectType.opposition: 7.0,
    AspectType.trine: 6.0,
    AspectType.square: 6.0,
    AspectType.sextile: 4.0,
    AspectType.quincunx: 2.0,
    AspectType.semiSextile: 1.5,
  };

  /// Transiting planets to check (skip nodes for transits).
  static const _transitingBodies = [
    CelestialBody.sun,
    CelestialBody.moon,
    CelestialBody.mercury,
    CelestialBody.venus,
    CelestialBody.mars,
    CelestialBody.jupiter,
    CelestialBody.saturn,
  ];

  /// Natal points to check against.
  static const _natalTargets = [
    CelestialBody.sun,
    CelestialBody.moon,
    CelestialBody.mercury,
    CelestialBody.venus,
    CelestialBody.mars,
    CelestialBody.jupiter,
    CelestialBody.saturn,
  ];

  /// Major aspect types to check for transits.
  static const _transitAspects = [
    AspectType.conjunction,
    AspectType.opposition,
    AspectType.trine,
    AspectType.square,
    AspectType.sextile,
    AspectType.quincunx,
  ];

  /// Calculate personalized transit alerts based on current sky vs natal chart.
  static List<TransitAlert> calculateTransits(
    Map<CelestialBody, PlanetPosition> currentPositions, {
    Map<CelestialBody, PlanetPosition>? natalPositions,
  }) {
    final alerts = <TransitAlert>[];
    final now = DateTime.now();

    // Retrograde alerts
    for (final entry in currentPositions.entries) {
      if (entry.value.isRetrograde &&
          entry.key != CelestialBody.northNode &&
          entry.key != CelestialBody.southNode) {
        alerts.add(TransitAlert(
          title: '${entry.key.displayName} Retrograde',
          description:
              '${entry.key.displayName} is currently retrograde in ${entry.value.zodiacPosition.sign}.',
          planet: entry.key,
          startDate: now.subtract(const Duration(days: 7)),
          endDate: now.add(const Duration(days: 14)),
          type: TransitType.retrograde,
          significance: _retrogradeSignificance(entry.key),
        ));
      }
    }

    // Transit aspects to natal chart
    if (natalPositions != null) {
      for (final transit in _transitingBodies) {
        final tPos = currentPositions[transit];
        if (tPos == null) continue;

        for (final natal in _natalTargets) {
          final nPos = natalPositions[natal];
          if (nPos == null) continue;

          final separation = _angularSeparation(
            tPos.eclipticLongitude,
            nPos.eclipticLongitude,
          );

          for (final aspectType in _transitAspects) {
            final orb = (separation - aspectType.angle).abs();
            final maxOrb = _transitOrbs[aspectType] ?? aspectType.maxOrb;

            if (orb <= maxOrb) {
              final key =
                  '${transit.name}_${natal.name}_${aspectType.displayName}';
              final interp = TransitInterpretations.get(key);

              final title = interp?[0] ??
                  'Transiting ${transit.displayName} ${aspectType.displayName} natal ${natal.displayName}';
              final description = interp?[1] ??
                  '${transit.displayName} forms a ${aspectType.displayName.toLowerCase()} to your natal ${natal.displayName} at ${orb.toStringAsFixed(1)}\u00B0 orb.';
              final significance = interp?[2] ??
                  _genericSignificance(transit, natal, aspectType);

              // Approximate transit window based on planet speed
              final window = _transitWindow(transit);

              alerts.add(TransitAlert(
                title: title,
                description: description,
                planet: transit,
                startDate: now.subtract(Duration(days: window)),
                endDate: now.add(Duration(days: window)),
                type: TransitType.aspect,
                significance: significance,
              ));
              break; // Only one aspect per transit-natal pair
            }
          }
        }
      }
    }

    return alerts;
  }

  /// Generate sign-based transits for users without a birth chart.
  static List<TransitAlert> calculateGenericTransits(
    Map<CelestialBody, PlanetPosition> currentPositions,
    String signName,
  ) {
    final alerts = <TransitAlert>[];
    final now = DateTime.now();

    // Check which transiting planets are in this sign
    for (final entry in currentPositions.entries) {
      if (entry.value.zodiacPosition.sign == signName &&
          entry.key != CelestialBody.northNode &&
          entry.key != CelestialBody.southNode) {
        alerts.add(TransitAlert(
          title: '${entry.key.displayName} in $signName',
          description:
              '${entry.key.displayName} is currently transiting through $signName at ${entry.value.zodiacPosition.formatted}.',
          planet: entry.key,
          startDate: now.subtract(Duration(days: _transitWindow(entry.key))),
          endDate: now.add(Duration(days: _transitWindow(entry.key))),
          type: TransitType.ingress,
          significance: _signTransitSignificance(entry.key, signName),
        ));
      }
    }

    // Check for retrograde planets
    for (final entry in currentPositions.entries) {
      if (entry.value.isRetrograde &&
          entry.key != CelestialBody.northNode &&
          entry.key != CelestialBody.southNode) {
        alerts.add(TransitAlert(
          title: '${entry.key.displayName} Retrograde',
          description:
              '${entry.key.displayName} is retrograde in ${entry.value.zodiacPosition.sign}.',
          planet: entry.key,
          startDate: now.subtract(const Duration(days: 7)),
          endDate: now.add(const Duration(days: 14)),
          type: TransitType.retrograde,
          significance: _retrogradeSignificance(entry.key),
        ));
      }
    }

    return alerts;
  }

  static double _angularSeparation(double lon1, double lon2) {
    var diff = (lon1 - lon2).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  /// Approximate transit window in days based on planet speed.
  static int _transitWindow(CelestialBody body) {
    switch (body) {
      case CelestialBody.moon:
        return 1;
      case CelestialBody.sun:
      case CelestialBody.mercury:
      case CelestialBody.venus:
        return 3;
      case CelestialBody.mars:
        return 5;
      case CelestialBody.jupiter:
        return 14;
      case CelestialBody.saturn:
        return 21;
      default:
        return 30;
    }
  }

  static String _retrogradeSignificance(CelestialBody body) {
    switch (body) {
      case CelestialBody.mercury:
        return 'Review communications, avoid signing contracts, back up data. Revisit old ideas.';
      case CelestialBody.venus:
        return 'Reassess relationships and values. Old loves may resurface. Avoid major purchases.';
      case CelestialBody.mars:
        return 'Energy turns inward. Avoid new conflicts. Revisit unfinished projects.';
      case CelestialBody.jupiter:
        return 'Re-examine beliefs and growth plans. Inner expansion over outer achievement.';
      case CelestialBody.saturn:
        return 'Review structures, responsibilities, and commitments. Rebuild from within.';
      case CelestialBody.uranus:
        return 'Internal revolution. Process changes before acting on them.';
      case CelestialBody.neptune:
        return 'Dreams turn inward. Heightened intuition but watch for confusion.';
      case CelestialBody.pluto:
        return 'Deep psychological processing. Transformation happens beneath the surface.';
      default:
        return 'Retrograde energy encourages review and reflection.';
    }
  }

  static String _genericSignificance(
    CelestialBody transit,
    CelestialBody natal,
    AspectType type,
  ) {
    final harmony = type.isHarmonious ? 'harmonious' : 'challenging';
    return 'A $harmony transit activating your ${natal.displayName} energy. '
        'Pay attention to themes related to ${_planetTheme(natal)}.';
  }

  static String _signTransitSignificance(CelestialBody body, String sign) {
    return '${body.displayName} energizes $sign themes in your life. '
        'Focus on ${_planetTheme(body)} during this transit.';
  }

  static String _planetTheme(CelestialBody body) {
    switch (body) {
      case CelestialBody.sun:
        return 'identity, vitality, and self-expression';
      case CelestialBody.moon:
        return 'emotions, instincts, and inner needs';
      case CelestialBody.mercury:
        return 'communication, thinking, and learning';
      case CelestialBody.venus:
        return 'love, beauty, and values';
      case CelestialBody.mars:
        return 'action, desire, and assertion';
      case CelestialBody.jupiter:
        return 'growth, wisdom, and opportunity';
      case CelestialBody.saturn:
        return 'discipline, responsibility, and structure';
      case CelestialBody.uranus:
        return 'change, innovation, and liberation';
      case CelestialBody.neptune:
        return 'imagination, spirituality, and transcendence';
      case CelestialBody.pluto:
        return 'transformation, power, and rebirth';
      default:
        return 'karmic themes and life direction';
    }
  }
}
