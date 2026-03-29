import 'planet_position.dart';
import 'aspect_pattern.dart';

enum Sect { day, night }

class MutualReception {
  final CelestialBody planet1;
  final CelestialBody planet2;
  final String sign1;
  final String sign2;

  const MutualReception({
    required this.planet1,
    required this.planet2,
    required this.sign1,
    required this.sign2,
  });
}

class FixedStarConjunction {
  final String starName;
  final CelestialBody planet;
  final double orb;
  final String interpretation;

  const FixedStarConjunction({
    required this.starName,
    required this.planet,
    required this.orb,
    required this.interpretation,
  });
}

enum ChartShapeType {
  bundle('Bundle'),
  bowl('Bowl'),
  bucket('Bucket'),
  locomotive('Locomotive'),
  seesaw('See-Saw'),
  splash('Splash'),
  splay('Splay');

  final String displayName;
  const ChartShapeType(this.displayName);
}

class ChartShape {
  final ChartShapeType type;
  final CelestialBody? handle;
  final CelestialBody? leading;
  final String description;

  const ChartShape({
    required this.type,
    this.handle,
    this.leading,
    required this.description,
  });
}

class ChartAnalysisResult {
  final CelestialBody chartRuler;
  final Sect sect;
  final PlanetPosition? partOfFortune;
  final PlanetPosition? vertex;
  final List<MutualReception> mutualReceptions;
  final List<AspectPattern> aspectPatterns;
  final Map<String, int> hemisphereBalance;
  final ChartShape chartShape;
  final List<FixedStarConjunction> fixedStarConjunctions;
  final bool isVoidOfCourseMoon;

  const ChartAnalysisResult({
    required this.chartRuler,
    required this.sect,
    this.partOfFortune,
    this.vertex,
    required this.mutualReceptions,
    required this.aspectPatterns,
    required this.hemisphereBalance,
    required this.chartShape,
    required this.fixedStarConjunctions,
    this.isVoidOfCourseMoon = false,
  });
}
