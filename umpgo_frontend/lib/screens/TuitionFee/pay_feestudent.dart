import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/domain/feerecord_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/config/api.dart';

enum PaymentMethod { fpx, creditDebitCard }

class PayFeeStudent extends StatefulWidget {
  final StudentModel student;
  final FeeRecord fee;

  const PayFeeStudent({
    super.key,
    required this.student,
    required this.fee,
  });

  @override
  State<PayFeeStudent> createState() => _PayFeeStudentState();
}

class _PayFeeStudentState extends State<PayFeeStudent> {

  static const Color primaryBlue = Color(0xFF1E6FBF);
  static const Color lightBlue = Color(0xFFD6E8F8);
  static const Color cardBg = Color(0xFFE8F4FD);
  static const Color payBlue = Color(0xFF42A5F5);

  PaymentMethod _selectedMethod = PaymentMethod.fpx;
  String? _selectedBank;
  bool _isPaying = false;

final TextEditingController _amountController =
    TextEditingController();
  

  final List<String> _banks = [
    'Maybank2u',
    'CIMB Clicks',
    'Public Bank',
    'RHB Now',
    'Hong Leong Connect',
    'AmOnline',
    'Bank Islam',
    'BSN',
    'Bank Rakyat',
    'UOB',
  ];

Future<void> _submitPayment() async {

  if (_selectedMethod == PaymentMethod.fpx &&
      _selectedBank == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a bank.'),
        backgroundColor: Colors.orange,
      ),
    );

    return;
  }

  final outstanding =
      widget.fee.totalFee - widget.fee.paidAmount;

  final enteredAmount =
      double.tryParse(_amountController.text) ?? 0;

  if (enteredAmount <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid payment amount'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  if (enteredAmount > outstanding) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Maximum payment amount is RM${outstanding.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  setState(() => _isPaying = true);

  try {

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/make-payment'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'studentID': widget.student.studentID,
        'feeID': widget.fee.feeID,
        'amount': enteredAmount,
        'paymentMethod':
            _selectedMethod == PaymentMethod.fpx
                ? 'FPX'
                : 'Credit/Debit Card',
        'bank': _selectedBank ?? '',
      }),
    );

    print(response.body);

    if (!mounted) return;

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data['success'] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data['message'] ?? 'Payment failed.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );

  } finally {

    if (mounted) {
      setState(() => _isPaying = false);
    }

  }
}

  @override
  Widget build(BuildContext context) {

    final outstanding =
        widget.fee.totalFee - widget.fee.paidAmount;

    return Scaffold(
      backgroundColor: Colors.white,
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
                child: _buildPaymentCard(outstanding.toDouble()),
              ),
            ),

            StudNav(student: StudentModel.empty()),

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
          'Menu > Tuition Fee > Pay Fee',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(double outstanding) {

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
            'Payment Detail',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                _buildStudentHeader(),

                const SizedBox(height: 20),

                _buildInfoRow(
                  'Name :',
                  widget.student.name.toUpperCase(),
                ),

                _buildInfoRow(
                  'Matric ID :',
                  widget.student.matricID,
                ),

                _buildInfoRow(
                  'Programme :',
                  widget.student.programme,
                ),

                _buildInfoRow(
  'Payment Total :',
  'RM${outstanding.toStringAsFixed(2)}',
),

const SizedBox(height: 16),

TextField(
  controller: _amountController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Payment Amount',
    hintText:
        'Maximum RM${outstanding.toStringAsFixed(2)}',
    border: const OutlineInputBorder(),
  ),
),

const SizedBox(height: 20),

_buildPaymentOption(),

                const SizedBox(height: 24),

                Center(
                  child: _buildPayButton(),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentHeader() {

    return Row(
      children: [

        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline,
            size: 32,
          ),
        ),

        const SizedBox(width: 16),

        Text(
          widget.student.matricID,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }

  Widget _buildInfoRow(
      String label,
      String value,
      ) {

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
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
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade300,
        ),

      ],
    );
  }

  Widget _buildPaymentOption() {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            'Payment Option :',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          RadioListTile<PaymentMethod>(
            value: PaymentMethod.fpx,
            groupValue: _selectedMethod,
            onChanged: (v) {
              setState(() {
                _selectedMethod = v!;
              });
            },
            title: const Text(
              'Internet Banking (FPX)',
            ),
          ),

          if (_selectedMethod ==
              PaymentMethod.fpx)
            DropdownButton<String>(
              value: _selectedBank,
              hint: const Text('Select Bank'),
              isExpanded: true,
              items: _banks.map((bank) {
                return DropdownMenuItem(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _selectedBank = v;
                });
              },
            ),

          RadioListTile<PaymentMethod>(
            value:
                PaymentMethod.creditDebitCard,
            groupValue: _selectedMethod,
            onChanged: (v) {
              setState(() {
                _selectedMethod = v!;
              });
            },
            title: const Text(
              'Credit / Debit Card',
            ),
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
        onPressed:
            _isPaying ? null : _submitPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: payBlue,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25),
          ),
        ),
        child: _isPaying
            ? const SizedBox(
                width: 18,
                height: 18,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Pay',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

