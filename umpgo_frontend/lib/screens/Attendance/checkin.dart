import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:umpgo_frontend/services/api_services.dart';
import 'package:umpgo_frontend/domain/student_model.dart'; // Add the model import

class CheckInScreen extends StatefulWidget {
  final StudentModel student; // Change from int studentID to StudentModel

  const CheckInScreen({Key? key, required this.student}) : super(key: key);

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _handleCheckIn() async {
    try {
      // Get GPS position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Call API - safely access studentID from the widget's student model
      final result = await ApiService.checkIn(
        _codeController.text,
        widget.student.studentID,
        position.latitude,
        position.longitude,
      );

      if (!mounted) return; // Guard to prevent context calls across async gaps

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success']
                ? "Attendance Recorded"
                : "Error: ${result['message']}",
          ),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check-in failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose(); // Always clean up controllers!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Check-In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Enter Attendance Code",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleCheckIn,
              child: const Text("Check In"),
            ),
          ],
        ),
      ),
    );
  }
}
