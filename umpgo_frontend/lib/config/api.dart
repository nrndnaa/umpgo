class ApiConfig {
<<<<<<< Updated upstream
  static const String baseUrl = 'http://10.202.226.165:8000/api';
  static const String login = '$baseUrl/login';
  static const String modules = '$baseUrl/modules';
  static const String allModules = '$baseUrl/modules/all'; 
=======
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth
  static const String login = '$baseUrl/login';

  // Attendance - Student
  static const String validateCode = '$baseUrl/attendance/validate-code';
  static const String checkIn = '$baseUrl/attendance/checkin';

  // Attendance - Lecturer/Adab
  static const String createSession = '$baseUrl/attendance/session/create';
  static const String endSession = '$baseUrl/attendance/session/end';
  static String sessionDetail(int id) => '$baseUrl/attendance/session/$id';
  static String activeSession(int lecturerID) => '$baseUrl/attendance/session/active?lecturerID=$lecturerID';
  static String activeSessionAdab(int adabID) => '$baseUrl/attendance/session/active?adabID=$adabID';
  static String allSessions(int lecturerID) => '$baseUrl/attendance/sessions?lecturerID=$lecturerID';
  static String allSessionsAdab(int adabID) => '$baseUrl/attendance/sessions?adabID=$adabID';
  static String editAttendance(int sessionID) => '$baseUrl/attendance/session/$sessionID/edit';

  // Sections & Modules for Attendance
  static String lecturerSections(int lecturerID) => '$baseUrl/lecturer/$lecturerID/sections';
  static String studentSections(int studentID) => '$baseUrl/student/$studentID/sections';
  static String adabModules(int adabID) => '$baseUrl/adab/$adabID/modules';
  static String studentModules(int studentID) => '$baseUrl/student/$studentID/modules';

  // KoQ (Najla)
  static const String modules = '$baseUrl/modules';
  static const String allModules = '$baseUrl/modules/all';
>>>>>>> Stashed changes
  static const String registerModule = '$baseUrl/modules/register';
  static const String myBookings = '$baseUrl/modules/mybookings';
  static const String submitClaim = '$baseUrl/creditclaim/submit';
  static const String creditClaims = '$baseUrl/creditclaim/all';
<<<<<<< Updated upstream
=======

  // Open Registration (Nurin)
  static String myEnrollments(int studentID) => '$baseUrl/students/$studentID/enrollments';
  static String studentSubjects(int studentID) => '$baseUrl/students/$studentID/enrollments';
  static String sectionStudents(int sectionID) => '$baseUrl/sections/$sectionID/students';
  static const String subjects = '$baseUrl/subjects';
  static String registrationSession(String yearOfStudy) => '$baseUrl/registration-session/$yearOfStudy';
>>>>>>> Stashed changes
}