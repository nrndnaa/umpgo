import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SetDueDateScreen extends StatefulWidget {
  const SetDueDateScreen({super.key});

  @override
  State<SetDueDateScreen> createState() => _SetDueDateScreenState();
}

class _SetDueDateScreenState extends State<SetDueDateScreen> {
  static const Color primaryPurple = Color(0xFFD161E9);
  static const Color lightPurple = Color(0xFFE9ADFF);
  static const Color bgGrey = Color(0xFFF5F5F5);

  // Dropdown state
  String _selectedSemester = '2 (2025/2026)';
  int _selectedDay = 23;
  int _selectedMonth = 3;
  int _selectedYear = 2026;
  String _selectedBlock = 'Automatic Block';

  final List<String> _semesters = [
    '1 (2025/2026)',
    '2 (2025/2026)',
    '1 (2026/2027)',
  ];

  final List<String> _blockOptions = [
    'Automatic Block',
    'Manual Block',
    'No Block',
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: lightPurple, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Semester ---
              const Text('Semester',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedSemester,
                items: _semesters,
                displayText: (s) => s,
                onChanged: (val) => setState(() => _selectedSemester = val!),
              ),
              const SizedBox(height: 20),

              // --- Date ---
              const Text('Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Day
                  Expanded(
                    child: _buildDropdown<int>(
                      value: _selectedDay,
                      items: List.generate(31, (i) => i + 1),
                      displayText: (d) => d.toString(),
                      onChanged: (val) => setState(() => _selectedDay = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Month
                  Expanded(
                    child: _buildDropdown<int>(
                      value: _selectedMonth,
                      items: List.generate(12, (i) => i + 1),
                      displayText: (m) => m.toString(),
                      onChanged: (val) => setState(() => _selectedMonth = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Year
                  Expanded(
                    flex: 2,
                    child: _buildDropdown<int>(
                      value: _selectedYear,
                      items: [2025, 2026, 2027],
                      displayText: (y) => y.toString(),
                      onChanged: (val) => setState(() => _selectedYear = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Block ---
              const Text('Block',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedBlock,
                items: _blockOptions,
                displayText: (b) =>
                    b == 'Automatic Block' ? 'Automatic Block   (Default)' : b,
                onChanged: (val) => setState(() => _selectedBlock = val!),
              ),
              const SizedBox(height: 40),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSetDueDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Set Due Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildTreasuryNav(),
    );
  }

  // Reusable styled dropdown
  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          dropdownColor: const Color(0xFFF3E0FF),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(displayText(item)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

 Future<void> _handleSetDueDate() async {
  setState(() => _isLoading = true);

  final dueDate =
      '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';

  try {

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/set-due-date'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'semester': _selectedSemester,
        'dueDate': dueDate,
        'blockType': _selectedBlock,
      }),
    );

    if (response.statusCode == 201) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Due date set successfully!'),
            backgroundColor: Color(0xFFD161E9),
          ),
        );

        Navigator.pop(context);
      }

    } else {

      throw Exception(response.body);

    }

  } catch (e) {

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

  } finally {

    if (mounted) {
      setState(() => _isLoading = false);
    }

  }
}

  Widget _buildTreasuryNav() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ADFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home_outlined, size: 30), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined, size: 30), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, size: 30), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, size: 30), onPressed: () {}),
        ],
      ),
    );
  }
}