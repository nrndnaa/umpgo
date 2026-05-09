import 'section_model.dart';

class Subject {
  final int subjectID;
  final String subjectCode;
  final String subjectName;
  final int creditHours;

  // This is the missing link!
  final List<SectionModel> sections;

  Subject({
    required this.subjectID,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
    required this.sections, // Add this to the constructor
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectID: json['subjectID'] ?? 0,
      subjectCode: json['subjectCode'] ?? '',
      subjectName: json['subjectName'] ?? '',
      creditHours: json['creditHours'] ?? 0,
      // Map the nested sections from your API response
      sections: (json['sections'] as List? ?? [])
          .map((i) => SectionModel.fromJson(i))
          .toList(),
    );
  }
}
