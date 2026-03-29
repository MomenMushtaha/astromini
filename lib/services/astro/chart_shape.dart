import '../../models/planet_position.dart';
import '../../models/chart_analysis_result.dart';

/// Detects the overall shape/pattern of planet distribution in a chart.
class ChartShapeDetector {
  ChartShapeDetector._();

  static ChartShape detectShape(Map<CelestialBody, PlanetPosition> planets) {
    // Exclude nodes and points — only use actual planets
    final planetBodies = planets.entries
        .where((e) =>
            e.key != CelestialBody.northNode &&
            e.key != CelestialBody.southNode &&
            e.key != CelestialBody.lilith)
        .toList();

    if (planetBodies.isEmpty) {
      return const ChartShape(
        type: ChartShapeType.splash,
        description: 'Planets spread evenly across the chart.',
      );
    }

    // Sort by ecliptic longitude
    final sorted = planetBodies
        .map((e) => (body: e.key, lon: e.value.eclipticLongitude))
        .toList()
      ..sort((a, b) => a.lon.compareTo(b.lon));

    // Find the largest gap between consecutive planets
    double largestGap = 0;
    int gapAfterIndex = 0;
    for (int i = 0; i < sorted.length; i++) {
      final next = (i + 1) % sorted.length;
      var gap = sorted[next].lon - sorted[i].lon;
      if (gap <= 0) gap += 360.0;
      if (gap > largestGap) {
        largestGap = gap;
        gapAfterIndex = i;
      }
    }

    final occupiedArc = 360.0 - largestGap;

    // The planet clockwise from the gap is the "leading" planet
    final leadingIndex = (gapAfterIndex + 1) % sorted.length;
    final leadingPlanet = sorted[leadingIndex].body;

    // Check for Bucket: Bowl with one isolated "handle" planet
    if (largestGap > 180.0) {
      // Check if there's a single planet on the empty side
      final handlePlanet = _findHandle(sorted, gapAfterIndex);
      if (handlePlanet != null) {
        return ChartShape(
          type: ChartShapeType.bucket,
          handle: handlePlanet,
          description:
              'A Bucket pattern with ${handlePlanet.displayName} as the handle — '
              'this planet channels the energy of the entire chart, '
              'acting as a focal point for all activity and purpose.',
        );
      }
    }

    // Bundle: all planets within 120°
    if (occupiedArc <= 120.0) {
      return ChartShape(
        type: ChartShapeType.bundle,
        leading: leadingPlanet,
        description:
            'A Bundle pattern — all planets concentrated within a narrow arc. '
            'Intense focus and specialization, but may lack perspective in '
            'areas of life represented by the empty houses.',
      );
    }

    // Bowl: all planets within 180°
    if (occupiedArc <= 180.0) {
      return ChartShape(
        type: ChartShapeType.bowl,
        leading: leadingPlanet,
        description:
            'A Bowl pattern led by ${leadingPlanet.displayName} — '
            'self-contained energy with a strong sense of advocacy. '
            'The empty half represents areas to be explored and integrated.',
      );
    }

    // Locomotive: occupied arc between 240° and 300° (gap between 60° and 120°)
    if (largestGap >= 60.0 && largestGap <= 120.0) {
      return ChartShape(
        type: ChartShapeType.locomotive,
        leading: leadingPlanet,
        description:
            'A Locomotive pattern driven by ${leadingPlanet.displayName} — '
            'powerful forward momentum and executive ability. '
            'The empty segment represents an area of perpetual striving.',
      );
    }

    // See-Saw: two groups separated by two gaps of 60°+ each
    if (_isSeesaw(sorted)) {
      return const ChartShape(
        type: ChartShapeType.seesaw,
        description:
            'A See-Saw pattern — planets divided into two opposing groups. '
            'Life involves constant balancing of two competing perspectives, '
            'leading to awareness and diplomacy.',
      );
    }

    // Splay: 3 distinct clusters
    if (_isSplay(sorted)) {
      return const ChartShape(
        type: ChartShapeType.splay,
        description:
            'A Splay pattern — planets forming distinct clusters across the chart. '
            'Strong individualism and resistance to conformity, '
            'with talent distributed across multiple areas.',
      );
    }

    // Default: Splash (relatively even distribution)
    return const ChartShape(
      type: ChartShapeType.splash,
      description:
          'A Splash pattern — planets spread widely across the zodiac. '
          'Versatile and adaptable with broad interests, '
          'but may scatter energy across too many pursuits.',
    );
  }

  /// Check for a handle planet: a single planet opposite the Bowl.
  static CelestialBody? _findHandle(
    List<({CelestialBody body, double lon})> sorted,
    int gapAfterIndex,
  ) {
    // Count how many planets are in the "gap" half
    // A handle must be truly isolated — check if removing one planet
    // would make the gap > 180°
    final n = sorted.length;
    if (n < 4) return null; // Need at least 4 planets for a meaningful Bucket

    // Find all gaps > 60°
    final gaps = <(int, double)>[];
    for (int i = 0; i < n; i++) {
      final next = (i + 1) % n;
      var gap = sorted[next].lon - sorted[i].lon;
      if (gap <= 0) gap += 360.0;
      if (gap > 60.0) gaps.add((i, gap));
    }

    // Bucket: exactly 2 large gaps isolating 1 planet
    if (gaps.length == 2) {
      // The planet between the two gaps is the handle
      final gapIndices = gaps.map((g) => g.$1).toList();
      for (int i = 0; i < n; i++) {
        final prev = (i - 1 + n) % n;
        if (gapIndices.contains(prev) && gapIndices.contains(i)) {
          return sorted[i].body;
        }
      }
    }
    return null;
  }

  /// See-Saw: two groups with two gaps of 60°+
  static bool _isSeesaw(List<({CelestialBody body, double lon})> sorted) {
    int largeGaps = 0;
    for (int i = 0; i < sorted.length; i++) {
      final next = (i + 1) % sorted.length;
      var gap = sorted[next].lon - sorted[i].lon;
      if (gap <= 0) gap += 360.0;
      if (gap >= 60.0) largeGaps++;
    }
    return largeGaps == 2;
  }

  /// Splay: 3 distinct clusters (3 gaps of 30°+)
  static bool _isSplay(List<({CelestialBody body, double lon})> sorted) {
    int clusterGaps = 0;
    for (int i = 0; i < sorted.length; i++) {
      final next = (i + 1) % sorted.length;
      var gap = sorted[next].lon - sorted[i].lon;
      if (gap <= 0) gap += 360.0;
      if (gap >= 30.0) clusterGaps++;
    }
    return clusterGaps >= 3;
  }
}
