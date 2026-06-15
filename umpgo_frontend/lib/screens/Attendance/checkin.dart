import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:umpgo_frontend/services/api_services.dart';

class CheckInScreen extends StatefulWidget {
  final int studentID;

  const CheckInScreen({Key? key, required this.studentID}) : super(key: key);

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _handleCheckIn() async {
    try {
      // Get GPS position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Call API
      final result = await ApiService.checkIn(
        _codeController.text,
        widget.studentID,
        position.latitude,
        position.longitude,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['success']
              ? "Attendance Recorded"
              : "Error: ${result['message']}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Check-in failed: $e")),
      );
    }
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
              decoration: const InputDecoration(labelText: "Enter Attendance Code"),
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