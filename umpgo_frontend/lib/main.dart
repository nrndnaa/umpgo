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
      title: 'UMPGo',
      debugShowCheckedModeBanner: false, // Optional: hides the debug banner
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
      // Initial screen
      home: const LoginScreen(),
    );
  }
}
