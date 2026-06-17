import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

class EditAttendance extends StatefulWidget {
  final String sessionID;
  final bool isAdab;
  const EditAttendance({Key? key, required this.sessionID, required this.isAdab}) : super(key: key);
  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;
  bool _isSaving = false;
  Map<int, String> _edits = {};
  Color get _amber => widget.isAdab ? const Color(0xFFFFF9C4) : const Color(0xFFFFD18E);
  Color get _amberDark => widget.isAdab ? const Color(0xFFFFD700) : const Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.sessionDetail(int.parse(widget.sessionID))));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final students = List<Map<String, dynamic>>.from(data['session']['students'] ?? []);
        final edits = <int, String>{};
        for (final s in students) { edits[s['studentID']] = s['status'] ?? 'Absent'; }
        setState(() { _students = students; _edits = edits; _isLoading = false; });
      }
    } catch (e) { setState(() => _isLoading = false); }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final records = _edits.entries.map((e) => {'studentID': e.key, 'status': e.value}).toList();
      final response = await http.post(
        Uri.parse(ApiConfig.editAttendance(int.parse(widget.sessionID))),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'records': records}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance updated!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving'), backgroundColor: Colors.red));
    } finally { setState(() => _isSaving = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      bottomNavigationBar: Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFD18E), borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(icon: const Icon(Icons.home_rounded, size: 28), onPressed: () => Navigator.popUntil(context, (r) => r.isFirst)),
        IconButton(icon: const Icon(Icons.grid_view_rounded, size: 28), onPressed: () {}),
        IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 28), onPressed: () {}),
        IconButton(icon: const Icon(Icons.person_outline_rounded, size: 28), onPressed: () {}),
      ]),
    ),
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: _amber,
            child: const Text('Menu > Edit Attendance',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('EDIT STUDENT STATUS',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _students.length,
                    itemBuilder: (context, i) {
                      final s = _students[i];
                      final id = s['studentID'] as int;
                      final name = s['name']?.toString() ?? '';
                      final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : '?';
                      final status = _edits[id] ?? 'Absent';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _amber,
                              child: Text(initials, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text(s['matricID']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'Present' ? Colors.green.shade50
                                    : status == 'Late' ? Colors.orange.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: status == 'Present' ? Colors.green
                                      : status == 'Late' ? Colors.orange : Colors.red),
                              ),
                              child: DropdownButton<String>(
                                value: status,
                                isDense: true,
                                underline: const SizedBox(),
                                style: TextStyle(
                                  color: status == 'Present' ? Colors.green
                                      : status == 'Late' ? Colors.orange : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                items: ['Present', 'Absent', 'Late'].map((st) => DropdownMenuItem(
                                  value: st,
                                  child: Text(st),
                                )).toList(),
                                onChanged: (val) => setState(() => _edits[id] = val!),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _amberDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Discard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD18E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home_rounded, size: 28),
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst)),
          IconButton(icon: const Icon(Icons.grid_view_rounded, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline_rounded, size: 28), onPressed: () {}),
        ],
      ),
    );
  }
}

