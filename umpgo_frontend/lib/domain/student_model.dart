class StudentModel {
  final int studentID;
  final String matricID;
  final String name;
  final String email;
  final String yearOfStudy;
  final String programme;
  final String status;
  final int outstandingBalance;

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
      studentID:          json['studentID'],
      matricID:           json['matricID'],
      name:               json['name'],
      email:              json['email'],
      yearOfStudy:        json['yearOfStudy'],
      programme:          json['programme'],
      status:             json['status'],
      outstandingBalance: json['outstandingBalance'],
    );
  }
}