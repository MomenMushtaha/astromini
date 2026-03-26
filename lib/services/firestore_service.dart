import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/birth_data.dart';
import '../models/cloud_profile.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _profilesRef(String userId) =>
      _db.collection('users').doc(userId).collection('profiles');

  Future<String> saveProfile(String userId, BirthData data) async {
    final doc = await _profilesRef(userId).add({
      'birthData': data.toJson(),
      'displayName': data.name ?? 'My Profile',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateProfile(
      String userId, String profileId, BirthData data) async {
    await _profilesRef(userId).doc(profileId).update({
      'birthData': data.toJson(),
      'displayName': data.name ?? 'My Profile',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<CloudProfile>> getUserProfiles(String userId) async {
    try {
      final snap = await _profilesRef(userId)
          .orderBy('createdAt', descending: false)
          .get();
      return snap.docs.map((d) {
        final raw = d.data();
        return CloudProfile(
          id: d.id,
          birthData: BirthData.fromJson(
              Map<String, dynamic>.from(raw['birthData'] as Map)),
          createdAt:
              (raw['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('FirestoreService.getUserProfiles error: $e');
      return [];
    }
  }

  Future<void> deleteProfile(String userId, String profileId) async {
    await _profilesRef(userId).doc(profileId).delete();
  }
}
