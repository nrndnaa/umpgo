class AttendanceRecord {
  final int recordID;
  final int attSessionID;
  final int studentID;
  final String status;
  final int gpsVerified; // tinyint is usually handled as int (0 or 1)
  final String checkedInAt;

  AttendanceRecord({
    required this.recordID,
    required this.attSessionID,
    required this.studentID,
    required this.status,
    required this.gpsVerified,
    required this.checkedInAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      recordID: json['recordID'],
      attSessionID: json['attSessionID'],
      studentID: json['studentID'],
      status: json['status'],
      gpsVerified: json['gpsVerified'],
      checkedInAt: json['checkedIn_At'],
    );
  }
}