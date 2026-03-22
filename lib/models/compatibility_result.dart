import 'aspect.dart';
import 'birth_chart.dart';
import 'planet_position.dart';

class SynastryAspect {
  final CelestialBody planet1;
  final CelestialBody planet2;
  final AspectType type;
  final double orb;
  final String interpretation;

  const SynastryAspect({
    required this.planet1,
    required this.planet2,
    required this.type,
    required this.orb,
    required this.interpretation,
  });
}

class CompatibilityResult {
  final BirthChart chart1;
  final BirthChart chart2;
  final double overallScore;
  final double emotionalScore;
  final double communicationScore;
  final double passionScore;
  final double growthScore;
  final List<SynastryAspect> synastryAspects;
  final String aiAnalysis;
  final List<String> strengths;
  final List<String> challenges;

  const CompatibilityResult({
    required this.chart1,
    required this.chart2,
    required this.overallScore,
    required this.emotionalScore,
    required this.communicationScore,
    required this.passionScore,
    required this.growthScore,
    required this.synastryAspects,
    required this.aiAnalysis,
    required this.strengths,
    required this.challenges,
  });
}
