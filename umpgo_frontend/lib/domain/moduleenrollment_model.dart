class ModuleEnrollment {
  final int modEnrollID;
  final int moduleID;
  final int studentID;
  final String attendanceStatus;
  final int totalMarks;
  final String enrolled_At;

  ModuleEnrollment({
    required this.modEnrollID,
    required this.moduleID,
    required this.studentID,
    required this.attendanceStatus,
    required this.totalMarks,
    required this.enrolled_At,
  });

  factory ModuleEnrollment.fromJson(Map<String, dynamic> json) {
    return ModuleEnrollment(
      modEnrollID: json['modEnrollID'],
      moduleID: json['moduleID'],
      studentID: json['studentID'],
      attendanceStatus: json['attendanceStatus'],
      totalMarks: json['totalMarks'],
      enrolled_At: json['enrolled_At'],
    );
  }
}
