import 'package:flutter/material.dart';

import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/domain/feerecord_model.dart';
import 'package:umpgo_frontend/domain/payment_model.dart';

import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';

class PayReceipt extends StatelessWidget {
  final StudentModel student;
  final FeeRecord fee;
  final Payment payment;

  const PayReceipt({
    super.key,
    required this.student,
    required this.fee,
    required this.payment,
  });

  static const Color primaryBlue =
      Color(0xFF1E6FBF);

  static const Color lightBlue =
      Color(0xFFD6E8F8);

  static const Color cardBg =
      Color(0xFFE8F4FD);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            const AppHeader(),

            _buildBreadcrumb(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildReceiptCard(
                  context,
                ),
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
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: const Text(
          'Menu > Tuition Fee > Receipt',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard(
      BuildContext context) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius:
            BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),

      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),

        child: Column(
          children: [

            // Student Info Box
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(
                        10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [

                  const Icon(
                    Icons.person_outline,
                    size: 40,
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Column(
                      children: [

                        Text(
                          student.matricID,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        Text(
                          student.name
                              .toUpperCase(),
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildRow(
              'Total Fee :',
              'RM${payment.amount.toStringAsFixed(2)}',
            ),

            _buildRow(
              'Date :',
              payment.paidAt
                  .substring(0, 10),
            ),

            _buildRow(
              'Semester :',
              fee.semester,
            ),

            _buildRow(
              'Payment Type :',
              payment.paymentMethod,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String title,
    String value,
  ) {

    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 12),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
        ),
      ),

      child: Row(
        children: [

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),

        ],
      ),
    );
  }
}