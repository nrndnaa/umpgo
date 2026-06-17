class StudentModel {
  final int studentID;
  final String matricID;
  final String name;
  final String email;
  final String yearOfStudy;
  final String programme;
  final String status;
  final double outstandingBalance;

  StudentModel({
    required this.studentID,
    required this.matricID,
    required this.name,
    required this.email,
    required this.yearOfStudy,
    required this.programme,
    required this.status,
    this.outstandingBalance = 0.0,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentID: json['studentID'] ?? 0,
      matricID: json['matricID'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      yearOfStudy: json['yearOfStudy']?.toString() ?? '',
      programme: json['programme'] ?? '',
      status: json['status'] ?? 'active',
      outstandingBalance: double.tryParse(json['outstandingBalance']?.toString() ?? '0') ?? 0.0,
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