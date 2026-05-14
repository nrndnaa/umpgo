import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/domain/pusatadab_model.dart';
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'OpenRegistration/mainOR.dart';

class AdabDashboard extends StatefulWidget {
  final PusatAdabModel adab;
  const AdabDashboard({super.key, required this.adab});

  @override
  State<AdabDashboard> createState() => _AdabDashboardState();
}

class _AdabDashboardState extends State<AdabDashboard> {
  bool loading = false;
  int totalActivities = 0;
  int totalEnrollment = 0;
  String attendancePercentage = '0%';
  int approvedClaims = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardStats();
  }

  void fetchDashboardStats() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard/stats'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalActivities = data['totalActivities'];
          totalEnrollment = data['totalEnrollment'];
          attendancePercentage = data['attendancePercentage'];
          approvedClaims = data['approvedClaims'];
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.person_outline, size: 28),
                  Icon(Icons.school, size: 34, color: Color(0xFF0B4C8C)),
                  Icon(Icons.menu, size: 30),
                ],
              ),
            ),

            // Welcome text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome, Nurin Irdina",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue[200],
                ),
                child: const Center(
                  child: Text(
                    "UMPGo Banner",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DashboardCard(
                      icon: Icons.account_balance_wallet,
                      title: "Tuition Fee",
                      onTap: () {},
                    ),
                    DashboardCard(
                      icon: Icons.menu_book,
                      title: "Open Registration",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainOR(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      icon: Icons.calendar_month,
                      title: "Class Attendance",
                      onTap: () {},
                    ),
                    DashboardCard(
                      icon: Icons.assignment,
                      title: "Curriculum",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const StudNav(),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFD8F1FF),
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            // ← moved child here
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.black87),
                const SizedBox(height: 8),
                Text(
                  title, // ← was `label` (undefined)
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
