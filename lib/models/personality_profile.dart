import 'birth_chart.dart';
import 'planet_position.dart';

class PlanetaryInfluence {
  final CelestialBody planet;
  final String sign;
  final int house;
  final String interpretation;

  const PlanetaryInfluence({
    required this.planet,
    required this.sign,
    required this.house,
    required this.interpretation,
  });
}

class PersonalityProfile {
  final BirthChart chart;
  final String sunSignAnalysis;
  final String moonSignAnalysis;
  final String risingSignAnalysis;
  final List<PlanetaryInfluence> planetaryInfluences;
  final String overallSummary;
  final List<String> strengths;
  final List<String> challenges;
  final String loveStyle;
  final String careerAptitude;
  final Map<String, double> elementBalance;

  const PersonalityProfile({
    required this.chart,
    required this.sunSignAnalysis,
    required this.moonSignAnalysis,
    required this.risingSignAnalysis,
    required this.planetaryInfluences,
    required this.overallSummary,
    required this.strengths,
    required this.challenges,
    required this.loveStyle,
    required this.careerAptitude,
    required this.elementBalance,
  });
}
