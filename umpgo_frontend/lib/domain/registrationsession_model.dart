class RegistrationSession {
  final int sessionID;
  final int registrarID;
  final String eligibleYear;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;

  RegistrationSession({
    required this.sessionID,
    required this.registrarID,
    required this.eligibleYear,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  factory RegistrationSession.fromJson(Map<String, dynamic> json) {
    return RegistrationSession(
      sessionID: json['sessionID'],
      registrarID: json['registrarID'],
      eligibleYear:
          json['eligableYear'], // Matches the typo 'eligableYear' in SQL[cite: 1]
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
