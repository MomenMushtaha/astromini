import 'birth_data.dart';

class CloudProfile {
  final String id;
  final BirthData birthData;
  final DateTime createdAt;

  const CloudProfile({
    required this.id,
    required this.birthData,
    required this.createdAt,
  });

  String get displayName => birthData.name ?? 'My Profile';
}
