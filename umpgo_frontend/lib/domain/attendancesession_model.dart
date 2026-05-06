class AttendanceSession {
  final int attSessionID;
  final int lecturerID;
  final int sectionID;
  final String code;
  final String codeExpiry;
  final String startedAt;
  final String endedAt;

  AttendanceSession({
    required this.attSessionID,
    required this.lecturerID,
    required this.sectionID,
    required this.code,
    required this.codeExpiry,
    required this.startedAt,
    required this.endedAt,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json) {
    return AttendanceSession(
      attSessionID: json['attSessionID'],
      lecturerID: json['lecturerID'],
      sectionID: json['sectionID'],
      code: json['code'],
      codeExpiry: json['codeExpiry'],
      startedAt: json['started_At'],
      endedAt: json['ended_At'],
    );
  }
}