import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/section_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/reg_nav.dart';
import 'package:umpgo_frontend/domain/facultyregistrar_model.dart';

class ListNameOR extends StatelessWidget {
  final SectionModel section;
  final FacultyRegistrar registrar;
  const ListNameOR({super.key, required this.section, required this.registrar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Column(
                children: [
                  // Breadcrumb
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DB89A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.home_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "List of Section",
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
                          Text(
                            "Section ${section.sectionNo}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section info card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DB89A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SECTION ${section.sectionNo}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${section.enrolled}/${section.capacity} enrolled  •  ${section.day}  •  ${section.time}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student list placeholder
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 48,
                            color: Color(0xFF6B7C93),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No students enrolled yet",
                            style: TextStyle(
                              color: Color(0xFF6B7C93),
                              fontSize: 14,
                            ),
                          ),
                        ],
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
