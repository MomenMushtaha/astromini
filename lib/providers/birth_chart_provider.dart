import 'package:flutter/foundation.dart';
import '../models/birth_chart.dart';
import '../models/birth_data.dart';
import '../services/astro/astro_engine.dart';
import '../services/storage_service.dart';

class BirthChartProvider extends ChangeNotifier {
  final StorageService _storage;
  BirthChart? _chart;
  BirthData? _birthData;
  bool _isCalculating = false;

  BirthChartProvider(this._storage);

  BirthChart? get chart => _chart;
  BirthData? get birthData => _birthData;
  bool get isCalculating => _isCalculating;
  bool get hasChart => _chart != null;

  Future<void> loadSavedBirthData() async {
    final data = _storage.loadBirthData();
    if (data != null) {
      _birthData = data;
      _chart = AstroEngine.calculateChart(data);
      notifyListeners();
    }
  }

  Future<void> calculateChart(BirthData data) async {
    _isCalculating = true;
    notifyListeners();

    // Small delay for UX feel
    await Future.delayed(const Duration(milliseconds: 500));

    _birthData = data;
    _chart = AstroEngine.calculateChart(data);
    await _storage.saveBirthData(data);

    _isCalculating = false;
    notifyListeners();
  }

  void clearChart() {
    _chart = null;
    _birthData = null;
    _storage.clearBirthData();
    notifyListeners();
  }
}
