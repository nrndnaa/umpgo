import 'package:flutter/material.dart';
<<<<<<< Updated upstream
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
=======
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'codeEntry.dart';

class CheckIn extends StatelessWidget {
  final StudentModel student;
  final String subjectName;
  final String subjectCode;
  final int? sectionID;
  final int? moduleID;
  final bool isKoko;

  const CheckIn({
    Key? key,
    required this.student,
    required this.subjectName,
    required this.subjectCode,
    this.sectionID,
    this.moduleID,
    this.isKoko = false,
  }) : super(key: key);
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(title: const Text("Attendance Check-In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Enter Attendance Code"),
=======
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text('Menu > Attendance',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CodeEntry(
                      student: student,
                      subjectName: subjectName,
                      subjectCode: subjectCode,
                      sectionID: sectionID,
                      moduleID: moduleID,
                      isKoko: isKoko,
                    )),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF5B9BD5).withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 64),
                        SizedBox(height: 16),
                        Text('Check In',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                color: Color(0xFF5B9BD5))),
                        SizedBox(height: 6),
                        Text('Enter 6-digit code from lecturer',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
>>>>>>> Stashed changes
            ),
          ),
          StudNav(student: student),
        ],
      ),
    );
  }
}