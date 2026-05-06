class ModuleEnrollment {
  final int modEnrollID;
  final int moduleID;
  final int studentID;
  final String attendanceStatus;
  final int totalMarks;
  final String enrolledAt;

  ModuleEnrollment({
    required this.modEnrollID,
    required this.moduleID,
    required this.studentID,
    required this.attendanceStatus,
    required this.totalMarks,
    required this.enrolledAt,
  });

  factory ModuleEnrollment.fromJson(Map<String, dynamic> json) {
    return ModuleEnrollment(
      modEnrollID: json['modEnrollID'],
      moduleID: json['moduleID'],
      studentID: json['studentID'],
      attendanceStatus: json['attendanceStatus'],
      totalMarks: json['totalMarks'],
      enrolledAt: json['enrolled_At'],
    );
  }
}
