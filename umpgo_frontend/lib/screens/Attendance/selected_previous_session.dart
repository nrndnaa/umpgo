import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'editAttendance.dart';

class SelectedPreviousSession extends StatefulWidget {
  final int sessionID;
  final bool isAdab;
  const SelectedPreviousSession({Key? key, required this.sessionID, required this.isAdab}) : super(key: key);
  @override
  State<SelectedPreviousSession> createState() => _SelectedPreviousSessionState();
}

class _SelectedPreviousSessionState extends State<SelectedPreviousSession> {
  Map<String, dynamic>? _session;
  bool _isLoading = true;
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
      final response = await http.get(Uri.parse(ApiConfig.sessionDetail(widget.sessionID)));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() { _session = data['session']; _isLoading = false; });
      }
    } catch (e) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final students = List<Map<String, dynamic>>.from(_session?['students'] ?? []);
    final present = _session?['present'] ?? 0;
    final absent = _session?['absent'] ?? 0;
    final late = _session?['late'] ?? 0;
    final total = _session?['total'] ?? 0;

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
            child: const Text('Menu > Session Detail',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _amber.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(12)),
                          child: Text(_session?['sessionTitle'] ?? '',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
                        ),
                        const SizedBox(height: 8),
                        Text(_session?['sessionTitle'] ?? '',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(_session?['started_At']?.toString().substring(0, 16) ?? '',
                            style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: total > 0 ? present / total : 0,
                            backgroundColor: Colors.white,
                            color: Colors.green,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('$present / $total present',
                            style: const TextStyle(fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _statBox('$present', 'Present')),
                      const SizedBox(width: 8),
                      Expanded(child: _statBox('$absent', 'Absent')),
                      const SizedBox(width: 8),
                      Expanded(child: _statBox('$late', 'Late')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('STUDENT LIST',
                        style: TextStyle(fontSize: 11, color: Colors.grey,
                            fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: students.isEmpty
                        ? const Padding(padding: EdgeInsets.all(16),
                            child: Text('No students', style: TextStyle(color: Colors.grey)))
                        : Column(
                            children: students.map<Widget>((s) {
                              final name = s['name']?.toString() ?? '';
                              final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : '?';
                              final status = s['status']?.toString() ?? 'Absent';
                              final rawTime = s['checkedIn_At']?.toString() ?? '';
                              final time = rawTime.length >= 16 ? rawTime.substring(11, 16) : '';
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: _amberDark,
                                  child: Text(initials, style: const TextStyle(fontSize: 11,
                                      fontWeight: FontWeight.bold, color: Colors.white))),
                                title: Text(name, style: const TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w600, color: Colors.black87)),
                                subtitle: Text('${s['matricID']?.toString() ?? ''}  $time',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: status == 'Present' ? Colors.green
                                        : status == 'Late' ? Colors.orange : Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _amberDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => EditAttendance(
                          sessionID: widget.sessionID.toString(),
                          isAdab: widget.isAdab,
                        ),
                      )).then((_) => _load()),
                      child: const Text('Edit Attendance',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: _amber.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
    ]),
  );

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

