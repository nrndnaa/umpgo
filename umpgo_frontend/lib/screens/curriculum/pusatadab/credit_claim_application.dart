import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';
import 'credit_claim_application_details.dart';

class CreditClaimApplication extends StatefulWidget {
  const CreditClaimApplication({super.key});

  @override
  State<CreditClaimApplication> createState() =>
      _CreditClaimApplicationState();
}

class _CreditClaimApplicationState extends State<CreditClaimApplication> {
  bool loading = false;
  String selectedSemester = '';
  List<String> semesters = [];
  List<Map<String, dynamic>> students = [];

  List<String> generateSemesters() {
    List<String> result = [];
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int academicYear = currentMonth >= 7 ? currentYear : currentYear - 1;
    bool isFirstSem = currentMonth >= 7 && currentMonth <= 12;

    for (int year = 2025; year <= academicYear; year++) {
      String sem1 = 'SEMESTER I ACADEMIC SESSION $year/${year + 1}';
      String sem2 = 'SEMESTER II ACADEMIC SESSION $year/${year + 1}';

      if (year < academicYear) {
        result.add(sem1);
        result.add(sem2);
      } else {
        if (isFirstSem) {
          result.add(sem1);
        } else {
          result.add(sem1);
          result.add(sem2);
        }
      }
    }
    return result.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    final generatedSemesters = generateSemesters();
    setState(() {
      semesters = generatedSemesters;
      selectedSemester = generatedSemesters.first;
    });
    fetchClaims();
  }

  void fetchClaims() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.creditClaims));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final List<Map<String, dynamic>> studentList = [];

        for (var claim in data) {
          studentList.add({
            'studentID': claim['studentID'],
            'matricID': claim['student']?['matricID'] ?? '',
            'name': claim['student']?['name'] ?? '',
            'semester': claim['semester'] ?? '',
            'totalCats': claim['totalCats'],
            'status': claim['status'],
          });
        }

        setState(() {
          students = studentList;
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

  List<Map<String, dynamic>> get filteredStudents {
    return students.where((s) => s['semester'] == selectedSemester).toList();
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
            child: const Text(
              'Menu > Credit Claim Application',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Approved Credit Application',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),

          // Semester Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedSemester.isEmpty ? null : selectedSemester,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text('Select Semester',
                    style: TextStyle(fontSize: 12)),
                items: semesters.map((semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedSemester = value!);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Student List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filteredStudents.isEmpty
                    ? const Center(child: Text('No credit claims found'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF5B9BD5)),
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
                                    color: Color(0xFFF5F5F5)),
                                children: [
                                  _tableHeader('No.'),
                                  _tableHeader('Matric ID'),
                                  _tableHeader('Student Name'),
                                ],
                              ),
                              ...filteredStudents.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.white
                                        : Colors.grey.shade50,
                                  ),
                                  children: [
                                    _tableCell('${index + 1}.'),
                                    _tableCell(student['matricID'] ?? ''),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreditClaimApplicationDetails(
                                              student: student,
                                              semester: selectedSemester,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          student['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF5B9BD5),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
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

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}