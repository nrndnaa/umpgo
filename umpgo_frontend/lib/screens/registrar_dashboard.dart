import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart'; // Reusing header

// ── Colors from Registrar Image ──────────────────────────────────────────────
const _registrarMint = Color(0xFFA8E6CF); // Main background for cards/nav
const _registrarBg = Colors.white;

class RegistrarDashboard extends StatelessWidget {
   final FacultyRegistrar registrar;

  const RegistrarDashboard({super.key, required this.registrar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _registrarBg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(), // Your existing header
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
                      "Welcome,  Sarah Adlyn",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Banner ────────────────────────────────────────────────
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

                    // ── Registrar Service Cards ───────────────────────────────
                    _RegistrarCard(
                      icon: Icons.calendar_today_rounded,
                      title: "Registration Schedule",
                      onTap: () {},
                    ),
                    _RegistrarCard(
                      icon: Icons.menu_book_rounded,
                      title: "List of Subject",
                      onTap: () {},
                    ),
                    _RegistrarCard(
                      icon: Icons.assignment_turned_in_outlined,
                      title: "Student Registration Status",
                      onTap: () {},
                    ),
                    _RegistrarCard(
                      icon: Icons.how_to_reg_rounded,
                      title: "Approve Enrollment",
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const RegNav(), // Your existing nav (styled with teal in your widgets)
          ],
        ),
      ),
    );
  }
}

// ── Registrar Card Component ─────────────────────────────────────────────────
class _RegistrarCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _RegistrarCard({
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
        color: _registrarMint, // Teal/Mint color from your image
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon styling to match the illustrated look
                Icon(icon, size: 55, color: Colors.blueGrey[800]),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
