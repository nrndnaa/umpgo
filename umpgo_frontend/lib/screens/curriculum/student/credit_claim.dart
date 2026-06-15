import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';
import 'package:umpgo_frontend/domain/student_model.dart'; // ← add this

class CreditClaim extends StatefulWidget {
  final int studentID;
  final String matricID;
<<<<<<< HEAD
=======
  final StudentModel student;
>>>>>>> openRegistration
  const CreditClaim({
    super.key,
    required this.studentID,
    required this.matricID,
<<<<<<< HEAD
=======
    required this.student,
>>>>>>> openRegistration
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
<<<<<<< HEAD
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
        Uri.parse(
          '${ApiConfig.baseUrl}/modules/mybookings/${widget.studentID}',
        ),
      );

      final claimResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/creditclaim/student/${widget.studentID}',
        ),
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
>>>>>>> openRegistration
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
        actionsAlignment: MainAxisAlignment.center, // ← add this
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9BD5), // ← same colour
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
                  body: jsonEncode({'studentID': widget.studentID}),
                );
                if (response.statusCode == 200) {
                  setState(() => alreadyClaimed = true);
                  if (mounted) {
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Success!'),
                        content: const Text(
                          'Credit Claim Completed Successfully!',textAlign: TextAlign.center,
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
<<<<<<< HEAD
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
=======
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
>>>>>>> openRegistration
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B9BD5)),
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
<<<<<<< HEAD
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
=======
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
>>>>>>> openRegistration
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

          Flexible(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: double.infinity,
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
                        columnSpacing: 12,
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
                            label: Text(
                              'Status',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                              style: TextStyle(fontSize: 11),
                            ),
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
                                        ? Colors
                                              .green // ← claimed = green
                                        : totalCats >= 8
                                        ? Colors
                                              .green // ← cats >= 8 = green
                                        : Colors.red, // ← cats < 8 = red
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    alreadyClaimed
                                        ? 'Completed'
                                        : totalCats >= 8
                                        ? 'Completed' // ← cats >= 8 = Completed
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
                                  onPressed: alreadyClaimed
                                      ? null
                                      : requestClaim,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: alreadyClaimed
                                        ? Colors
                                              .grey // ← claimed = grey
                                        : totalCats >= 8
                                        ? Colors
                                              .green // ← cats >= 8 = green
                                        : Colors.red,
                                    disabledBackgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 19,
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
<<<<<<< HEAD
=======
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
>>>>>>> openRegistration
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
<<<<<<< HEAD
      bottomNavigationBar: const StudNav(),
=======
      bottomNavigationBar: StudNav(student: widget.student),
>>>>>>> openRegistration
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
