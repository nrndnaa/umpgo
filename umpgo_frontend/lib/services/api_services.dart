import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';

class ApiService {
<<<<<<< Updated upstream
  static const String baseUrl = "http://10.0.2.2:8000/api";
  // IMPORTANT: 10.0.2.2 for Android emulator

  // Student dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(Uri.parse("$baseUrl/student/dashboard"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard");
    }
  }

  // Lecturer/Adab creates attendance session
  static Future<Map<String, dynamic>> createSession(
      String title, int duration, int lecturerID, {int? adabID}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/attendance/session"),
      body: {
        'sessionTitle': title,
        'codeDuration': duration.toString(),
        'lecturerID': lecturerID.toString(),
        if (adabID != null) 'adabID': adabID.toString(),
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create session");
    }
  }

  // Student checks in with code + GPS
  static Future<Map<String, dynamic>> checkIn(
      String code, int studentID, double lat, double lon) async {
    final response = await http.post(
      Uri.parse("$baseUrl/attendance/checkin"),
      body: {
        'code': code,
        'studentID': studentID.toString(),
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'gpsVerified': 'true',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to check in");
    }
  }
}
=======
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password, "role": role}),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getStudentSubjects(int studentID) async {
    final response = await http.get(Uri.parse(ApiConfig.studentSubjects(studentID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['enrollments'] ?? [];
    }
    throw Exception("Failed to load subjects");
  }

  static Future<List<dynamic>> getStudentModules(int studentID) async {
    final response = await http.get(Uri.parse(ApiConfig.studentModules(studentID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['bookings'] ?? [];
    }
    throw Exception("Failed to load modules");
  }

  static Future<Map<String, dynamic>> checkIn(
    String code, int studentID, double lat, double lon,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConfig.checkIn),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'code': code,
        'studentID': studentID,
        'latitude': lat,
        'longitude': lon,
        'gpsVerified': true,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createSession({
    required String title,
    required int duration,
    int? lecturerID,
    int? adabID,
    int? sectionID,
    int? moduleID,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.createSession),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'sessionTitle': title,
        'codeDuration': duration,
        if (lecturerID != null) 'lecturerID': lecturerID,
        if (adabID != null) 'adabID': adabID,
        if (sectionID != null) 'sectionID': sectionID,
        if (moduleID != null) 'moduleID': moduleID,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> endSession(int sessionID) async {
    final response = await http.post(
      Uri.parse(ApiConfig.endSession),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'attSessionID': sessionID}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getSessionDetails(int sessionID) async {
    final response = await http.get(Uri.parse(ApiConfig.sessionDetail(sessionID)));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to load session");
  }

  static Future<List<dynamic>> getAllSessions(int lecturerID) async {
    final response = await http.get(Uri.parse(ApiConfig.allSessions(lecturerID)));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sessions'] ?? [];
    }
    throw Exception("Failed to load sessions");
  }

  static Future<Map<String, dynamic>> editAttendance(int recordID, String status) async {
    final response = await http.put(
      Uri.parse(ApiConfig.editAttendance(recordID)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(response.body);
  }
}
>>>>>>> Stashed changes
