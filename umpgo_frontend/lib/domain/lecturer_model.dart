class Lecturer {
  final int lecturerID;
  final String staffID;
  final String name;
  final String email;
  final String faculty;

  Lecturer({
    required this.lecturerID,
    required this.staffID,
    required this.name,
    required this.email,
    required this.faculty,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      lecturerID: json['lecturerID'],
      staffID: json['staffID'],
      name: json['name'],
      email: json['email'],
      faculty: json['faculty'],
    );
  }
}
