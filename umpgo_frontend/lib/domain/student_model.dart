class StudentModel {
  final int studentID;
  final String matricID;
  final String name;
  final String email;
  final String yearOfStudy;
  final String programme;
  final String status;
  final double outstandingBalance; // ← changed

  StudentModel({
    required this.studentID,
    required this.matricID,
    required this.name,
    required this.email,
    required this.yearOfStudy,
    required this.programme,
    required this.status,
    required this.outstandingBalance,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentID: json['studentID'],
      matricID: json['matricID'],
      name: json['name'],
      email: json['email'],
      yearOfStudy: json['yearOfStudy'],
      programme: json['programme'],
      status: json['status'],
      outstandingBalance: double.parse(json['outstandingBalance'].toString()),
    );
  }

  factory StudentModel.empty() {
  return StudentModel(
    studentID: 0,
    matricID: '',
    name: '',
    email: '',
    yearOfStudy: '',
    programme: '',
    status: '',
    outstandingBalance: 0.0,
  );
}
}
