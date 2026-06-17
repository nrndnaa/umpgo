import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../../config/api.dart';
import '../../../domain/student_model.dart';
import 'credit_claim.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';

class MyKoQBooking extends StatefulWidget {
  final StudentModel student;
  const MyKoQBooking({super.key, required this.student});
  @override
  State<MyKoQBooking> createState() => _MyKoQBookingState();
}

class _MyKoQBookingState extends State<MyKoQBooking> {
  bool loading = false;
  List<Map<String, dynamic>> bookedModules = [];

  @override
  void initState() {
    super.initState();
    fetchMyBookings();
  }

  void fetchMyBookings() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/modules/mybookings/${widget.student.studentID}',
        ),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          List<Map<String, dynamic>> result = [];
          for (var item in data) {
            final module = item['module'] ?? {};
            result.add({
              'moduleID': item['moduleID'],
              'code': module['code'] ?? '',
              'name': module['name'] ?? '',
              'cats': module['catsPoint'] ?? 2,
              'campus': module['campus'] ?? '',
              'venue': module['venue'] ?? '',
              'classDate':
                  '${module['startDate'] ?? ''}\n${module['startTime'] ?? ''}-${module['endTime'] ?? ''}',
              'startDate': module['startDate'] ?? '',
              'startTime': module['startTime'] ?? '',
              'endDate': module['endDate'] ?? '',
              'endTime': module['endTime'] ?? '',
              'attendance': item['attendanceStatus'] ?? 'Pending',
              'totalMarks': item['totalMarks'] ?? '0%',
              'groupLink': module['groupLink'] ?? '',
            });
          }
          bookedModules = result;
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

  void showModuleDetails(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                _detailRow('Module:', module['name']),
                const SizedBox(height: 14),
                _detailRow(
                  'Start Class Date & Time:',
                  '${module['startDate']} ${module['startTime']}',
                ),
                const SizedBox(height: 14),
                _detailRow(
                  'End Class Date & Time:',
                  '${module['endDate']} ${module['endTime']}',
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
                      final url = Uri.parse(module['groupLink']);
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Click to Join',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: SizedBox(
                    width: 80,
                    height: 35,
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
        );
      },
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
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
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
                "Menu > Curriculum > My KoQ Booking",
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
                'Booked Modules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : bookedModules.isEmpty
                ? const Center(child: Text('No booked modules found'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
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
                            label: Text(
                              'Module',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          DataColumn(
                            label: Text('CATS', style: TextStyle(fontSize: 11)),
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
                        rows: bookedModules.map((module) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  '${module['code']}\n${module['name']}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${module['cats']}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Text(
                                  module['campus'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Text(
                                  module['venue'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Text(
                                  module['classDate'],
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
                                  onPressed: () => showModuleDetails(module),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        module['attendance'] == 'Present' ||
                                            module['attendance'] == 'PRESENT'
                                        ? Colors.green
                                        : module['attendance'] == 'Pending'
                                        ? Colors.orange
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    module['attendance'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  module['totalMarks'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreditClaim(student: widget.student),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Go to Credit Claim >',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 150,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DA3FF),
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StudNav(student: widget.student),
    );
  }
}
