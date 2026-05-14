import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/domain/feerecord_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/screens/TuitionFee/pay_feestudent.dart';

class StudentFinancialDetail extends StatefulWidget {
  final StudentModel student;
  final FeeRecord fee;

  const StudentFinancialDetail({
    super.key,
    required this.student,
    required this.fee,
  });

  @override
  State<StudentFinancialDetail> createState() =>
      _StudentFinancialDetailState();
}

class _StudentFinancialDetailState
    extends State<StudentFinancialDetail> {

  static const Color primaryBlue = Color(0xFF1E6FBF);
  static const Color lightBlue = Color(0xFFD6E8F8);
  static const Color bgWhite = Colors.white;
  static const Color cardBg = Color(0xFFE8F4FD);
  static const Color dueYellow = Color(0xFFFFD700);
  static const Color payBlue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {

    final outstanding =
        widget.fee.totalFee - widget.fee.paidAmount;

    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: Column(
          children: [

            const AppHeader(),

            _buildBreadcrumb(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: _buildDetailCard(outstanding),
              ),
            ),

            const StudNav(),

          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Container(
      width: double.infinity,
      color: primaryBlue,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Menu > Tuition Fee',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(double outstanding) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Column(
        children: [

          const Text(
            'Student Financial Detail',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgWhite,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              children: [

                const Text(
                  'NAME:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.student.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'COURSE: ${widget.student.programme}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                _buildDueBadge('31 July 2026'),

                const SizedBox(height: 20),

                _buildFeeRow(
                  'Total Fee :',
                  'RM${widget.fee.totalFee.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 10),

                _buildFeeRow(
                  'Paid Amount :',
                  'RM${widget.fee.paidAmount.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 10),

                _buildFeeRow(
                  'Outstanding Balance :',
                  'RM${outstanding.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 10),

                _buildFeeRow(
                  'Semester :',
                  widget.fee.semester,
                ),

                const SizedBox(height: 24),

                _buildPayButton(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueBadge(String dueDate) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: dueYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Due : $dueDate',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, String value) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(value),
          ),

        ],
      ),
    );
  }

  Widget _buildPayButton() {

    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PayFeeStudent(
                student: widget.student,
                fee: widget.fee,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: payBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Pay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}