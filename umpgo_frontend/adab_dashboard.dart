import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api.dart';
import '../../domain/pusatadab_model.dart';
import 'curriculum/pusatadab/module_list.dart';
import 'curriculum/pusatadab/credit_claim_application.dart';
import '../../widgets/app_header.dart';
import '../../widgets/adab_nav.dart';
import 'package:umpgo_frontend/domain/student_model.dart';

class AdabDashboard extends StatefulWidget {
  final PusatAdabModel adab;
  final StudentModel student;
  const AdabDashboard({super.key, required this.adab, required this.student});
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
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/dashboard/stats'));
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
                  Text('Welcome, ${widget.adab.name}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Staff ID: ${widget.adab.staffID}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
                        Row(children: [
                          Expanded(child: _buildStatItem(value: '$totalActivities', label: 'Total Curriculum\nActivities')),
                          Expanded(child: _buildStatItem(value: '$totalEnrollment', label: 'Total\nEnrollment')),
                        ]),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(child: _buildStatItem(value: attendancePercentage, label: 'Attendance\nPercentage')),
                          Expanded(child: _buildStatItem(value: '$approvedClaims', label: 'Approved Credit\nClaims')),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildNavTile(
                      icon: Icons.assignment_outlined, label: 'Module\nList',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ModuleList(adab: widget.adab))).then((_) => fetchDashboardStats()),
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _buildNavTile(
                      icon: Icons.card_membership_outlined, label: 'Credit Claim\nApplication',
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const CreditClaimApplication())),
                    )),
                  ]),
                  const SizedBox(height: 16),
                  Center(child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    child: _buildNavTile(
                      icon: Icons.sports_basketball_outlined, label: 'Attendance\n',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon!'))),
                    ),
                  )),
                ],
              ),
            ),
      bottomNavigationBar: const AdabNav(),
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      Text(label, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildNavTile({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9C4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 48, color: Colors.black87),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}