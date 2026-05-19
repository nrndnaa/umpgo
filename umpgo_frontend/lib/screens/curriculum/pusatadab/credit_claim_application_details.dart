import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';

class CreditClaimApplicationDetails extends StatefulWidget {
  final Map<String, dynamic> student;
  final String semester;

  const CreditClaimApplicationDetails({
    super.key,
    required this.student,
    required this.semester,
  });

  @override
  State<CreditClaimApplicationDetails> createState() =>
      _CreditClaimApplicationDetailsState();
}

class _CreditClaimApplicationDetailsState
    extends State<CreditClaimApplicationDetails> {
  bool loading = false;
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  void fetchActivities() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/modules/mybookings/${widget.student['studentID']}'),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          activities = data.map((item) {
            final module = item['module'] ?? {};
            return {
              'code': module['code'] ?? '',
              'name': module['name'] ?? '',
              'cats': module['catsPoint'] ?? 2,
              'campus': module['campus'] ?? '',
              'venue': module['venue'] ?? '',
              'classDate': '${module['startDate'] ?? ''}\n${module['startTime'] ?? ''}-${module['endTime'] ?? ''}',
              'attendance': item['attendanceStatus'] ?? 'Pending',
              'totalMarks': item['totalMarks'] ?? '0%',
            };
          }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFFD700),
            child: Text(
              'Menu > Credit Claim Application > ${widget.student['matricID']}',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Claim Credit Application',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),

          // Student Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                },
                children: [
                  _infoRow('NAME', widget.student['name'] ?? ''),
                  _infoRow('MATRIC ID', widget.student['matricID'] ?? ''),
                  _infoRow('SEMESTER', widget.semester),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Activity Table
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : activities.isEmpty
                    ? const Center(child: Text('No activities found'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF5F5F5)),
                            border: TableBorder.all(color: Colors.grey.shade300),
                            columnSpacing: 12,
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.black,
                            ),
                            columns: const [
                              DataColumn(label: Text('Module')),
                              DataColumn(label: Text('CATS')),
                              DataColumn(label: Text('Campus')),
                              DataColumn(label: Text('Venue')),
                              DataColumn(label: Text('Class Date')),
                              DataColumn(label: Text('Attendance')),
                              DataColumn(label: Text('Total Marks')),
                            ],
                            rows: activities.map((activity) {
                              return DataRow(cells: [
                                DataCell(Text(
                                  '${activity['code']}\n${activity['name']}',
                                  style: const TextStyle(fontSize: 10),
                                )),
                                DataCell(Text(
                                  '${activity['cats']}',
                                  style: const TextStyle(fontSize: 10),
                                )),
                                DataCell(Text(
                                  activity['campus'],
                                  style: const TextStyle(fontSize: 10),
                                )),
                                DataCell(Text(
                                  activity['venue'],
                                  style: const TextStyle(fontSize: 10),
                                )),
                                DataCell(Text(
                                  activity['classDate'],
                                  style: const TextStyle(fontSize: 10),
                                )),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: activity['attendance'] == 'Present' ||
                                              activity['attendance'] == 'PRESENT'
                                          ? Colors.green
                                          : activity['attendance'] == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      activity['attendance'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 9),
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  activity['totalMarks'],
                                  style: const TextStyle(fontSize: 10),
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
          ),

          // Back Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdabNav(),
    );
  }

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}