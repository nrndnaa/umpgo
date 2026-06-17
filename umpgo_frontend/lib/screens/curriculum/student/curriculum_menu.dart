import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'koq_module_booking.dart' hide Text;
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text(
              'Menu > Curriculum',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Welcome ${widget.student.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuCard(
                    icon: Icons.book_outlined,
                    title: 'KoQ Module Booking',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KoQModuleBooking(
                            studentID: widget.student.studentID,
                            matricID: widget.student.matricID,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'My KoQ Booking',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyKoQBooking(
                            studentID: widget.student.studentID,
                            matricID: widget.student.matricID,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    icon: Icons.assignment_outlined,
                    title: 'Credit Claim',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditClaim(
                            studentID: widget.student.studentID,
                            matricID: widget.student.matricID,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Back',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudNav(),
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5B9BD5), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: const Color(0xFF5B9BD5)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
