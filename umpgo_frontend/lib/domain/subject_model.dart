class Subject {
  final int subjectID;
  final String subjectCode;
  final String subjectName;
  final int creditHours;

  Subject({
    required this.subjectID,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectID: json['subjectID'],
      subjectCode: json['subjectCode'],
      subjectName: json['subjectName'],
      creditHours: json['creditHours'],
    );
  }
}
