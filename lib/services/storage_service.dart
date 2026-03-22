import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/birth_data.dart';

class StorageService {
  static const _birthDataKey = 'birth_data';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveBirthData(BirthData data) async {
    await _prefs.setString(_birthDataKey, jsonEncode(data.toJson()));
  }

  BirthData? loadBirthData() {
    final json = _prefs.getString(_birthDataKey);
    if (json == null) return null;
    return BirthData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> clearBirthData() async {
    await _prefs.remove(_birthDataKey);
  }

  bool get hasBirthData => _prefs.containsKey(_birthDataKey);
}
