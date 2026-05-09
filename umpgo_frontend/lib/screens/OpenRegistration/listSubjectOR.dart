import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/subject_model.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/domain/section_model.dart'; // Adjust path as needed
import 'package:umpgo_frontend/screens/OpenRegistration/listSectionOR.dart';

// ─── Theme ────────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F7FB);
  static const mint = Color(0xFFA8E6CF);
  static const mintDark = Color(0xFF4DB89A);
  static const mintLight = Color(0xFFE6F7F1);
  static const primary = Color(0xFF1E6FBF);
  static const surface = Colors.white;
  static const textMain = Color(0xFF1A2B45);
  static const textMuted = Color(0xFF6B7C93);
  static const border = Color(0xFFDDE3EE);
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class ListSubjectOR extends StatefulWidget {
  final FacultyRegistrar registrar;
  const ListSubjectOR({super.key, required this.registrar});

  @override
  State<ListSubjectOR> createState() => _ListSubjectORState();
}

class _ListSubjectORState extends State<ListSubjectOR> {
  List<Subject> _subjects = [];
  List<Subject> _filtered = [];
  bool _isLoading = true;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _subjects
          : _subjects
                .where(
                  (s) =>
                      s.subjectCode.toLowerCase().contains(q) ||
                      s.subjectName.toLowerCase().contains(q),
                )
                .toList();
    });
  }

  Future<void> _fetchSubjects() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.subjects))
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final list = (data['subjects'] as List)
            .map((j) => Subject.fromJson(j))
            .toList();
        setState(() {
          _subjects = list;
          _filtered = list;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load subjects.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('ERROR: $e'); // ← add this line
      setState(() {
        _error = 'Could not connect to server.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Column(
                children: [
                  // ── Breadcrumb ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _Breadcrumb(),
                  ),
                  const SizedBox(height: 14),

                  // ── Search bar ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _SearchBar(controller: _searchCtrl),
                  ),
                  const SizedBox(height: 14),

                  // ── Count badge ────────────────────────────────────────────
                  if (!_isLoading && _error == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _C.mintLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _C.mintDark.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              "${_filtered.length} subject${_filtered.length != 1 ? 's' : ''}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _C.mintDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),

                  // ── Body ───────────────────────────────────────────────────
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: _C.mintDark,
                            ),
                          )
                        : _error != null
                        ? _ErrorView(message: _error!, onRetry: _fetchSubjects)
                        : _filtered.isEmpty
                        ? _EmptyView()
                        : RefreshIndicator(
                            color: _C.mintDark,
                            onRefresh: _fetchSubjects,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (_, i) =>
                                  _SubjectCard(subject: _filtered[i]),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const RegNav(),
          ],
        ),
      ),
    );
  }
}

// ─── Breadcrumb ───────────────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 98, 158, 135),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 54, 134, 112).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Text(
            "Menu",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.white60,
              size: 18,
            ),
          ),
          const Text(
            "List of Subject",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _C.textMain,
        ),
        decoration: const InputDecoration(
          hintText: "Search by subject code or name…",
          hintStyle: TextStyle(color: _C.textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _C.textMuted, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}

// ─── Subject card ─────────────────────────────────────────────────────────────
class _SubjectCard extends StatelessWidget {
  final Subject subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _C.mintLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: _C.mintDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Subject info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.subjectCode,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _C.mintDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subject.subjectName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _C.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${subject.sections.length} section${subject.sections.length != 1 ? 's' : ''}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: _C.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Blue Select button ──────────────────────────────────
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary, // blue
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ListSectionOR(subject: subject),
                ),
              ),
              child: const Text(
                "Click",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section row ──────────────────────────────────────────────────────────────
class _SectionRow extends StatelessWidget {
  final SectionModel section;
  final bool isLast;
  const _SectionRow({required this.section, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, isLast ? 12 : 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Section ${section.sectionNo}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _C.textMain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.notifications_none_rounded,
                    text: section.day,
                  ),
                  const SizedBox(height: 3),
                  _InfoRow(icon: Icons.access_time_rounded, text: section.time),
                  const SizedBox(height: 3),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: section.venue,
                  ),
                  const SizedBox(height: 3),
                  _InfoRow(
                    icon: Icons.people_outline_rounded,
                    text: "Capacity: ${section.capacity}",
                  ),
                ],
              ),
            ),
            // Click button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(60, 34),
                ),
                onPressed: () {},
                child: const Text(
                  "View",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: _C.textMuted),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: _C.textMain,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: _C.textMuted),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: _C.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.mintDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

// ─── Empty view ───────────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 48, color: _C.textMuted),
          SizedBox(height: 12),
          Text(
            "No subjects found",
            style: TextStyle(color: _C.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
