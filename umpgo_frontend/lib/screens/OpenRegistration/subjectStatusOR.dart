// ignore: file_names
import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/student_model.dart';

// ─── Theme constants (same as MainOR) ────────────────────────────────────────
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

class SubjectStatusOR extends StatefulWidget {
  final StudentModel student;
  const SubjectStatusOR({super.key, required this.student});

  @override
  State<SubjectStatusOR> createState() => _SubjectStatusORState();
}

class _SubjectStatusORState extends State<SubjectStatusOR> {
  List<Map<String, dynamic>> _enrollments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

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
      setState(() => _loading = false);
    }
  }

  // ── Summary counts ───────────────────────────────────────────────────────────
  int get _approvedCount =>
      _enrollments.where((e) => e['status'] == 'Approved').length;
  int get _pendingCount =>
      _enrollments.where((e) => e['status'] == 'Pending').length;
  int get _rejectedCount =>
      _enrollments.where((e) => e['status'] == 'Rejected').length;

  @override
  Widget build(BuildContext context) {
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
                    _buildSummaryRow(),
                    const SizedBox(height: 20),
                    _buildStatusTableCard(),
                    const SizedBox(height: 24),
                    _buildBackButton(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            const StudNav(),
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
          Text(
            'Open Registration',
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
            'Subject Status',
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

  // ── Summary Row ──────────────────────────────────────────────────────────────
  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'Approved',
            count: _approvedCount,
            color: _C.success,
            bgColor: _C.successLight,
            icon: Icons.check_circle_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryChip(
            label: 'Pending',
            count: _pendingCount,
            color: _C.warning,
            bgColor: _C.warningLight,
            icon: Icons.hourglass_top_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryChip(
            label: 'Rejected',
            count: _rejectedCount,
            color: _C.danger,
            bgColor: const Color(0xFFFFEBEE),
            icon: Icons.cancel_rounded,
          ),
        ),
      ],
    );
  }

  // ── Status Table Card ────────────────────────────────────────────────────────
  Widget _buildStatusTableCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionHeader(
                  icon: Icons.assignment_turned_in_rounded,
                  label: 'Subject Status',
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
          const SizedBox(height: 16),

          _loading
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
                    // Table header
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
                      child: Row(
                        children: const [
                          _ColHead('No.', flex: 1),
                          _ColHead('Code', flex: 3),
                          _ColHead('Subject Name', flex: 6),
                          _ColHead('Status', flex: 3),
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
                          final status = e['status'] ?? 'Pending';
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
                                    flex: 3,
                                    child: _StatusBadge(status),
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
        ],
      ),
    );
  }

  // ── Back Button ──────────────────────────────────────────────────────────────
  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
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
          'Back',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ─── Summary Chip ─────────────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (status == 'Approved')
      color = _C.success;
    else if (status == 'Pending')
      color = _C.warning;
    else
      color = _C.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Shared Widgets (same as MainOR) ─────────────────────────────────────────
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
