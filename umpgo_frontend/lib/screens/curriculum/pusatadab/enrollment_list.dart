import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';

class EnrollmentList extends StatefulWidget {
  final int moduleID;
  final String moduleName;

  const EnrollmentList({
    super.key,
    required this.moduleID,
    required this.moduleName,
  });

  @override
  State<EnrollmentList> createState() => _EnrollmentListState();
}

class _EnrollmentListState extends State<EnrollmentList> {
  bool loading = false;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchEnrollments();
  }

  void fetchEnrollments() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/modules/enrollments/${widget.moduleID}',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          students = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        children: [
          // Breadcrumb
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Menu > Module List > ${widget.moduleName} > Enrollment List',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enrollment List',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Table
          Flexible(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : students.isEmpty
                ? const Center(child: Text('No students enrolled yet'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(40),
                          1: FixedColumnWidth(100),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F5F5),
                            ),
                            children: [
                              _tableHeader('No.'),
                              _tableHeader('Matric ID'),
                              _tableHeader('Student Name'),
                            ],
                          ),
                          ...students.asMap().entries.map((entry) {
                            final index = entry.key;
                            final student = entry.value;
                            return TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              children: [
                                _tableCell('${index + 1}.'),
                                _tableCell(student['matricID'] ?? ''),
                                _tableCell(student['name'] ?? ''),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
          ),

          // Back Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
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
          ),
        ],
      ),
      bottomNavigationBar: const AdabNav(),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
