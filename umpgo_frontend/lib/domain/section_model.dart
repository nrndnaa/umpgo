class SectionModel {
  final int sectionID;
  final int subjectID;
  final int lecturerID;
  final String sectionNo;
  final int capacity;
  final int enrolled; // ← add this
  final String day;
  final String startTime;
  final String endTime;
  final String venue;

  SectionModel({
    required this.sectionID,
    required this.subjectID,
    required this.lecturerID,
    required this.sectionNo,
    required this.capacity,
    required this.enrolled,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.venue,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      sectionID: json['sectionID'],
      subjectID: json['subjectID'],
      lecturerID: json['lecturerID'],
      sectionNo: json['sectionNo'],
      capacity: json['capacity'] ?? 0,
      enrolled:
          json['enrolled'] ?? 0, // ← default 0 if API doesn't return it yet
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      venue: json['venue'] ?? '',
    );
  }

  bool get isFull => enrolled >= capacity;
  String get time => '$startTime - $endTime';
}
