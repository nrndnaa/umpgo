


import 'package:flutter/foundation.dart';

class ApiConfig {
<<<<<<< HEAD
static const String baseUrl = 'http://10.212.48.165:8000/api';  
static const String login = '$baseUrl/login';
  static const String modules = '$baseUrl/modules';
  static const String allModules = '$baseUrl/modules/all'; 

  static String sectionStudents(int sectionID) =>
      '$baseUrl/sections/$sectionID/students';
  static const String subjects = '$baseUrl/subjects';
  static String registrationSession(String yearOfStudy) =>
      '$baseUrl/registration-session/$yearOfStudy';

static const String registerModule = '$baseUrl/modules/register';
  static const String myBookings = '$baseUrl/modules/mybookings';
  static const String submitClaim = '$baseUrl/creditclaim/submit';
  static const String creditClaims = '$baseUrl/creditclaim/all';
}
=======

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  static String get login => '$baseUrl/login';
}


>>>>>>> tuitionFee
