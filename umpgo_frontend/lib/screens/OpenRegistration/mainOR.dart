// ignore: file_names
import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

// ─── Theme constants ────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F7FB);
  static const primary = Color(0xFF1E6FBF);
  static const primaryLight = Color(0xFFD6E8F8);
  // ignore: unused_field
  static const accent = Color(0xFF3A9FDB);
  static const danger = Color(0xFFE53935);
  // ignore: unused_field
  static const dangerLight = Color(0xFFFFEBEE);
  static const success = Color(0xFF2E7D32);
  static const successLight = Color(0xFFE8F5E9);
  static const surface = Colors.white;
  static const textMain = Color(0xFF1A2B45);
  static const textMuted = Color(0xFF6B7C93);
  static const border = Color(0xFFDDE3EE);
  // ignore: unused_field
  static const headerBg = Color(0xFF1E6FBF);
}

// ─── Root screen ────────────────────────────────────────────────────────────
class MainOR extends StatelessWidget {
  const MainOR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _Breadcrumb(),
                    const SizedBox(height: 20),
                    _StudentInfoCard(),
                    const SizedBox(height: 20),
                    _AddSubjectCard(),
                    const SizedBox(height: 20),
                    _RegisteredSubjectsCard(),
                    const SizedBox(height: 20),
                    _SubjectStatusCard(),
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
}

// ─── Breadcrumb banner ───────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: _C.primary.withOpacity(0.25),
            blurRadius: 12,
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
            "Open Registration",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Student info card ───────────────────────────────────────────────────────
class _StudentInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.person_rounded,
            label: "Student Information",
          ),
          const SizedBox(height: 14),
          _infoTile(
            Icons.badge_rounded,
            "Full Name",
            "Nurin Irdina Binti Faizul Zaki",
          ),
          const _Divider(),
          _infoTile(Icons.numbers_rounded, "Matric ID", "CB23090"),
          const _Divider(),
          _infoTile(
            Icons.calendar_month_rounded,
            "Semester",
            "Semester II  •  2025 / 2026",
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
                    letterSpacing: 0.4,
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
}

// ─── Add subject card ────────────────────────────────────────────────────────
class _AddSubjectCard extends StatefulWidget {
  @override
  State<_AddSubjectCard> createState() => _AddSubjectCardState();
}

class _AddSubjectCardState extends State<_AddSubjectCard> {
  String _selectedSection = "2A";
  final _sections = ["1A", "1B", "2A", "2B", "3A", "3B"];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.add_circle_rounded, label: "Add Subject"),
          const SizedBox(height: 16),

          // Search field
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: _C.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Search by subject code or name…",
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

          // Subject result row
          Container(
            decoration: BoxDecoration(
              color: _C.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.border),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _C.primaryLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                  ),
                  child: Row(
                    children: const [
                      _ColHead("Code", flex: 2),
                      _ColHead("Subject Name", flex: 5),
                      _ColHead("Section", flex: 2),
                    ],
                  ),
                ),
                // Data row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "BCN3023",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _C.primary,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 5,
                        child: Text(
                          "Network Management",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _C.textMain,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSection,
                            isDense: true,
                            icon: const Icon(
                              Icons.expand_more_rounded,
                              size: 18,
                              color: _C.primary,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _C.primary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            items: _sections
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedSection = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: _PrimaryButton(
              label: "Add Subject",
              icon: Icons.add_rounded,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Registered subjects card ────────────────────────────────────────────────
class _RegisteredSubjectsCard extends StatelessWidget {
  final _subjects = const [
    ["BCS3133", "Software Engineering Practices"],
    ["BCS3153", "Software Evolution & Maintenance"],
    ["BCS3143", "Software Project Management"],
    ["BCI2313", "Algorithm & Complexity"],
    ["BCI3353", "Blockchain Technology"],
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SectionHeader(
                  icon: Icons.menu_book_rounded,
                  label: "Registered Subjects",
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
                  "${_subjects.length} subjects",
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

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _C.primaryLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                _ColHead("No.", flex: 1),
                _ColHead("Code", flex: 3),
                _ColHead("Subject Name", flex: 6),
                _ColHead("", flex: 3),
              ],
            ),
          ),

          // Rows
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: _C.border),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Column(
              children: List.generate(_subjects.length, (i) {
                final isEven = i.isEven;
                final s = _subjects[i];
                return Container(
                  color: isEven ? Colors.white : const Color(0xFFF0F5FB),
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
                            "${i + 1}",
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
                            s[0],
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
                            s[1],
                            style: const TextStyle(
                              fontSize: 13,
                              color: _C.textMain,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _DangerButton(
                              label: "Drop",
                              onPressed: () {},
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

          const SizedBox(height: 18),

          _OutlineButton(
            label: "Back to Home",
            icon: Icons.arrow_back_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ─── Subject status card ─────────────────────────────────────────────────────
class _SubjectStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _C.successLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.success.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: _C.success.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _C.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: _C.success,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registration Successful",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _C.success,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "5 subjects registered for Semester II 2025/2026",
                  style: TextStyle(
                    fontSize: 12,
                    color: _C.success.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _C.success),
        ],
      ),
    );
  }
}

// ─── Shared small widgets ────────────────────────────────────────────────────

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
            letterSpacing: 0.1,
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: _C.border, height: 1, thickness: 1);
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
