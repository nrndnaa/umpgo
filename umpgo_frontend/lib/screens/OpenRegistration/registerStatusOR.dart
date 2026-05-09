import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

const _teal = Color(0xFF2EB88A);
const _textDark = Color(0xFF1A1A1A);
const _textMuted = Color(0xFF6B7C93);
const _cardBg = Color(0xFFF5F5F5);

class RegisterStatusOR extends StatefulWidget {
  final FacultyRegistrar registrar;
  const RegisterStatusOR({super.key, required this.registrar});

  @override
  State<RegisterStatusOR> createState() => _RegisterStatusORState();
}

class _RegisterStatusORState extends State<RegisterStatusOR> {
  bool _isLoading = true;
  int _totalStudents = 0;
  int _notRegistered = 0;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _paginated = [];

  int _currentPage = 1;
  final int _perPage = 14;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/student-registration-status'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _totalStudents = data['totalStudents'];
          _notRegistered = data['notRegistered'];
          _students = List<Map<String, dynamic>>.from(data['students']);
          _updatePage();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        // temporarily show error
      });
      debugPrint('Error fetching status: $e');
    }
  }

  void _updatePage() {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _students.length);
    _paginated = _students.sublist(start, end);
  }

  int get _totalPages => (_students.length / _perPage).ceil();

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
      _updatePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            // Breadcrumb
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Menu > Student Registration Status',
                style: TextStyle(
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
                        children: [
                          // Stats card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: _teal,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatItem(
                                  value: _totalStudents.toString(),
                                  label: 'Students\nRegistered',
                                ),
                                Container(
                                  width: 1,
                                  height: 60,
                                  color: Colors.white38,
                                ),
                                _StatItem(
                                  value: _notRegistered
                                      .toString(), // ← was _totalStudents
                                  label: 'Students not\nRegistered',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Table
                          Container(
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
                              children: [
                                // Header
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: const [
                                      SizedBox(
                                        width: 36,
                                        child: Text('No.', style: _headerStyle),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          'Matric ID',
                                          style: _headerStyle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Student Name',
                                          style: _headerStyle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Text(
                                          'Status',
                                          style: _headerStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),

                                // Rows
                                ...List.generate(_paginated.length, (i) {
                                  final s = _paginated[i];
                                  final globalIndex =
                                      (_currentPage - 1) * _perPage + i + 1;
                                  final registered =
                                      s['registered'] == true ||
                                      s['registered'] == 1;
                                  return Container(
                                    color: i % 2 == 0
                                        ? Colors.white
                                        : const Color(0xFFF0F0F0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 36,
                                          child: Text(
                                            '$globalIndex.',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            s['matricID'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            s['name'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: Center(
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: registered
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),

                                // Pagination
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Page $_currentPage/$_totalPages',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: _textMuted,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (_currentPage > 1)
                                            _PageBtn(
                                              label: 'Prev',
                                              onTap: () =>
                                                  _goToPage(_currentPage - 1),
                                            ),
                                          const SizedBox(width: 8),
                                          if (_currentPage < _totalPages)
                                            _PageBtn(
                                              label: 'Next',
                                              onTap: () =>
                                                  _goToPage(_currentPage + 1),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

const _headerStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: _textMuted,
);

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PageBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
