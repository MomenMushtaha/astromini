import '../../models/aspect.dart';
import '../../models/planet_position.dart';

class AspectCalculator {
  AspectCalculator._();

  static List<Aspect> calculateAspects(
      Map<CelestialBody, PlanetPosition> planets) {
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
          if (orb <= type.maxOrb) {
            aspects.add(Aspect(
              planet1: bodies[i],
              planet2: bodies[j],
              type: type,
              exactAngle: separation,
              orb: orb,
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
