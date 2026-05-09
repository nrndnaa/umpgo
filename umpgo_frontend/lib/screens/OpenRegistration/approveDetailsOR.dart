import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

const _teal = Color(0xFF2EB88A);
const _textMuted = Color(0xFF6B7C93);

class ApproveDetailsOR extends StatefulWidget {
  final FacultyRegistrar registrar;
  final dynamic studentID;
  const ApproveDetailsOR({
    super.key,
    required this.registrar,
    required this.studentID,
  });

  @override
  State<ApproveDetailsOR> createState() => _ApproveDetailsORState();
}

class _ApproveDetailsORState extends State<ApproveDetailsOR> {
  bool _isLoading = true;
  Map<String, dynamic>? _student;
  List<Map<String, dynamic>> _enrollments = [];

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/approve-enrollment/${widget.studentID}',
            ),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _student = Map<String, dynamic>.from(data['student']);
          _enrollments = List<Map<String, dynamic>>.from(data['enrollments']);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error: $e');
    }
  }

  Future<void> _updateStatus(int enrollmentID, String status) async {
    try {
      await http
          .post(
            Uri.parse(
              '${ApiConfig.baseUrl}/approve-enrollment/$enrollmentID/update-status',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'status': status}),
          )
          .timeout(const Duration(seconds: 10));
      setState(() {
        final idx = _enrollments.indexWhere(
          (e) => e['enrollmentID'] == enrollmentID,
        );
        if (idx != -1) _enrollments[idx]['status'] = status;
      });
    } catch (e) {
      debugPrint('Error updating status: $e');
    }
  }

  Future<void> _updateAll(String status) async {
    try {
      await http
          .post(
            Uri.parse(
              '${ApiConfig.baseUrl}/approve-enrollment/${widget.studentID}/update-all',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'status': status}),
          )
          .timeout(const Duration(seconds: 10));
      setState(() {
        for (var e in _enrollments) {
          e['status'] = status;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All enrollments $status'),
          backgroundColor: status == 'Approved' ? _teal : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Menu > Approve Enrollment > ${_student?['matricID'] ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: _teal))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Approve Enrollment',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Student info table
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(100),
                                1: FlexColumnWidth(),
                              },
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              children: [
                                _tableRow(
                                  'NAME',
                                  _student?['name']?.toString().toUpperCase() ??
                                      '',
                                ),
                                _tableRow(
                                  'MATRIC ID',
                                  _student?['matricID'] ?? '',
                                ),
                                _tableRow(
                                  'COURSE',
                                  _student?['programme']
                                          ?.toString()
                                          .toUpperCase() ??
                                      '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Enrollments table
                          Container(
                            decoration: BoxDecoration(
                              color: _teal.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                // Table header
                                Row(
                                  children: const [
                                    SizedBox(
                                      width: 32,
                                      child: Text('No.', style: _headerStyle),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text('Code', style: _headerStyle),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Subject Name',
                                        style: _headerStyle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Status',
                                        style: _headerStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                ...List.generate(_enrollments.length, (i) {
                                  final e = _enrollments[i];
                                  final status = e['status'] ?? 'Pending';
                                  return Container(
                                    color: i % 2 == 0
                                        ? Colors.white
                                        : const Color(0xFFF0F0F0),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          child: Text(
                                            '${i + 1}.',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            e['subjectCode'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            e['subjectName'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child:
                                              status == 'Approved' ||
                                                  status == 'Rejected'
                                              ? Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: _statusColor(
                                                        status,
                                                      ).withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      status,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: _statusColor(
                                                          status,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    _ActionBtn(
                                                      label: 'Approve',
                                                      color: Colors.blue,
                                                      onTap: () =>
                                                          _updateStatus(
                                                            e['enrollmentID'],
                                                            'Approved',
                                                          ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    _ActionBtn(
                                                      label: 'Reject',
                                                      color: Colors.red,
                                                      onTap: () =>
                                                          _updateStatus(
                                                            e['enrollmentID'],
                                                            'Rejected',
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 8),
                                // Approve All / Reject All
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _ActionBtn(
                                      label: 'Approve All',
                                      color: Colors.blue,
                                      onTap: () => _updateAll('Approved'),
                                    ),
                                    const SizedBox(width: 8),
                                    _ActionBtn(
                                      label: 'Reject All',
                                      color: Colors.red,
                                      onTap: () => _updateAll('Rejected'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
            const RegNav(),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _textMuted,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: _textMuted,
);

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
