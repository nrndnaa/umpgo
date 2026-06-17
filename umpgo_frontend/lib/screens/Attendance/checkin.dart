import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
          ),
          StudNav(student: student),
        ],
      ),
    );
  }
}