class Horoscope {
  final String sign;
  final String date;
  final String dailyReading;
  final String loveReading;
  final String careerReading;
  final String healthReading;
  final String luckyNumber;
  final String luckyColor;
  final String mood;
  final double compatibility;
  final String? transitContext;
  final String? moonPhaseToday;
  final List<String>? keyTransits;
  final String? voidOfCourseMoonWarning;

  const Horoscope({
    required this.sign,
    required this.date,
    required this.dailyReading,
    required this.loveReading,
    required this.careerReading,
    required this.healthReading,
    required this.luckyNumber,
    required this.luckyColor,
    required this.mood,
    required this.compatibility,
    this.transitContext,
    this.moonPhaseToday,
    this.keyTransits,
    this.voidOfCourseMoonWarning,
  });
}
