import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:umpgo_frontend/config/api.dart';

import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/domain/feerecord_model.dart';
import 'package:umpgo_frontend/domain/payment_model.dart';

import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';

class PaymentHistoryStudent extends StatefulWidget {
  final StudentModel student;
  final FeeRecord fee;

  const PaymentHistoryStudent({
    super.key,
    required this.student,
    required this.fee,
  });

  @override
  State<PaymentHistoryStudent> createState() =>
      _PaymentHistoryStudentState();
}

class _PaymentHistoryStudentState
    extends State<PaymentHistoryStudent> {

  static const Color primaryBlue =
      Color(0xFF1E6FBF);

  static const Color lightBlue =
      Color(0xFFD6E8F8);

  static const Color cardBg =
      Color(0xFFE8F4FD);

  Future<List<Payment>> _loadPayments() async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/payment-history/${widget.student.studentID}',
      ),
    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data
          .map(
            (e) => Payment.fromJson(e),
          )
          .toList();
    }

    return [];
  }

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
                padding:
                    const EdgeInsets.all(20),
                child: _buildHistoryCard(),
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
          'Menu > Tuition Fee > Payment History',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius:
            BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Center(
            child: Text(
              'Student Financial History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          FutureBuilder<List<Payment>>(
            future: _loadPayments(),

            builder: (
              context,
              snapshot,
            ) {

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {

                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {

                return const Center(
                  child: Text(
                    'Failed to load payment history',
                  ),
                );
              }

              final payments =
                  snapshot.data ?? [];

              if (payments.isEmpty) {

                return const Center(
                  child: Text(
                    'No payment history found',
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,

                child: DataTable(
                  columns: const [

                    DataColumn(
                      label: Text('No'),
                    ),

                    DataColumn(
                      label: Text('Date'),
                    ),

                    DataColumn(
                      label: Text('Payment'),
                    ),

                    DataColumn(
                      label: Text('Action'),
                    ),

                  ],

                  rows: payments
                      .asMap()
                      .entries
                      .map((entry) {

                    final index =
                        entry.key + 1;

                    final payment =
                        entry.value;

                    return DataRow(
                      cells: [

                        DataCell(
                          Text(
                            index.toString(),
                          ),
                        ),

                        DataCell(
                          Text(
                            payment.paidAt
                                .substring(
                              0,
                              10,
                            ),
                          ),
                        ),

                        DataCell(
                          Text(
                            'RM${payment.amount.toStringAsFixed(2)}',
                          ),
                        ),

                        DataCell(
                          ElevatedButton(
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors.green,
                            ),

                            onPressed: () {

                              showDialog(
                                context:
                                    context,

                                builder: (_) =>
                                    AlertDialog(
                                  title:
                                      const Text(
                                    'Payment Detail',
                                  ),

                                  content:
                                      Column(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,

                                    children: [

                                      Text(
                                        'Amount: RM${payment.amount.toStringAsFixed(2)}',
                                      ),

                                      Text(
                                        'Method: ${payment.paymentMethod}',
                                      ),

                                      Text(
                                        'Status: ${payment.paymentStatus}',
                                      ),

                                      Text(
                                        'Date: ${payment.paidAt}',
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },

                            child:
                                const Text(
                              'View',
                            ),
                          ),
                        ),

                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}