import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'selected_previous_session.dart';

class AllSession extends StatefulWidget {
  final int userID;
  final bool isAdab;
  const AllSession({Key? key, required this.userID, required this.isAdab}) : super(key: key);
  @override
  State<AllSession> createState() => _AllSessionState();
}

class _AllSessionState extends State<AllSession> {
  Map<String, List<Map<String, dynamic>>> _grouped = {};
  bool _isLoading = true;
  static const Color _amber = Color(0xFFFFD18E);
  static const Color _amberDark = Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final url = widget.isAdab ? ApiConfig.allSessionsAdab(widget.userID) : ApiConfig.allSessions(widget.userID);
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final sessions = List<Map<String, dynamic>>.from(data['sessions']);
        final grouped = <String, List<Map<String, dynamic>>>{};
        for (final s in sessions) {
          final key = s['subjectName'] ?? s['moduleName'] ?? 'Unknown';
          grouped.putIfAbsent(key, () => []).add(s);
        }
        setState(() { _grouped = grouped; _isLoading = false; });
      }
    } catch (e) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: _amber,
            child: const Text('Menu > View All Session',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _grouped.isEmpty
                    ? const Center(child: Text('No sessions yet'))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const Text('Subject',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ..._grouped.entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...entry.value.map((s) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(entry.key,
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                          Text(
                                            '${s['started_At']?.toString().substring(0, 10) ?? ''} ${s['sessionTitle'] ?? ''}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => SelectedPreviousSession(
                                          sessionID: s['attSessionID'] as int,
                                          isAdab: widget.isAdab,
                                        ),
                                      )),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _amberDark,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('View',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                              const SizedBox(height: 8),
                            ],
                          )).toList(),
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
