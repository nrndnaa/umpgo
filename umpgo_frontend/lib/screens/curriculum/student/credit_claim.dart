import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';
<<<<<<< Updated upstream
=======
import 'package:umpgo_frontend/domain/student_model.dart';
>>>>>>> Stashed changes

class CreditClaim extends StatefulWidget {
  final int studentID;
  final String matricID;
<<<<<<< Updated upstream
=======
  final StudentModel student;

>>>>>>> Stashed changes
  const CreditClaim({
    super.key,
    required this.studentID,
    required this.matricID,
<<<<<<< Updated upstream
=======
    required this.student,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
      final bookingsResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/modules/mybookings/${widget.studentID}'),
      );
      final claimResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/creditclaim/student/${widget.studentID}'),
      );
      if (bookingsResponse.statusCode == 200) {
        final List data = jsonDecode(bookingsResponse.body);
        int cats = 0;
        for (var item in data) {
          if (item['attendanceStatus'] == 'PRESENT') {
            cats += item['module']['catsPoint'] as int? ?? 0;
          }
        }
        setState(() => totalCats = cats);
      }
      if (claimResponse.statusCode == 200) {
        setState(() => alreadyClaimed = true);
      }
    } catch (e) {
      debugPrint('Error: $e');
>>>>>>> Stashed changes
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
          content: Text('Minimum 8 CATS required.\nYour current CATS: $totalCats'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
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
<<<<<<< Updated upstream
=======
        actionsAlignment: MainAxisAlignment.center,
>>>>>>> Stashed changes
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
<<<<<<< Updated upstream
            child: const Text('Cancel'),
=======
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Credit Claim Submitted Successfully!'),
                        backgroundColor: Colors.green,
=======
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Success!'),
                        content: const Text('Credit Claim Completed Successfully!', textAlign: TextAlign.center),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
                            child: const Text('OK', style: TextStyle(color: Colors.white)),
                          ),
                        ],
>>>>>>> Stashed changes
                      ),
                    );
                  }
                } else {
                  final error = jsonDecode(response.body);
                  if (mounted) {
<<<<<<< Updated upstream
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error['message'] ?? 'Failed!'),
                        backgroundColor: Colors.red,
=======
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Failed!', textAlign: TextAlign.center),
                        content: Text(error['message'] ?? 'Failed!', textAlign: TextAlign.center),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('OK', style: TextStyle(color: Colors.white)),
                          ),
                        ],
>>>>>>> Stashed changes
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
<<<<<<< Updated upstream
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
=======
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
=======
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
>>>>>>> Stashed changes
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Claim Credit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
<<<<<<< Updated upstream

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
=======
          Flexible(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        border: TableBorder(bottom: BorderSide(color: Colors.grey.shade300, width: 2)),
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF5F5F5)),
                        columnSpacing: 12,
                        columns: const [
                          DataColumn(label: Text('No', style: TextStyle(fontSize: 11))),
                          DataColumn(label: Text('Subject Code', style: TextStyle(fontSize: 11))),
                          DataColumn(label: Text('Subject Name', style: TextStyle(fontSize: 11))),
                          DataColumn(label: Text('Status', style: TextStyle(fontSize: 11))),
                          DataColumn(label: Text('Action', style: TextStyle(fontSize: 11))),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text('1', style: TextStyle(fontSize: 12))),
                            const DataCell(Text('UQA2002', style: TextStyle(fontSize: 12))),
                            const DataCell(Text('Ko-Kurikulum', style: TextStyle(fontSize: 12))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
>>>>>>> Stashed changes
                                decoration: BoxDecoration(
                                  color: alreadyClaimed ? Colors.green : totalCats >= 8 ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  alreadyClaimed ? 'Completed' : totalCats >= 8 ? 'Completed' : 'Not Completed',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              ElevatedButton(
                                onPressed: alreadyClaimed ? null : requestClaim,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: alreadyClaimed ? Colors.grey : totalCats >= 8 ? Colors.green : Colors.red,
                                  disabledBackgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                child: const Text('Request\nClaim Credit', style: TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
                              ),
                            ),
<<<<<<< Updated upstream
                          ],
                        ),
                      ],
=======
                          ]),
                        ],
                      ),
>>>>>>> Stashed changes
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
<<<<<<< Updated upstream
      bottomNavigationBar: const StudNav(),
=======
      bottomNavigationBar: StudNav(student: widget.student),
>>>>>>> Stashed changes
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
    );
  }
}