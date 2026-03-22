import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/planet_position.dart';
import '../models/transit_alert.dart';
import '../services/astro/astro_engine.dart';
import '../services/astro/transit_data.dart';

class SkyMapProvider extends ChangeNotifier {
  Map<CelestialBody, PlanetPosition> _currentPositions = {};
  List<TransitAlert> _alerts = [];
  Timer? _refreshTimer;

  Map<CelestialBody, PlanetPosition> get currentPositions => _currentPositions;
  List<TransitAlert> get alerts => _alerts;

  void startTracking() {
    _refresh();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _refresh(),
    );
  }

  void stopTracking() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _refresh() {
    _currentPositions = AstroEngine.currentPositions();
    _alerts = TransitData.getActiveAndUpcoming();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
