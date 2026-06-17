class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String login = '$baseUrl/login';

  static const String validateCode = '$baseUrl/attendance/validate-code';
  static const String checkIn = '$baseUrl/attendance/checkin';
  static const String createSession = '$baseUrl/attendance/session/create';
  static const String endSession = '$baseUrl/attendance/session/end';
  static String sessionDetail(int id) => '$baseUrl/attendance/session/$id';
  static String activeSession(int id) => '$baseUrl/attendance/session/active?lecturerID=$id';
  static String activeSessionAdab(int id) => '$baseUrl/attendance/session/active?adabID=$id';
  static String allSessions(int id) => '$baseUrl/attendance/sessions?lecturerID=$id';
  static String allSessionsAdab(int id) => '$baseUrl/attendance/sessions?adabID=$id';
  static String editAttendance(int id) => '$baseUrl/attendance/session/$id/edit';
  static String lecturerSections(int id) => '$baseUrl/lecturer/$id/sections';
  static String studentSections(int id) => '$baseUrl/student/$id/sections';
  static String adabModules(int id) => '$baseUrl/adab/$id/modules';
  static String studentModules(int id) => '$baseUrl/student/$id/modules';

  static const String modules = '$baseUrl/modules';
  static const String allModules = '$baseUrl/modules/all';
  static const String registerModule = '$baseUrl/modules/register';
  static const String myBookings = '$baseUrl/modules/mybookings';
  static const String submitClaim = '$baseUrl/creditclaim/submit';
  static const String creditClaims = '$baseUrl/creditclaim/all';

  static String myEnrollments(int id) => '$baseUrl/students/$id/enrollments';
  static String studentSubjects(int id) => '$baseUrl/students/$id/enrollments';
  static String sectionStudents(int id) => '$baseUrl/sections/$id/students';
  static const String subjects = '$baseUrl/subjects';
  static String registrationSession(String y) => '$baseUrl/registration-session/$y';
}