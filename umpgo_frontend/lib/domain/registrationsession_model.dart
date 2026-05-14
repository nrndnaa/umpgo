class RegistrationSession {
  final int sessionID;
  final int registrarID;
  final String eligableYear;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;

  RegistrationSession({
    required this.sessionID,
    required this.registrarID,
    required this.eligableYear,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  factory RegistrationSession.fromJson(Map<String, dynamic> json) {
    return RegistrationSession(
      sessionID: json['sessionID'],
      registrarID: json['registrarID'],
      eligableYear:
          json['eligableYear'], // Matches the typo 'eligableYear' in SQL[cite: 1]
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
