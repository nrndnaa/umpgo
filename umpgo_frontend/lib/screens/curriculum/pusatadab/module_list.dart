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
  bool loading = false;

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
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void deleteModule(int moduleID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this module?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
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
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Module deleted successfully!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm',
                style: TextStyle(color: Colors.white)),
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
          // Breadcrumb + Add Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFFD700),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu > Module List',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModuleForm(adab: widget.adab)),
                    ).then((_) => fetchModules());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  icon: const Icon(Icons.add, size: 16, color: Colors.black),
                  label: const Text('Add Module',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
              ],
            ),
          ),

          // Module List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : modules.isEmpty
                    ? const Center(child: Text('No modules found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          return _buildModuleCard(modules[index]);
                        },
                      ),
          ),

          // Back Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Back',
                    style: TextStyle(color: Colors.black)),
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
            Text(module['code'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(module['name'] ?? '',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(module['startDate'] ?? '',
                  style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                  '${module['startTime'] ?? ''} - ${module['endTime'] ?? ''}',
                  style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(module['venue'] ?? '',
                  style: const TextStyle(fontSize: 12)),
            ]),
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
                  isFullyBooked ? Colors.red : Colors.green),
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
                    child: const Text('View Enrollment List',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModuleForm(adab: widget.adab, module: module),
                      ),
                    ).then((_) => fetchModules());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B9BD5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Edit',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => deleteModule(module['moduleID']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}