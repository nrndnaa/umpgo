import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:umpgo_frontend/config/api.dart';

import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/domain/feerecord_model.dart';

import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

import 'package:umpgo_frontend/screens/OpenRegistration/mainOR.dart';
import 'package:umpgo_frontend/screens/curriculum/student/curriculum_menu.dart';

//import 'package:umpgo_frontend/screens/TuitionFee/payment_historystudent.dart';
//import 'package:umpgo_frontend/screens/TuitionFee/student_financial_detail.dart';

class StudentDashboard extends StatelessWidget {
  final StudentModel student;

  const StudentDashboard({super.key, required this.student});

  Future<void> _goToTuitionFee(BuildContext context) async {
    print('Dashboard Student ID = ${student.studentID}');
    print('Dashboard Matric ID = ${student.matricID}');

    try {
      // Loading Spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // API Request
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/fee-record/${student.studentID}'),
        headers: {'Accept': 'application/json'},
      );

      // Close Loading
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // SUCCESS
      if (response.statusCode == 200) {
        print(response.body);

        final fee = FeeRecord.fromJson(jsonDecode(response.body));

        /* CHECK OUTSTANDING BALANCE
        if (context.mounted) {
          if (fee.outstanding <= 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PaymentHistoryStudent(student: student, fee: fee),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    StudentFinancialDetail(student: student, fee: fee),
              ),
            );
          } 
        } */
      }
      // NO FEE RECORD
      else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fee record not found.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    // ERROR
    catch (e) {
      print(e);

      if (context.mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Welcome Text
                    Text(
                      "Welcome, ${student.name}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Banner Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        'https://www.studymalaysiainfo.com/wp-content/uploads/2016/11/Uni-Pahang-1.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tuition Fee
                    _DashCard(
                      icon: Icons.school_rounded,
                      title: "Tuition Fee",
                      onTap: () => _goToTuitionFee(context),
                    ),

                    // Open Registration
                    _DashCard(
                      icon: Icons.menu_book_rounded,
                      title: "Open Registration",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MainOR(student: student),
                          ),
                        );
                      },
                    ),

                    // Class Attendance
                    _DashCard(
                      icon: Icons.calendar_month_rounded,
                      title: "Class Attendance",
                      onTap: () {},
                    ),

                    // Curriculum
                    _DashCard(
                      icon: Icons.description_rounded,
                      title: "Curriculum",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CurriculumMenu(student: student),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

        bottomNavigationBar: const StudNav(),
    );
  }
}

// Dashboard Card Widget
class _DashCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: const Color(0xFFD6E8F8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: const Color(0xFF1E6FBF)),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}