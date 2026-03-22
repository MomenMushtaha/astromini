import 'package:flutter/foundation.dart';
import '../models/birth_chart.dart';
import '../models/birth_data.dart';
import '../models/compatibility_result.dart';
import '../services/astro/astro_engine.dart';
import '../services/compatibility_service.dart';

class CompatibilityProvider extends ChangeNotifier {
  CompatibilityResult? _result;
  BirthData? _partnerBirthData;
  BirthChart? _partnerChart;
  bool _isCalculating = false;

  CompatibilityResult? get result => _result;
  BirthData? get partnerBirthData => _partnerBirthData;
  BirthChart? get partnerChart => _partnerChart;
  bool get isCalculating => _isCalculating;

  Future<void> calculateCompatibility(
      BirthChart userChart, BirthData partnerData) async {
    _isCalculating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _partnerBirthData = partnerData;
    _partnerChart = AstroEngine.calculateChart(partnerData);
    _result = CompatibilityService.calculate(userChart, _partnerChart!);

    _isCalculating = false;
    notifyListeners();
  }

  void clearResult() {
    _result = null;
    _partnerBirthData = null;
    _partnerChart = null;
    notifyListeners();
  }
}
