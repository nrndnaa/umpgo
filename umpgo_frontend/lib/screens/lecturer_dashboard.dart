import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/lecturer_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/screens/Attendance/attendanceMenu.dart';

class LecturerDashboard extends StatelessWidget {
  final Lecturer lecturer;
  const LecturerDashboard({super.key, required this.lecturer});

  static const Color primaryOrange = Color(0xFFFFD18E);
  static const Color bgGrey = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${lecturer.name}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://www.studymalaysiainfo.com/wp-content/uploads/2016/11/Uni-Pahang-1.jpg',
                height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 25),
            const Text("Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => AttendanceMenu(
                  userID: lecturer.lecturerID,
                  userName: lecturer.name,
                  isAdab: false,
                ),
              )),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: primaryOrange,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                      blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_2, size: 60, color: Colors.black87),
                    const SizedBox(height: 10),
                    const Text("Attendance",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Recent Updates",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildUpdateItem("New student registration for BCN3023"),
                  const Divider(color: Colors.white54),
                  _buildUpdateItem("Semester II schedule updated"),
                  const Divider(color: Colors.white54),
                  _buildUpdateItem("Meeting with Treasury scheduled for 3PM"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildLecturerNav(context),
    );
  }

  Widget _buildUpdateItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildLecturerNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: primaryOrange,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home_rounded, size: 28),
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst)),
          IconButton(icon: const Icon(Icons.grid_view_rounded, size: 28),
              onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 28),
              onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline_rounded, size: 28),
              onPressed: () {}),
        ],
      ),
    );
  }
}