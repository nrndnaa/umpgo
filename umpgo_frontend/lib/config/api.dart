import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static String get _base {
    if (kIsWeb) {
      return 'http://10.212.48.165:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://10.212.48.165:8000/api';
    }
  }

  static String get baseUrl => _base;

  static String get login => '$_base/login';
  static String get modules => '$_base/modules';
  static String get allModules => '$_base/modules/all';

  static String sectionStudents(int sectionID) =>
      '$_base/sections/$sectionID/students';
  static String get subjects => '$_base/subjects';
  static String registrationSession(String yearOfStudy) =>
      '$_base/registration-session/$yearOfStudy';

  static String get registerModule => '$_base/modules/register';
  static String get myBookings => '$_base/modules/mybookings';
  static String get submitClaim => '$_base/creditclaim/submit';
  static String get creditClaims => '$_base/creditclaim/all';
}
