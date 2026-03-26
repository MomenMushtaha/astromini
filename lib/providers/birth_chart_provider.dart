import 'package:flutter/foundation.dart';
import '../models/birth_chart.dart';
import '../models/birth_data.dart';
import '../models/cloud_profile.dart';
import '../services/astro/astro_engine.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';

class BirthChartProvider extends ChangeNotifier {
  final StorageService _storage;
  final FirestoreService _firestore;

  BirthChart? _chart;
  BirthData? _birthData;
  bool _isCalculating = false;

  String? _currentUserId;
  String? _currentProfileId;
  List<CloudProfile> _cloudProfiles = [];
  bool _isLoadingProfiles = false;
  bool _profileChoicePending = false;

  BirthChartProvider(this._storage, this._firestore);

  BirthChart? get chart => _chart;
  BirthData? get birthData => _birthData;
  bool get isCalculating => _isCalculating;
  bool get hasChart => _chart != null;
  List<CloudProfile> get cloudProfiles => List.unmodifiable(_cloudProfiles);
  bool get isLoadingProfiles => _isLoadingProfiles;
  bool get profileChoicePending => _profileChoicePending;
  String? get currentProfileId => _currentProfileId;

  Future<void> loadSavedBirthData() async {
    final data = _storage.loadBirthData();
    if (data != null) {
      _birthData = data;
      _chart = AstroEngine.calculateChart(data);
      notifyListeners();
    }
  }

  /// Called by ProxyProvider whenever the authenticated user changes.
  void onAuthChanged(String? userId) {
    if (userId == _currentUserId) return;
    _currentUserId = userId;

    if (userId != null) {
      _loadCloudProfiles(userId);
    } else {
      // User logged out — clear cloud state but keep any local chart
      _cloudProfiles = [];
      _currentProfileId = null;
      _profileChoicePending = false;
      notifyListeners();
    }
  }

  Future<void> _loadCloudProfiles(String userId) async {
    _isLoadingProfiles = true;
    notifyListeners();
    try {
      _cloudProfiles = await _firestore.getUserProfiles(userId);
      // Show the picker only when there are cloud profiles and no chart is
      // already loaded from local storage (e.g. fresh install / new device).
      _profileChoicePending = _cloudProfiles.isNotEmpty && !hasChart;
    } finally {
      _isLoadingProfiles = false;
      notifyListeners();
    }
  }

  /// User chose to start fresh — dismiss the picker without loading anything.
  void dismissProfileChoice() {
    _profileChoicePending = false;
    notifyListeners();
  }

  /// Load an existing cloud profile and restore its chart.
  Future<void> restoreCloudProfile(CloudProfile profile) async {
    _isCalculating = true;
    _profileChoicePending = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _birthData = profile.birthData;
    _chart = AstroEngine.calculateChart(profile.birthData);
    _currentProfileId = profile.id;
    await _storage.saveBirthData(profile.birthData);

    _isCalculating = false;
    notifyListeners();
  }

  Future<void> calculateChart(BirthData data) async {
    _isCalculating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _birthData = data;
    _chart = AstroEngine.calculateChart(data);
    await _storage.saveBirthData(data);

    // Persist to Firestore for authenticated users.
    if (_currentUserId != null) {
      try {
        if (_currentProfileId != null) {
          // Update the profile the user is currently working with.
          await _firestore.updateProfile(_currentUserId!, _currentProfileId!, data);
        } else {
          // New profile — create a Firestore document.
          final id = await _firestore.saveProfile(_currentUserId!, data);
          _currentProfileId = id;
          _cloudProfiles = [
            ..._cloudProfiles,
            CloudProfile(id: id, birthData: data, createdAt: DateTime.now()),
          ];
        }
      } catch (e) {
        debugPrint('BirthChartProvider: Firestore save failed: $e');
      }
    }

    _isCalculating = false;
    notifyListeners();
  }

  /// Clear the current chart. Next [calculateChart] call will create a new
  /// Firestore document rather than updating the old one.
  void clearChart() {
    _chart = null;
    _birthData = null;
    _currentProfileId = null;
    _storage.clearBirthData();
    notifyListeners();
  }
}
