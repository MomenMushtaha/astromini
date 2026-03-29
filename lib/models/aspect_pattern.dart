import 'planet_position.dart';

enum AspectPatternType {
  grandTrine('Grand Trine'),
  tSquare('T-Square'),
  grandCross('Grand Cross'),
  yod('Yod (Finger of God)'),
  kite('Kite'),
  mysticRectangle('Mystic Rectangle');

  final String displayName;
  const AspectPatternType(this.displayName);
}

class AspectPattern {
  final AspectPatternType type;
  final List<CelestialBody> planets;
  final CelestialBody? apex;
  final String? element;
  final String description;

  const AspectPattern({
    required this.type,
    required this.planets,
    this.apex,
    this.element,
    required this.description,
  });
}
