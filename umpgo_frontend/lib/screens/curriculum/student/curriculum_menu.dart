import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'koq_module_booking.dart';
import 'my_koq_booking.dart';
import 'credit_claim.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';

class CurriculumMenu extends StatefulWidget {
  final StudentModel student;
  const CurriculumMenu({super.key, required this.student});

  @override
  State<CurriculumMenu> createState() => _CurriculumMenuState();
}

class _CurriculumMenuState extends State<CurriculumMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF5B9BD5),
            child: const Text(
              'Menu > Curriculum',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Main Menu Content (Scrollable to prevent overflow)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  _buildMenuCard(
                    icon: Icons.book_outlined,
                    title: 'KoQ Module Booking',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KoQModuleBooking(
                          studentID: widget.student.studentID,
                          matricID: widget.student.matricID,
                          student: widget.student,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMenuCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'My KoQ Booking',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyKoQBooking(
                          studentID: widget.student.studentID,
                          matricID: widget.student.matricID,
                          student: widget.student,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMenuCard(
                    icon: Icons.assignment_outlined,
                    title: 'Credit Claim',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreditClaim(
                          studentID: widget.student.studentID,
                          matricID: widget.student.matricID,
                          student: widget.student,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Back Button
                  SizedBox(
                    width: 140,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StudNav(student: widget.student),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFD6E8F8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: const Color(0xFF5B9BD5)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
