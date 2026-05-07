class Enrollment {
  final int enrollmentID;
  final int studentID;
  final int sectionID;
  final int sessionID;
  final String status;
  final String registeredAt;

  Enrollment({
    required this.enrollmentID,
    required this.studentID,
    required this.sectionID,
    required this.sessionID,
    required this.status,
    required this.registeredAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentID: json['enrollmentID'],
      studentID: json['studentID'],
      sectionID: json['sectionID'],
      sessionID: json['sessionID'],
      status: json['status'],
      registeredAt: json['registered_At'],
    );
  }
}
