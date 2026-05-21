import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

// ── Colors matching registrar dashboard ──────────────────────────────────────
const _mint = Color(0xFFA8E6CF);
const _teal = Color(0xFF2EB88A);
const _bg = Colors.white;
const _cardBg = Color(0xFFF5F5F5);
const _textDark = Color(0xFF1A1A1A);
const _textMuted = Color(0xFF6B7C93);
const _border = Color(0xFFDDE3EE);

class ScheduleOR extends StatefulWidget {
  final FacultyRegistrar registrar;

  const ScheduleOR({super.key, required this.registrar});

  @override
  State<ScheduleOR> createState() => _ScheduleORState();
}

class _ScheduleORState extends State<ScheduleOR> {
  // ── Form controllers ───────────────────────────────────────────────────────
  String _selectedYear = 'Year 1';
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isLoading = false;
  bool _isFetching = false;
  String? _errorMessage;
  String? _successMessage;

  List<Map<String, dynamic>> _sessions = [];

  final _years = ['Year 1', 'Year 2', 'Year 3', 'Year 4', "All Year"];

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  // ── Fetch existing sessions ────────────────────────────────────────────────
  Future<void> _fetchSessions() async {
    setState(() => _isFetching = true);
    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/registration-sessions'))
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _sessions = List<Map<String, dynamic>>.from(data['sessions']);
        });
      }
    } catch (_) {
      // silently fail — table may be empty
    } finally {
      setState(() => _isFetching = false);
    }
  }

  // ── Save new session ───────────────────────────────────────────────────────
  Future<void> _saveSession() async {
    if (_startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _endTime == null) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/registration-sessions'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'registrarID': widget.registrar.registrarID,
              'eligableYear': _selectedYear,
              'startDate': _startDate!.toIso8601String().split('T')[0],
              'endDate': _endDate!.toIso8601String().split('T')[0],
              'startTime': _formatTime(_startTime!),
              'endTime': _formatTime(_endTime!),
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Session created successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2EB88A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
        _fetchSessions();
        _fetchSessions();
      } else {
        setState(
          () => _errorMessage = data['message'] ?? 'Failed to save session.',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatDisplayTime(String t) {
    // Convert "HH:mm:ss" to "HH:mm A.M/P.M"
    final parts = t.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'P.M' : 'A.M';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour.$minute $period';
  }

  // ── Date & time pickers ───────────────────────────────────────────────────
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _teal)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _teal)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            // ── Breadcrumb ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Menu > Registration Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // ── Create Form Card ───────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Create New Session Registration Period',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _textDark,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _textDark),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Year dropdown
                          const Text(
                            'Select Eligable Year of Study:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _DropdownField(
                            value: _selectedYear,
                            items: _years,
                            onChanged: (v) =>
                                setState(() => _selectedYear = v!),
                          ),
                          const SizedBox(height: 14),

                          // Date & Time row 1
                          Row(
                            children: [
                              Expanded(
                                child: _DateTimeField(
                                  label: 'Start Date:',
                                  value: _startDate != null
                                      ? _formatDate(_startDate!)
                                      : 'dd/mm/yyyy',
                                  onTap: () => _pickDate(true),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DateTimeField(
                                  label: 'Start Time:',
                                  value: _startTime != null
                                      ? _startTime!.format(context)
                                      : '00:00',
                                  onTap: () => _pickTime(true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date & Time row 2
                          Row(
                            children: [
                              Expanded(
                                child: _DateTimeField(
                                  label: 'End Date:',
                                  value: _endDate != null
                                      ? _formatDate(_endDate!)
                                      : 'dd/mm/yyyy',
                                  onTap: () => _pickDate(false),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DateTimeField(
                                  label: 'End Class Time:',
                                  value: _endTime != null
                                      ? _endTime!.format(context)
                                      : '00:00',
                                  onTap: () => _pickTime(false),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Error / Success messages
                          if (_errorMessage != null)
                            _Banner(message: _errorMessage!, isError: true),
                          if (_successMessage != null)
                            _Banner(message: _successMessage!, isError: false),
                          const SizedBox(height: 8),

                          // Save button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 10,
                              ),
                            ),
                            onPressed: _isLoading ? null : _saveSession,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Sessions Table ─────────────────────────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _isFetching
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: CircularProgressIndicator(color: _teal),
                              ),
                            )
                          : _sessions.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  'No registration sessions yet.',
                                  style: TextStyle(
                                    color: _textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  _mint.withOpacity(0.3),
                                ),
                                columnSpacing: 16,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'No.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Year of Study',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Start Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'End Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'End Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(_sessions.length, (i) {
                                  final s = _sessions[i];
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          '${i + 1}.',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          s['eligableYear'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          s['startDate'] ?? '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          s['endDate'] ?? '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _formatDisplayTime(
                                            s['startTime'] ?? '00:00:00',
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _formatDisplayTime(
                                            s['endTime'] ?? '00:00:00',
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Back button
                    ElevatedButton(
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
}

// ── Dropdown Field ────────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textDark),
          style: const TextStyle(
            fontSize: 14,
            color: _textDark,
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Date / Time Field ─────────────────────────────────────────────────────────
class _DateTimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: value.contains('/') || value.contains(':')
                    ? _textDark
                    : _textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Banner (error/success) ────────────────────────────────────────────────────
class _Banner extends StatelessWidget {
  final String message;
  final bool isError;

  const _Banner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isError
              ? const Color(0xFFE53935).withOpacity(0.3)
              : const Color(0xFF43A047).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
            color: isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isError
                    ? const Color(0xFFE53935)
                    : const Color(0xFF43A047),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
