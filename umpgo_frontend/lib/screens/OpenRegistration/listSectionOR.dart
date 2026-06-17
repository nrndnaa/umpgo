import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/subject_model.dart';
import 'package:umpgo_frontend/domain/section_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/screens/OpenRegistration/listNameOR.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';

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
class ListSectionOR extends StatelessWidget {
  final Subject subject;
  final FacultyRegistrar registrar;
  const ListSectionOR({
    super.key,
    required this.subject,
    required this.registrar,
  });

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
                  // ── Breadcrumb ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _Breadcrumb(subjectName: subject.subjectName),
                  ),
                  const SizedBox(height: 14),

                  // ── Subject header card ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _C.mint,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _C.mintDark.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: _C.mintDark,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
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
                                const SizedBox(height: 2),
                                Text(
                                  subject.subjectName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _C.textMain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${subject.sections.length} section${subject.sections.length != 1 ? 's' : ''}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _C.mintDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Section list ─────────────────────────────────────────
                  Expanded(
                    child: subject.sections.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.inbox_rounded,
                                  size: 48,
                                  color: _C.textMuted,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No sections available",
                                  style: TextStyle(
                                    color: _C.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                            itemCount: subject.sections.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _SectionCard(
                              section: subject.sections[i],
                              registrar: registrar, // ← add this
                            ),
                          ),
                  ),
                ],
              ),
            ),
            RegNav(registrar: registrar),
          ],
        ),
      ),
    );
  }
}

// ─── Breadcrumb ───────────────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  final String subjectName;
  const _Breadcrumb({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: _C.mint,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _C.mintDark.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "List of Subject",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
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
          Expanded(
            child: Text(
              subjectName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────
// ─── Section card ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final SectionModel section;
  final FacultyRegistrar registrar; // ← add this
  const _SectionCard({
    required this.section,
    required this.registrar, // ← add this
  });
  @override
  Widget build(BuildContext context) {
    final isFull = section.isFull;
    final cardColor = isFull
        ? const Color(0xFFD32F2F)
        : const Color(0xFF388E3C);
    final textColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title + capacity
                  Row(
                    children: [
                      Text(
                        "SECTION ${section.sectionNo}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${section.enrolled}/${section.capacity}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.notifications_none_rounded,
                    text: section.day,
                    color: textColor,
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    text: section.time,
                    color: textColor,
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: section.venue,
                    color: textColor,
                  ),
                ],
              ),
            ),

            // Details button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6FBF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ListNameOR(
                    section: section,
                    registrar: registrar, // ← add this
                  ),
                ),
              ),
              child: const Text(
                "Details",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info row (updated to accept color) ──────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow({
    required this.icon,
    required this.text,
    this.color = const Color(0xFF1A2B45),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color.withOpacity(0.85)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
