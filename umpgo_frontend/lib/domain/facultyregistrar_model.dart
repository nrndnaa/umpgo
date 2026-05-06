class FacultyRegistrar {
  final int registrarID;
  final String staffID;
  final String name;
  final String email;
  final String faculty;

  FacultyRegistrar({
    required this.registrarID,
    required this.staffID,
    required this.name,
    required this.email,
    required this.faculty,
  });

  factory FacultyRegistrar.fromJson(Map<String, dynamic> json) {
    return FacultyRegistrar(
      registrarID: json['registrarID'],
      staffID: json['staffID'],
      name: json['name'],
      email: json['email'],
      faculty: json['faculty'],
    );
  }
}
