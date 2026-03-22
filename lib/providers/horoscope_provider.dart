import 'package:flutter/foundation.dart';
import '../models/horoscope.dart';
import '../services/horoscope_service.dart';

class HoroscopeProvider extends ChangeNotifier {
  final HoroscopeService _service = HoroscopeService();
  final Map<String, Horoscope> _cache = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Horoscope? getHoroscope(String signName) => _cache[signName];

  Future<Horoscope> fetchHoroscope(String signName) async {
    if (_cache.containsKey(signName)) return _cache[signName]!;

    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    final horoscope = _service.getHoroscope(signName);
    _cache[signName] = horoscope;

    _isLoading = false;
    notifyListeners();
    return horoscope;
  }
}
