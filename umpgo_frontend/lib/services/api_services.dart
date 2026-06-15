import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
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