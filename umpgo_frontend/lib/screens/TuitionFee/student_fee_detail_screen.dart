import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

// ── Model ────────────────────────────────────────────────────────────────────

class StudentFeeDetail {
  final String matricId;
  final String name;
  final double totalFee;
  final double paidAmount;
  final double outstandingBalance;
  final String date;
  final String semester;

  const StudentFeeDetail({
    required this.matricId,
    required this.name,
    required this.totalFee,
    required this.paidAmount,
    required this.outstandingBalance,
    required this.date,
    required this.semester,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────

class StudentFeeDetailScreen extends StatelessWidget {
  final StudentFeeDetail detail;

  const StudentFeeDetailScreen({super.key, required this.detail});

  static const Color primaryPurple = Color(0xFFD161E9);
  static const Color lightPurple = Color(0xFFE9ADFF);
  static const Color bgGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFF8EEFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: const AppHeader(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Student identity card ──────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 42, color: Colors.black54),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.matricId,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            detail.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Fee detail rows ────────────────────────────────────────
                _buildDetailRow(
                  'Total Fee :',
                  'RM${detail.totalFee.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  'Paid Amount :',
                  'RM ${detail.paidAmount.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  'Outstanding Balance :',
                  'RM ${detail.outstandingBalance.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 10),
                _buildDetailRow('Date :', detail.date),
                const SizedBox(height: 10),
                _buildDetailRow('Semester', ': ${detail.semester}'),

                const SizedBox(height: 28),

                // ── Back button ────────────────────────────────────────────
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildNav(context),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryPurple.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
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
            icon: const Icon(Icons.home, size: 30, color: Colors.black),
            onPressed: () => Navigator.pop(context),
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
