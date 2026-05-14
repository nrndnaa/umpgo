class StudentModel {
  final int studentID;
  final String matricID;
  final String name;
  final String email;
  final String yearOfStudy;
  final String programme;
  final String status;

  final double outstandingBalance;

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
      studentID: int.tryParse(json['studentID'].toString()) ?? 0,

      matricID: json['matricID']?.toString() ?? '',

      name: json['name']?.toString() ?? '',

      email: json['email']?.toString() ?? '',

      yearOfStudy: json['yearOfStudy']?.toString() ?? '',

      programme: json['programme']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      outstandingBalance:
          double.tryParse(json['outstandingBalance'].toString()) ?? 0.0,
    );
  }
}