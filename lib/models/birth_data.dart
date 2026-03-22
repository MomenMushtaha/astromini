class BirthData {
  final String? name;
  final DateTime birthDate;
  final int birthHour;
  final int birthMinute;
  final double latitude;
  final double longitude;
  final String locationName;
  final double utcOffset;

  const BirthData({
    this.name,
    required this.birthDate,
    required this.birthHour,
    required this.birthMinute,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.utcOffset,
  });

  DateTime get birthDateTimeUtc {
    final local = DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      birthHour,
      birthMinute,
    );
    return local.subtract(Duration(
      hours: utcOffset.truncate(),
      minutes: ((utcOffset % 1) * 60).round(),
    ));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'birthHour': birthHour,
        'birthMinute': birthMinute,
        'latitude': latitude,
        'longitude': longitude,
        'locationName': locationName,
        'utcOffset': utcOffset,
      };

  factory BirthData.fromJson(Map<String, dynamic> json) => BirthData(
        name: json['name'] as String?,
        birthDate: DateTime.parse(json['birthDate'] as String),
        birthHour: json['birthHour'] as int,
        birthMinute: json['birthMinute'] as int,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        locationName: json['locationName'] as String,
        utcOffset: (json['utcOffset'] as num).toDouble(),
      );
}
