import 'package:flutter/material.dart';
import 'package:umpgo_frontend/screens/login.dart';

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
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),  // ← must be LoginScreen not LoginController
    );
  }
}