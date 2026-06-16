// ignore: file_names
import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/screens/OpenRegistration/subjectStatusOR.dart';

// ─── Theme constants ─────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F7FB);
  static const primary = Color(0xFF1E6FBF);
  static const primaryLight = Color(0xFFD6E8F8);
  static const danger = Color(0xFFE53935);
  static const success = Color(0xFF2E7D32);
  static const successLight = Color(0xFFE8F5E9);
  static const warning = Color(0xFFF57C00);
  static const warningLight = Color(0xFFFFF3E0);
  static const surface = Colors.white;
  static const textMain = Color(0xFF1A2B45);
  static const textMuted = Color(0xFF6B7C93);
  static const border = Color(0xFFDDE3EE);
}

// ─── Root screen ──────────────────────────────────────────────────────────────

class MainOR extends StatefulWidget {
  final StudentModel student;
  const MainOR({super.key, required this.student});

  @override
  State<MainOR> createState() => _MainORState();
}

class _MainORState extends State<MainOR> {
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _enrollments = [];
  bool _loadingSubjects = true;
  bool _loadingEnrollments = true;
  String _searchQuery = '';

  bool _isLoading = true;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
    _fetchEnrollments();
    _checkSession();
  }

  // ── Fetch all subjects with sections ────────────────────────────────────────
  Future<void> _fetchSubjects() async {
    try {
      final res = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/subjects-with-sections'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('STATUS: ${res.statusCode}');
      debugPrint('BODY: ${res.body}');

      final data = jsonDecode(res.body);
      if (data['success'] == true) {
        setState(() {
          _subjects = List<Map<String, dynamic>>.from(data['subjects']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching subjects: $e');
    } finally {
      setState(() => _loadingSubjects = false);
    }
  }

  // ── Fetch student's current enrollments ─────────────────────────────────────
  Future<void> _fetchEnrollments() async {
    try {
      final res = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/my-enrollments/${widget.student.studentID}',
            ),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(res.body);
      if (data['success'] == true) {
        setState(() {
          _enrollments = List<Map<String, dynamic>>.from(data['enrollments']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching enrollments: $e');
    } finally {
      setState(() => _loadingEnrollments = false);
    }
  }

  // ── Enroll in a section ──────────────────────────────────────────────────────
  Future<void> _enroll(int sectionID) async {
    try {
      final res = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/enroll'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'studentID': widget.student.studentID,
              'sectionID': sectionID,
            }),
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(res.body);
      final success = data['success'] == true;
      final message = data['message'] ?? 'Done';
      _showPopup(success: success, message: message);
      if (success) _fetchEnrollments();
    } catch (e) {
      _showPopup(success: false, message: 'Error: $e');
    }
  }

  // ── Drop a subject ───────────────────────────────────────────────────────────
  Future<void> _drop(int enrollmentID) async {
    try {
      final res = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}/enroll/$enrollmentID'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(res.body);
      final success = data['success'] == true;
      final message = data['message'] ?? 'Done';
      _showPopup(success: success, message: message);
      if (success) _fetchEnrollments();
    } catch (e) {
      _showPopup(success: false, message: 'Error: $e');
    }
  }

  void _showPopup({required bool success, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: success ? _C.success : _C.danger,
                    width: 3,
                  ),
                ),
                child: Icon(
                  success ? Icons.check_rounded : Icons.close_rounded,
                  color: success ? _C.success : _C.danger,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _C.textMain,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success ? _C.primary : _C.danger,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filtered subjects ────────────────────────────────────────────────────────
  // FIX 1: Removed the extra closing brace that was here, which was
  // incorrectly closing _MainORState before _checkSession and build().
  List<Map<String, dynamic>> get _filteredSubjects {
    if (_searchQuery.isEmpty) return _subjects;
    final q = _searchQuery.toLowerCase();
    return _subjects.where((s) {
      return (s['subjectCode'] ?? '').toLowerCase().contains(q) ||
          (s['subjectName'] ?? '').toLowerCase().contains(q);
    }).toList();
  }

  // ── Check registration session ───────────────────────────────────────────────
  // FIX 2: _checkSession is now correctly inside _MainORState.
  Future<void> _checkSession() async {
    try {
      final uri = Uri.parse(
        ApiConfig.registrationSession(widget.student.yearOfStudy),
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);
      setState(() {
        _isOpen = data['open'] == true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isOpen = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: _C.bg,
        body: Center(child: CircularProgressIndicator(color: _C.primary)),
      );
    }

    if (!_isOpen) {
      return _ClosedScreen(student: widget.student);
    }

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildBreadcrumb(),
                    const SizedBox(height: 20),
                    _buildStudentInfoCard(),
                    const SizedBox(height: 20),
                    _buildAddSubjectCard(),
                    const SizedBox(height: 20),
                    _buildRegisteredSubjectsCard(),
                    const SizedBox(height: 20),
                    _buildSubjectStatusCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            StudNav(student: widget.student),
          ],
        ),
      ),
    );
  }

  // ── Breadcrumb ───────────────────────────────────────────────────────────────
  Widget _buildBreadcrumb() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E6FBF), Color(0xFF3A9FDB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Text(
            'Menu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
              size: 18,
            ),
          ),
          const Text(
            'Open Registration',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Student Info Card ────────────────────────────────────────────────────────
  Widget _buildStudentInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.person_rounded,
            label: 'Student Information',
          ),
          const SizedBox(height: 14),
          _infoTile(Icons.badge_rounded, 'Full Name', widget.student.name),
          const Divider(color: _C.border, height: 1),
          _infoTile(
            Icons.numbers_rounded,
            'Matric ID',
            widget.student.matricID,
          ),
          const Divider(color: _C.border, height: 1),
          _infoTile(
            Icons.school_rounded,
            'Programme',
            widget.student.programme,
          ),
          const Divider(color: _C.border, height: 1),
          _infoTile(
            Icons.calendar_month_rounded,
            'Year of Study',
            widget.student.yearOfStudy,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _C.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _C.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _C.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _C.textMain,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Add Subject Card ─────────────────────────────────────────────────────────
  Widget _buildAddSubjectCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.add_circle_rounded,
            label: 'Add Subject',
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _C.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: _C.textMuted, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(
                      fontSize: 14,
                      color: _C.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search by subject code or name…',
                      hintStyle: TextStyle(color: _C.textMuted, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _loadingSubjects
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: _C.primary),
                  ),
                )
              : _filteredSubjects.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No subjects found.',
                      style: TextStyle(color: _C.textMuted),
                    ),
                  ),
                )
              : Column(
                  children: _filteredSubjects.map((subject) {
                    return _SubjectRow(
                      subject: subject,
                      enrollments: _enrollments,
                      onEnroll: _enroll,
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  // ── Registered Subjects Card ─────────────────────────────────────────────────
  Widget _buildRegisteredSubjectsCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionHeader(
                  icon: Icons.menu_book_rounded,
                  label: 'Registered Subjects',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _C.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_enrollments.length} subjects',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _C.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _loadingEnrollments
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: _C.primary),
                  ),
                )
              : _enrollments.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No subjects registered yet.',
                      style: TextStyle(color: _C.textMuted),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _C.primaryLight,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          _ColHead('No.', flex: 1),
                          _ColHead('Code', flex: 3),
                          _ColHead('Subject Name', flex: 6),
                          _ColHead('', flex: 2),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _C.border),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: List.generate(_enrollments.length, (i) {
                          final e = _enrollments[i];
                          return Container(
                            color: i.isEven
                                ? Colors.white
                                : const Color(0xFFF0F5FB),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: _C.textMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e['subjectCode'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: _C.primary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      e['subjectName'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _C.textMain,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: _C.danger,
                                          side: const BorderSide(
                                            color: _C.danger,
                                            width: 1.2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          minimumSize: const Size(50, 28),
                                        ),
                                        onPressed: () =>
                                            _drop(e['enrollmentID']),
                                        child: const Text(
                                          'Drop',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _C.primary,
              side: const BorderSide(color: _C.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text(
              'Back to Home',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Subject Status Card ───────────────────────────────────────────────────────
  // FIX 3: Method now properly closes all nested widget trees and ends with }.
  Widget _buildSubjectStatusCard() {
    if (_enrollments.isEmpty) return const SizedBox.shrink();

    final hasPending = _enrollments.any(
      (e) => (e['status'] ?? 'Pending') == 'Pending',
    );
    final hasRejected = _enrollments.any((e) => e['status'] == 'Rejected');

    Color bgColor;
    Color iconColor;
    IconData icon;
    String title;
    String subtitle;

    if (hasRejected) {
      bgColor = const Color(0xFFFFEBEE);
      iconColor = _C.danger;
      icon = Icons.cancel_rounded;
      title = 'Some Subjects Rejected';
      subtitle = 'Please contact your registrar for more information.';
    } else if (hasPending) {
      bgColor = _C.warningLight;
      iconColor = _C.warning;
      icon = Icons.hourglass_top_rounded;
      title = 'Pending Approval';
      subtitle =
          '${_enrollments.length} subject(s) awaiting registrar approval.';
    } else {
      bgColor = _C.successLight;
      iconColor = _C.success;
      icon = Icons.check_circle_rounded;
      title = 'Registration Approved';
      subtitle = '${_enrollments.length} subjects approved for this semester.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: iconColor.withOpacity(0.75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubjectStatusOR(student: widget.student),
                  ),
                );
              },
              icon: const Icon(Icons.assignment_turned_in_rounded, size: 18),
              label: const Text('View Subject Status Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIX 1 (continued): This single } correctly closes _MainORState.
}

// ─── Subject Row Widget ───────────────────────────────────────────────────────
class _SubjectRow extends StatefulWidget {
  final Map<String, dynamic> subject;
  final List<Map<String, dynamic>> enrollments;
  final Future<void> Function(int sectionID) onEnroll;

  const _SubjectRow({
    required this.subject,
    required this.enrollments,
    required this.onEnroll,
  });

  @override
  State<_SubjectRow> createState() => _SubjectRowState();
}

class _SubjectRowState extends State<_SubjectRow> {
  String? _selectedSectionID;

  @override
  void initState() {
    super.initState();
    final sections = List<Map<String, dynamic>>.from(
      widget.subject['sections'] ?? [],
    );
    if (sections.isNotEmpty) {
      _selectedSectionID = sections.first['sectionID'].toString();
    }
  }

  bool get _isEnrolled {
    final sections = List<Map<String, dynamic>>.from(
      widget.subject['sections'] ?? [],
    );
    final sectionIDs = sections.map((s) => s['sectionID']).toSet();
    return widget.enrollments.any(
      (e) => sectionIDs.contains(
        e['sectionID'] is int
            ? e['sectionID']
            : int.tryParse(e['sectionID'].toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = List<Map<String, dynamic>>.from(
      widget.subject['sections'] ?? [],
    );
    final enrolled = _isEnrolled;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: enrolled ? _C.successLight : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: enrolled ? _C.success.withOpacity(0.4) : _C.border,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              widget.subject['subjectCode'] ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: enrolled ? _C.success : _C.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.subject['subjectName'] ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.textMain,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          sections.isEmpty
              ? const Text(
                  '—',
                  style: TextStyle(fontSize: 12, color: _C.textMuted),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _C.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _C.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          sections.any(
                            (s) =>
                                s['sectionID'].toString() == _selectedSectionID,
                          )
                          ? _selectedSectionID
                          : (sections.isNotEmpty
                                ? sections.first['sectionID'].toString()
                                : null),
                      isDense: true,
                      icon: const Icon(
                        Icons.expand_more_rounded,
                        size: 16,
                        color: _C.primary,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _C.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      selectedItemBuilder: (context) => sections.map((sec) {
                        return DropdownMenuItem<String>(
                          value: sec['sectionID'].toString(),
                          child: Text(sec['sectionNo'] ?? ''),
                        );
                      }).toList(),
                      items: sections.map((sec) {
                        return DropdownMenuItem<String>(
                          value: sec['sectionID'].toString(),
                          child: Text(sec['sectionNo'] ?? ''),
                        );
                      }).toList(),
                      onChanged: enrolled
                          ? null
                          : (v) => setState(() => _selectedSectionID = v),
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          enrolled
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: _C.success,
                  size: 20,
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    minimumSize: const Size(50, 30),
                  ),
                  onPressed: _selectedSectionID == null
                      ? null
                      : () => widget.onEnroll(int.parse(_selectedSectionID!)),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _C.primaryLight,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: _C.primary, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _C.textMain,
          ),
        ),
      ],
    );
  }
}

class _ColHead extends StatelessWidget {
  final String text;
  final int flex;
  const _ColHead(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _C.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// FIX 4: Renamed _Divider → _StyledDivider to avoid shadowing Flutter's Divider.
// (Unused, but kept to avoid any other references breaking.)
class _StyledDivider extends StatelessWidget {
  const _StyledDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: _C.border, height: 1, thickness: 1);
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: _C.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _DangerButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: _C.danger,
        side: const BorderSide(color: _C.danger, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(60, 30),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: _C.primary,
        side: const BorderSide(color: _C.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ClosedScreen extends StatelessWidget {
  final StudentModel student;
  const _ClosedScreen({required this.student});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEBEE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_clock_rounded,
                          color: Color(0xFFE53935),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Registration Closed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _C.textMain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Course Registration is currently closed for your programme / level.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: _C.textMuted,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _C.primary,
                          side: const BorderSide(color: _C.primary, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StudNav(student: student),
          ],
        ),
      ),
    );
  }
}
