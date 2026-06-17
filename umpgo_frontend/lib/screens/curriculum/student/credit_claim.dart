import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../domain/student_model.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';

class CreditClaim extends StatefulWidget {
  final StudentModel student;
  const CreditClaim({super.key, required this.student});
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
      final claimResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/creditclaim/student/${widget.student.studentID}',
        ),
      );

      final catsResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/creditclaim/cats/${widget.student.studentID}',
        ),
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
    final pageContext = context;
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
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9BD5),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await http.post(
                  Uri.parse(ApiConfig.submitClaim),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'studentID': widget.student.studentID}),
                );
                if (response.statusCode == 200) {
                  setState(() => alreadyClaimed = true);
                  if (mounted) {
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Success!'),
                        content: const Text(
                          'Credit Claim Completed Successfully!',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B9BD5),
                            ),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  final error = jsonDecode(response.body);
                  if (mounted) {
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Failed!',
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          error['message'] ?? 'Failed!',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  showDialog(
                    context: pageContext,
                    builder: (context) => AlertDialog(
                      title: const Text('Error!', textAlign: TextAlign.center),
                      content: Text('Error: $e', textAlign: TextAlign.center),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9BD5),
            ),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF5B9BD5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Menu > Curriculum > Claim Credit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
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
          loading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFF5F5F5),
                      ),
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(
                          label: Text('No', style: TextStyle(fontSize: 11)),
                        ),
                        DataColumn(
                          label: Text(
                            'Subject Code',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Subject Name',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        DataColumn(
                          label: Text('Status', style: TextStyle(fontSize: 11)),
                        ),
                        DataColumn(
                          label: Text('Action', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            const DataCell(
                              Text('1', style: TextStyle(fontSize: 12)),
                            ),
                            const DataCell(
                              Text('UQA2002', style: TextStyle(fontSize: 12)),
                            ),
                            const DataCell(
                              Text(
                                'Ko-Kurikulum',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: alreadyClaimed
                                      ? Colors.green
                                      : totalCats >= 8
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  alreadyClaimed
                                      ? 'Completed'
                                      : totalCats >= 8
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
                            DataCell(
                              ElevatedButton(
                                onPressed: alreadyClaimed ? null : requestClaim,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: alreadyClaimed
                                      ? Colors.grey
                                      : totalCats >= 8
                                      ? Colors.green
                                      : Colors.red,
                                  disabledBackgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
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
      bottomNavigationBar: StudNav(student: widget.student),
    );
  }
}
