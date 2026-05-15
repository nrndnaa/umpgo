import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/pusatadab_model.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';

class AdabDashboard extends StatelessWidget {
  final PusatAdabModel adab;

  const AdabDashboard({super.key, required this.adab});

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
                          label: 'Module List',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ModuleList(adab: widget.adab),
                              ),
                            );
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
                                builder: (context) =>
                                    const CreditClaimApplication(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNavTile(
                          icon: Icons.sports_basketball_outlined,
                          label: 'Attendance',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coming soon!')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Open Registration is for students only.",
                            ),
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

            // Bottom Navigation (YOUR stud_nav.dart)
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
          child: SizedBox(
            height: 90,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: const Color(0xFF0B4C8C)),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
