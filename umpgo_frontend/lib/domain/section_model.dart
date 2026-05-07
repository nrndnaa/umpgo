class SectionModel {
  final int sectionID;
  final int subjectID;
  final int lecturerID;
  final String sectionNo;
  final int capacity;
  final String day;
  final String time;
  final String venue;

  SectionModel({
    required this.sectionID,
    required this.subjectID,
    required this.lecturerID,
    required this.sectionNo,
    required this.capacity,
    required this.day,
    required this.time,
    required this.venue,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      sectionID: json['sectionID'],
      subjectID: json['subjectID'],
      lecturerID: json['lecturerID'],
      sectionNo: json['sectionNo'],
      capacity: json['capacity'],
      day: json['day'],
      time: json['time'],
      venue: json['venue'],
    );
  }
}
