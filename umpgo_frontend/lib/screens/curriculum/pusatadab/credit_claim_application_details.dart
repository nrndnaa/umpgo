import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Uri.parse(
          '${ApiConfig.baseUrl}/modules/mybookings/${widget.student['studentID']}',
        ),
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
              'attendance': item['attendanceStatus'] ?? 'Pending',
              'totalMarks': item['totalMarks'] ?? '0%',
              'groupLink': module['groupLink'] ?? '',
              'startDate': module['startDate'] ?? '', // ← add here
              'startTime': module['startTime'] ?? '', // ← add here
              'endDate': module['endDate'] ?? '', // ← add here
              'endTime': module['endTime'] ?? '', // ← add here
            };
          }).toList();
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
                'Menu > Credit Claim Application > ${widget.student['matricID']}',
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
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Claim Credit Application',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Student Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300),
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

          const SizedBox(height: 12),

          // Activity Table
          // Activity Table
          Flexible(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : activities.isEmpty
                ? const Center(child: Text('No activities found'))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: double.infinity,
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
                          columnSpacing: 12,
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Module',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CATS',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Campus',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Venue',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Class Date',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Attendance',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Marks',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                          rows: activities.map((activity) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '${activity['code']}\n${activity['name']}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${activity['cats']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    activity['campus'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    activity['venue'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${activity['startDate']}\n${activity['startTime']}-${activity['endTime']}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.article_outlined,
                                      size: 18,
                                      color: Color(0xFF5B9BD5),
                                    ),
                                    onPressed: () =>
                                        showActivityDetails(activity),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          activity['attendance'] == 'Present' ||
                                              activity['attendance'] ==
                                                  'PRESENT'
                                          ? Colors.green
                                          : activity['attendance'] == 'Pending'
                                          ? Colors.orange
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      activity['attendance'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${activity['totalMarks']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
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

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(value, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  void showActivityDetails(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Module:', '${activity['code']} ${activity['name']}'),
              const SizedBox(height: 14),
              _detailRow(
                'Start Class Date & Time:',
                activity['startDate'] + ' ' + activity['startTime'],
              ),
              const SizedBox(height: 14),
              _detailRow(
                'End Class Date & Time:',
                activity['endDate'] + ' ' + activity['endTime'],
              ),
              const SizedBox(height: 16),
              const Text(
                'WhatsApp/Telegram Group Link',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 130,
                height: 38,
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(activity['groupLink']);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Click to Join',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: SizedBox(
                  width: 80,
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
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(value, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }
}
