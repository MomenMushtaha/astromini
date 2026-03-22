import '../models/aspect.dart';
import '../models/birth_chart.dart';
import '../models/compatibility_result.dart';
import '../models/planet_position.dart';

class CompatibilityService {
  CompatibilityService._();

  static CompatibilityResult calculate(BirthChart chart1, BirthChart chart2) {
    final synastryAspects = _calculateSynastry(chart1, chart2);

    final emotionalScore = _categoryScore(synastryAspects,
        {CelestialBody.moon}, {CelestialBody.moon, CelestialBody.venus});
    final communicationScore = _categoryScore(synastryAspects,
        {CelestialBody.mercury}, {CelestialBody.mercury, CelestialBody.sun});
    final passionScore = _categoryScore(synastryAspects,
        {CelestialBody.mars, CelestialBody.venus},
        {CelestialBody.mars, CelestialBody.venus});
    final growthScore = _categoryScore(synastryAspects,
        {CelestialBody.jupiter, CelestialBody.saturn},
        {CelestialBody.sun, CelestialBody.jupiter});

    final overall =
        (emotionalScore * 0.3 + communicationScore * 0.2 +
            passionScore * 0.3 + growthScore * 0.2)
            .clamp(20.0, 98.0);

    final strengths = _identifyStrengths(synastryAspects);
    final challenges = _identifyChallenges(synastryAspects);

    final sun1 = chart1.planets[CelestialBody.sun]!.zodiacPosition.sign;
    final sun2 = chart2.planets[CelestialBody.sun]!.zodiacPosition.sign;
    final moon1 = chart1.planets[CelestialBody.moon]!.zodiacPosition.sign;
    final moon2 = chart2.planets[CelestialBody.moon]!.zodiacPosition.sign;

    final analysis = 'Synastry Analysis: $sun1 Sun with $sun2 Sun.\n\n'
        'The emotional connection between $moon1 Moon and $moon2 Moon '
        '${emotionalScore > 70 ? "shows strong natural resonance" : "requires conscious effort to harmonize"}. '
        'With ${synastryAspects.length} significant cross-chart aspects identified, '
        'this pairing has ${overall > 75 ? "excellent" : overall > 55 ? "good" : "challenging but growth-oriented"} '
        'compatibility potential.\n\n'
        '${strengths.isNotEmpty ? "Key strength: ${strengths.first}." : ""} '
        '${challenges.isNotEmpty ? "Primary growth area: ${challenges.first}." : ""}';

    return CompatibilityResult(
      chart1: chart1,
      chart2: chart2,
      overallScore: overall,
      emotionalScore: emotionalScore,
      communicationScore: communicationScore,
      passionScore: passionScore,
      growthScore: growthScore,
      synastryAspects: synastryAspects,
      aiAnalysis: analysis,
      strengths: strengths,
      challenges: challenges,
    );
  }

  static List<SynastryAspect> _calculateSynastry(
      BirthChart chart1, BirthChart chart2) {
    final aspects = <SynastryAspect>[];

    for (final p1 in chart1.planets.entries) {
      for (final p2 in chart2.planets.entries) {
        final sep = _angularSeparation(
            p1.value.eclipticLongitude, p2.value.eclipticLongitude);

        for (final type in AspectType.values) {
          final orb = (sep - type.angle).abs();
          if (orb <= type.maxOrb) {
            aspects.add(SynastryAspect(
              planet1: p1.key,
              planet2: p2.key,
              type: type,
              orb: orb,
              interpretation: _synastryInterp(p1.key, p2.key, type),
            ));
            break;
          }
        }
      }
    }

    aspects.sort((a, b) => a.orb.compareTo(b.orb));
    return aspects;
  }

  static double _categoryScore(
      List<SynastryAspect> aspects,
      Set<CelestialBody> from,
      Set<CelestialBody> to) {
    double score = 55.0; // baseline
    for (final a in aspects) {
      if (from.contains(a.planet1) && to.contains(a.planet2) ||
          from.contains(a.planet2) && to.contains(a.planet1)) {
        final weight = 1.0 - (a.orb / a.type.maxOrb);
        if (a.type.isHarmonious) {
          score += 12 * weight;
        } else {
          score -= 6 * weight;
        }
      }
    }
    return score.clamp(15.0, 98.0);
  }

  static List<String> _identifyStrengths(List<SynastryAspect> aspects) {
    final strengths = <String>[];
    for (final a in aspects.where((a) => a.type.isHarmonious).take(3)) {
      strengths.add(
          '${a.planet1.displayName}-${a.planet2.displayName} ${a.type.displayName}: ${a.interpretation}');
    }
    return strengths;
  }

  static List<String> _identifyChallenges(List<SynastryAspect> aspects) {
    final challenges = <String>[];
    for (final a in aspects.where((a) => !a.type.isHarmonious).take(3)) {
      challenges.add(
          '${a.planet1.displayName}-${a.planet2.displayName} ${a.type.displayName}: ${a.interpretation}');
    }
    return challenges;
  }

  static String _synastryInterp(
      CelestialBody p1, CelestialBody p2, AspectType type) {
    if (type.isHarmonious) {
      return 'Harmonious flow between ${p1.displayName} and ${p2.displayName} energy';
    }
    return 'Dynamic tension between ${p1.displayName} and ${p2.displayName} requiring growth';
  }

  static double _angularSeparation(double lon1, double lon2) {
    var diff = (lon1 - lon2).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }
}
