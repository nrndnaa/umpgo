class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String login = 'http://10.0.2.2:8000/api/login';
<<<<<<< Updated upstream
  static String sectionStudents(int sectionID) =>
      '$baseUrl/sections/$sectionID/students';
  static const String subjects = '$baseUrl/subjects';
=======

  // Open Registration
  static String registrationSession(String yearOfStudy) =>
      '$baseUrl/registration-session/$yearOfStudy';
>>>>>>> Stashed changes
}
