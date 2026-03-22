import 'package:flutter/foundation.dart';
import '../models/birth_chart.dart';
import '../models/personality_profile.dart';
import '../services/personality_service.dart';

class UserProfileProvider extends ChangeNotifier {
  PersonalityProfile? _profile;
  bool _isGenerating = false;

  PersonalityProfile? get profile => _profile;
  bool get isGenerating => _isGenerating;
  bool get hasProfile => _profile != null;

  Future<void> generateProfile(BirthChart chart) async {
    _isGenerating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    _profile = PersonalityService.generate(chart);

    _isGenerating = false;
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}
