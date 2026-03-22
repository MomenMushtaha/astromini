import 'planet_position.dart';

enum TransitType { retrograde, ingress, eclipse, conjunction }

class TransitAlert {
  final String title;
  final String description;
  final CelestialBody planet;
  final DateTime startDate;
  final DateTime endDate;
  final TransitType type;
  final String significance;

  const TransitAlert({
    required this.title,
    required this.description,
    required this.planet,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.significance,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    return startDate.isAfter(now) &&
        startDate.isBefore(now.add(const Duration(days: 30)));
  }
}
