class StudentModel {
  final int studentID;
  final String matricID;
  final String name;
  final String email;
  final String yearOfStudy;
  final String programme;
  final String status;
<<<<<<< HEAD
  final double outstandingBalance; // ← changed
=======
  final double outstanding;


>>>>>>> tuitionFee

  StudentModel({
    required this.studentID,
    required this.matricID,
    required this.name,
    required this.email,
    required this.yearOfStudy,
    required this.programme,
    required this.status,
    required this.outstanding,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
<<<<<<< HEAD
      studentID: json['studentID'],
      matricID: json['matricID'],
      name: json['name'],
      email: json['email'],
      yearOfStudy: json['yearOfStudy'],
      programme: json['programme'],
      status: json['status'],
      outstandingBalance: double.parse(json['outstandingBalance'].toString()),
=======
      studentID: int.tryParse(json['studentID'].toString()) ?? 0,

      matricID: json['matricID']?.toString() ?? '',

      name: json['name']?.toString() ?? '',

      email: json['email']?.toString() ?? '',

      yearOfStudy: json['yearOfStudy']?.toString() ?? '',

      programme: json['programme']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      outstanding:
          double.tryParse(json['outstandingBalance'].toString()) ?? 0.0,
>>>>>>> tuitionFee
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
