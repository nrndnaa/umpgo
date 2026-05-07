import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/treasury_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

class TreasuryDashboard extends StatelessWidget {
   final TreasuryModel treasury;

  const TreasuryDashboard({super.key, required this.treasury});

  // Theme Colors from your image
  static const Color primaryPurple = Color(0xFFD161E9);
  static const Color lightPurple = Color(0xFFE9ADFF);
  static const Color bgGrey = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: const AppHeader(), // Using your existing header
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Irfah Misarah",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Campus Image Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://www.studymalaysiainfo.com/wp-content/uploads/2016/11/Uni-Pahang-1.jpg', // Replace with your UMPSA gate image
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Current Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Status Cards Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard("6182", "Paid"),
                _buildStatusCard("114", "Block"),
                _buildStatusCard("6296", "Total"),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              "Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Large Category Buttons
            _buildCategoryButton(
              icon: Icons.person_search, // Matches the student-with-money icon
              label: "List of Subject",
              color: lightPurple,
            ),
            const SizedBox(height: 15),

            _buildDateButton(
              date: "23.3.2026",
              semester: "Semester 2 (2025/2026)",
              label: "Set Due Date",
              color: lightPurple,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildTreasuryNav(),
    );
  }

  // Widget for the 3 small status boxes
  Widget _buildStatusCard(String count, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: primaryPurple,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the "List of Subject" button
  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.black),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget for the Date button
  Widget _buildDateButton({
    required String date,
    required String semester,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          Text(
            semester,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Custom Nav Bar for Treasury
  Widget _buildTreasuryNav() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
