import 'package:flutter/material.dart';
import 'package:umpgo_frontend/screens/login.dart';
import 'package:umpgo_frontend/screens/student_dashboard.dart';
import 'package:umpgo_frontend/screens/lecturer_dashboard.dart';
import 'package:umpgo_frontend/screens/registrar_dashboard.dart';
import 'package:umpgo_frontend/screens/treasury_dashboard.dart';

void main() {
  runApp(const UMPGoApp());
}

class UMPGoApp extends StatelessWidget {
  const UMPGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMPGo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // Or whichever font you prefer
      ),
      // Initial screen
      home: const LoginScreen(),

      // Defining routes for cleaner navigation
      routes: {
        '/login': (context) => const LoginScreen(),
        '/student_dashboard': (context) => const StudentDashboard(),
        '/lecturer_dashboard': (context) => const LecturerDashboard(),
        '/registrar_dashboard': (context) => const RegistrarDashboard(),
        '/treasury_dashboard': (context) => const TreasuryDashboard(),
      },
    );
  }
}
