import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api.dart';
import '../../domain/pusatadab_model.dart';
import 'curriculum/pusatadab/module_list.dart';
import 'curriculum/pusatadab/credit_claim_application.dart';
import '../../widgets/app_header.dart';
import '../../widgets/adab_nav.dart';

class AdabDashboard extends StatefulWidget {
  final PusatAdabModel adab;

  const AdabDashboard({
    super.key, 
    required this.adab
  });

  @override
  State<AdabDashboard> createState() => _AdabDashboardState();
}

class _AdabDashboardState extends State<AdabDashboard> {
  bool loading = false;
  int totalActivities = 0;
  int totalEnrollment = 0;
  String attendancePercentage = '0';
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
  totalActivities = int.tryParse('${data['totalActivities']}') ?? 0;
  totalEnrollment = int.tryParse('${data['totalEnrollment']}') ?? 0;
  attendancePercentage = '${data['attendancePercentage'] ?? '0'}';
  approvedClaims = int.tryParse('${data['approvedClaims']}') ?? 0;
});
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${widget.adab.name}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Staff ID: ${widget.adab.staffID}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                value: '$totalActivities',
                                label: 'Total Curriculum\nActivities',
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                value: '$totalEnrollment',
                                label: 'Total\nEnrollment',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                value: attendancePercentage,
                                label: 'Attendance\nPercentage',
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                value: '$approvedClaims',
                                label: 'Approved Credit\nClaims',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNavTile(
                          icon: Icons.assignment_outlined,
                          label: 'Module\nList',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModuleList(adab: widget.adab),
                              ),
                            ).then((_) {
                              fetchDashboardStats(); 
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNavTile(
                          icon: Icons.card_membership_outlined,
                          label: 'Credit Claim\nApplication',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreditClaimApplication(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      child: _buildNavTile(
                        icon: Icons.sports_basketball_outlined,
                        label: 'Attendance\n',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const AdabNav(), // Menggunakan AdabNav mengikut menu asal
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9C4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
<<<<<<< HEAD
=======

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
                            builder: (context) =>
                                MainOR(student: widget.student),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CurriculumMenu(student: widget.student),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            StudNav(student: widget.student),
>>>>>>> openRegistration
          ],
        ),
      ),
    );
  }
}