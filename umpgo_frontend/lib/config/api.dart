class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String login = 'http://10.0.2.2:8000/api/login';
  static const String modules = 'http://10.0.2.2:8000/api/modules';
  static const String registerModule = '$baseUrl/modules/register';
  static const String myBookings = '$baseUrl/modules/mybookings';
  static const String submitClaim = '$baseUrl/creditclaim/submit';
  static const String creditClaims = '$baseUrl/creditclaim/all';
}
