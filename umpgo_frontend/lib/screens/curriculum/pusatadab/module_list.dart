import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../domain/pusatadab_model.dart';
import 'module_form.dart';
import 'enrollment_list.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';

class ModuleList extends StatefulWidget {
  final PusatAdabModel adab;
  const ModuleList({super.key, required this.adab});

  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  List<Map<String, dynamic>> modules = [];
  List<Map<String, dynamic>> filteredModules = [];
  TextEditingController searchController = TextEditingController();
  bool loading = false;

  // Semester dropdown
  final List<String> semesters = [
    'SEMESTER II ACADEMIC SESSION 2024/2025',
    'SEMESTER I ACADEMIC SESSION 2025/2026',
    'SEMESTER II ACADEMIC SESSION 2025/2026',
  ];
  String selectedSemester = 'SEMESTER II ACADEMIC SESSION 2025/2026';

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  void fetchModules() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.allModules));
      if (response.statusCode == 200) {
        setState(() {
          modules = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          applyFilters();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredModules = modules.where((module) {
        // ── Search filter ──
        final name = (module['name'] ?? '').toString().toLowerCase();
        final code = (module['code'] ?? '').toString().toLowerCase();
        final matchesSearch = name.contains(query) || code.contains(query);

        // ── Semester filter ──
        bool matchesSemester = true;
        if (module['startDate'] != null) {
          try {
            final startDate = DateTime.parse(module['startDate']);
            final m = startDate.month;
            final y = startDate.year;

            String moduleSemester;
            if (m >= 7 && m <= 12) {
              // Sem I: July–December
              moduleSemester = 'SEMESTER I ACADEMIC SESSION $y/${y + 1}';
            } else {
              // Sem II: January–June
              moduleSemester = 'SEMESTER II ACADEMIC SESSION ${y - 1}/$y';
            }

            matchesSemester = moduleSemester == selectedSemester;
          } catch (_) {
            matchesSemester = false;
          }
        }

        return matchesSearch && matchesSemester;
      }).toList();
    });
  }

  void deleteModule(int moduleID) {
    final pageContext = context;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Are you sure you want to delete this module?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await http.delete(
                  Uri.parse('${ApiConfig.baseUrl}/modules/$moduleID'),
                );
                if (response.statusCode == 200) {
                  setState(() {
                    modules.removeWhere((m) => m['moduleID'] == moduleID);
                    filteredModules.removeWhere(
                      (m) => m['moduleID'] == moduleID,
                    );
                  });
                  if (mounted) {
                    showDialog(
                      context: pageContext,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Success!',
                          textAlign: TextAlign.center,
                        ),
                        content: const Text(
                          'Module deleted successfully!',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                            ),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  showDialog(
                    context: pageContext,
                    builder: (context) => AlertDialog(
                      title: const Text('Error!', textAlign: TextAlign.center),
                      content: Text('Error: $e', textAlign: TextAlign.center),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B9BD5)),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9BD5),
            ),
            child: const Text('Back', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        children: [
          // ── Full yellow header bar ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Menu > Module List",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // ── Semester dropdown + Add Module button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Semester dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSemester,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          setState(() => selectedSemester = value!);
                          applyFilters();
                        },
                        items: semesters
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Add Module button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModuleForm(adab: widget.adab),
                      ),
                    ).then((_) => fetchModules());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black, size: 16),
                  label: const Text(
                    'Add Module',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: (_) => applyFilters(),
              decoration: InputDecoration(
                hintText: '  Curriculum Module',
                suffixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Module List ──
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filteredModules.isEmpty
                ? const Center(child: Text('No modules found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredModules.length,
                    itemBuilder: (context, index) {
                      return _buildModuleCard(filteredModules[index]);
                    },
                  ),
          ),

          // ── Back Button ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdabNav(),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    final int filled = module['filledSlots'] ?? 0;
    final int max = module['maxSlots'] ?? 1;
    final double slotPercentage = filled / max;
    final bool isFullyBooked = filled >= max;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module['code'] ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              module['name'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  module['startDate'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${module['startTime'] ?? ''} - ${module['endTime'] ?? ''}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.school, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  module['campus'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  module['venue'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Slots filled', style: TextStyle(fontSize: 12)),
                Text('$filled/$max', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: slotPercentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFullyBooked ? Colors.red : Colors.green,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnrollmentList(
                            moduleID: module['moduleID'],
                            moduleName: module['name'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'View Enrollment',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ModuleForm(adab: widget.adab, module: module),
                      ),
                    ).then((_) => fetchModules());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B9BD5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => deleteModule(module['moduleID']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
