import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';

class CreditClaim extends StatefulWidget {
  final int studentID;
  final String matricID;
  const CreditClaim({
    super.key,
    required this.studentID,
    required this.matricID,
  });
  @override
  State<CreditClaim> createState() => _CreditClaimState();
}

class _CreditClaimState extends State<CreditClaim> {
  bool loading = false;
  int totalCats = 0;
  bool alreadyClaimed = false;

  @override
  void initState() {
    super.initState();
    fetchClaimStatus();
  }

  void fetchClaimStatus() async {
    setState(() => loading = true);
    try {
      // Get claim status
      final claimResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/creditclaim/student/${widget.studentID}',
        ),
      );

      // Get total CATS from backend
      final catsResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/creditclaim/cats/${widget.studentID}'),
      );

      if (claimResponse.statusCode == 200) {
        setState(() => alreadyClaimed = true);
      }

      if (catsResponse.statusCode == 200) {
        final data = jsonDecode(catsResponse.body);
        setState(() => totalCats = int.parse(data['totalCats'].toString()));
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void requestClaim() async {
    if (totalCats < 8) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Credit Claim Not Allowed'),
          content: Text(
            'Minimum 8 CATS required.\nYour current CATS: $totalCats',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B9BD5),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Credit Claim'),
        content: const Text('Are you sure you want to submit credit claim?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await http.post(
                  Uri.parse(ApiConfig.submitClaim),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'studentID': widget.studentID}),
                );
                if (response.statusCode == 200) {
                  setState(() => alreadyClaimed = true);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Credit Claim Submitted Successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  final error = jsonDecode(response.body);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error['message'] ?? 'Failed!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text(
              'Menu > Curriculum > Claim Credit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Claim Credit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Table(
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(35),
                        1: FixedColumnWidth(80),
                        2: FlexColumnWidth(),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(120),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F1FA),
                          ),
                          children: [
                            _tableHeader('No'),
                            _tableHeader('Subject\nCode'),
                            _tableHeader('Subject Name'),
                            _tableHeader('Status'),
                            _tableHeader('Action'),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '1',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'UQA2002',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Ko-Kurikulum',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: alreadyClaimed
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  alreadyClaimed
                                      ? 'Completed'
                                      : 'Not Completed',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: ElevatedButton(
                                onPressed: alreadyClaimed ? null : requestClaim,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5B9BD5),
                                  disabledBackgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Request\nClaim Credit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudNav(),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
