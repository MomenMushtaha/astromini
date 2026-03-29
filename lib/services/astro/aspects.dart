import '../../models/aspect.dart';
import '../../models/planet_position.dart';

class AspectCalculator {
  AspectCalculator._();

  /// Planet-specific orb multipliers.
  /// Luminaries get wider orbs, outer planets get tighter orbs.
  static double _orbFactor(CelestialBody body) {
    switch (body) {
      case CelestialBody.sun:
      case CelestialBody.moon:
        return 1.25;
      case CelestialBody.mercury:
      case CelestialBody.venus:
      case CelestialBody.mars:
        return 1.0;
      case CelestialBody.jupiter:
      case CelestialBody.saturn:
        return 0.85;
      case CelestialBody.uranus:
      case CelestialBody.neptune:
      case CelestialBody.pluto:
        return 0.7;
      case CelestialBody.northNode:
      case CelestialBody.southNode:
        return 0.6;
      case CelestialBody.chiron:
        return 0.7;
      case CelestialBody.lilith:
        return 0.5;
    }
  }

  /// Effective orb for a pair of planets and aspect type.
  static double effectiveOrb(
      CelestialBody p1, CelestialBody p2, AspectType type) {
    return type.maxOrb * (_orbFactor(p1) + _orbFactor(p2)) / 2.0;
  }

  static List<Aspect> calculateAspects(
      Map<CelestialBody, PlanetPosition> planets,
      {Map<CelestialBody, double>? dailyMotions}) {
    final aspects = <Aspect>[];
    final bodies = planets.keys.toList();

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final p1 = planets[bodies[i]]!;
        final p2 = planets[bodies[j]]!;
        final separation = _angularSeparation(
          p1.eclipticLongitude,
          p2.eclipticLongitude,
        );

        for (final type in AspectType.values) {
          final orb = (separation - type.angle).abs();
          if (orb <= effectiveOrb(bodies[i], bodies[j], type)) {
            // Determine applying vs separating
            bool? isApplying;
            if (dailyMotions != null) {
              final speed1 = dailyMotions[bodies[i]];
              final speed2 = dailyMotions[bodies[j]];
              if (speed1 != null && speed2 != null) {
                final futureLon1 = p1.eclipticLongitude + speed1;
                final futureLon2 = p2.eclipticLongitude + speed2;
                final futureSep = _angularSeparation(futureLon1, futureLon2);
                final futureOrb = (futureSep - type.angle).abs();
                isApplying = futureOrb < orb;
              }
            }

            aspects.add(Aspect(
              planet1: bodies[i],
              planet2: bodies[j],
              type: type,
              exactAngle: separation,
              orb: orb,
              isApplying: isApplying,
            ));
            break;
          }
        }
      }
    }

    aspects.sort((a, b) => a.orb.compareTo(b.orb));
    return aspects;
  }

  static double _angularSeparation(double lon1, double lon2) {
    var diff = (lon1 - lon2).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }
}
