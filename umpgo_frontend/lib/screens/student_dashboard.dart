import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'OpenRegistration/mainOR.dart';
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Matches the clean white background in the image
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(), // Your existing header widget
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Welcome Text ──────────────────────────────────────────
                    const Text(
                      "Welcome, Nurin Irdina",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Campus Banner ─────────────────────────────────────────
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

                    // ── Service Cards ─────────────────────────────────────────
                    _DashCard(
                      icon: Icons.school_rounded,
                      title: "Tuition Fee",
                      onTap: () {},
                    ),
                    _DashCard(
                      icon: Icons.menu_book_rounded,
                      title: "Open Registration",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MainOR()),
                      ),
                    ),
<<<<<<< Updated upstream
                    _DashCard(
                      icon: Icons.calendar_month_rounded,
                      title: "Class Attendance",
                      onTap: () {},
                    ),
=======

>>>>>>> Stashed changes
                    _DashCard(
                      icon: Icons.description_rounded,
                      title: "Curriculum",
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const StudNav(), // Your existing navigation widget
          ],
        ),
      ),
    );
  }
}

// ── Reusable Card (Updated for the Vertical Image Style) ──────────────────────
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
        color: const Color(0xFFD6E8F8), // The light blue from the image
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
                // For exact match with image_65fcc1.jpg, replace 'Icon' with 'Image.asset'
                // once you have the specific 3D-style PNGs
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
