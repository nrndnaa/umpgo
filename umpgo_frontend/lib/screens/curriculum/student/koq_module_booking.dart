import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/stud_nav.dart';
import 'package:umpgo_frontend/domain/student_model.dart';

class KoQModuleBooking extends StatefulWidget {
  final int studentID;
  final String matricID;
  final StudentModel student;

  const KoQModuleBooking({
    super.key,
    required this.studentID,
    required this.matricID,
    required this.student,
  });

  @override
  State<KoQModuleBooking> createState() => _KoQModuleBookingState();
}

class _KoQModuleBookingState extends State<KoQModuleBooking> {
  bool loading = false;
  List<Map<String, dynamic>> modules = [];
  List<int> bookedModuleIDs = [];

  @override
  void initState() {
    super.initState();
    fetchModules();
    fetchMyBookings();
  }

  void fetchModules() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.modules}?studentID=${widget.studentID}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          modules = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void fetchMyBookings() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/modules/mybookings/${widget.studentID}'),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          List<int> ids = [];
          for (var item in data) {
            ids.add(item['moduleID'] as int);
          }
          bookedModuleIDs = ids;
        });
      }
    } catch (_) {}
  }

  void searchModules(String query) {
    setState(() {
      filteredModules = modules.where((module) {
        final title = (module['name'] ?? '').toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  void registerModule(int moduleID) {
    final pageContext = context; // save page context Ã¢Å“â€¦
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Registration'),
        content: const Text(
          'Are you sure you want to register for this module?',
        ),
        title: const Text('Do you want to Confirm Registration', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await http.post(
                  Uri.parse(ApiConfig.registerModule),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'moduleID': moduleID,
                    'studentID': widget.studentID,
                  }),
                );
                if (response.statusCode == 200) {
                  setState(() {
                    bookedModuleIDs.add(moduleID);
                  });
                  headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
                  body: jsonEncode({'moduleID': moduleID, 'studentID': widget.studentID}),
                );
                if (response.statusCode == 200) {
                  setState(() => bookedModuleIDs.add(moduleID));
                  final registeredCount = bookedModuleIDs.length;
                  ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(
                    content: Text('Successfully Registered! ($registeredCount/2)'),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  final error = jsonDecode(response.body);
                  ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(
                    content: Text(error['message'] ?? 'Failed to register!'),
                    backgroundColor: Colors.red,
                  ));
                  fetchModules();
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  pageContext,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
                ScaffoldMessenger.of(pageContext).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
            child: const Text('Back', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableModules = modules;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text(
              'Menu > Curriculum > KoQ Module Booking',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF5B9BD5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Menu > Curriculum > KoQ Module Booking",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: searchController,
              onChanged: searchModules,
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
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : availableModules.isEmpty
                    ? const Center(child: Text('No available modules'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: availableModules.length,
                        itemBuilder: (context, index) => _buildModuleCard(availableModules[index]),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudNav(),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    final int filled = module['filledSlots'] ?? 0;
    final int max = module['maxSlots'] ?? 1;
    final bool isFullyBooked = filled >= max;
    final bool isBooked = bookedModuleIDs.contains(module['moduleID'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(module['code'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(module['name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.calendar_today, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(module['startDate'] ?? '', style: const TextStyle(fontSize: 12))]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.access_time, size: 14, color: Colors.grey), const SizedBox(width: 4), Text('${module['startTime'] ?? ''} - ${module['endTime'] ?? ''}', style: const TextStyle(fontSize: 12))]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.school, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(module['campus'] ?? '', style: const TextStyle(fontSize: 12))]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(module['venue'] ?? '', style: const TextStyle(fontSize: 12))]),
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
              value: filled / max,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(isFullyBooked ? Colors.red : Colors.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isBooked || isFullyBooked)
                    ? null
                    : () => registerModule(module['moduleID']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBooked
                      ? Colors.red
                      : isFullyBooked
                      ? Colors.red
                      : Colors.green,
                  disabledBackgroundColor: isBooked ? Colors.red : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                onPressed: (isBooked || isFullyBooked) ? null : () => registerModule(module['moduleID']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBooked ? Colors.red : isFullyBooked ? Colors.red : Colors.green,
                  disabledBackgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  isBooked ? 'Booked' : isFullyBooked ? 'Full' : 'Register',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}