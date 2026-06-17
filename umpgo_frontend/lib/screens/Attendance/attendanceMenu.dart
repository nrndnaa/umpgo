import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'createSession.dart';
import 'activeSession.dart';
import 'allSession.dart';
import 'selected_previous_session.dart';

class AttendanceMenu extends StatefulWidget {
  final int userID;
  final String userName;
  final bool isAdab;
  const AttendanceMenu({Key? key, required this.userID, required this.userName, required this.isAdab}) : super(key: key);
  @override
  State<AttendanceMenu> createState() => _AttendanceMenuState();
}

class _AttendanceMenuState extends State<AttendanceMenu> {
  List<Map<String, dynamic>> _recentSessions = [];
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
      final url = widget.isAdab ? ApiConfig.allSessionsAdab(widget.userID) : ApiConfig.allSessions(widget.userID);
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final all = List<Map<String, dynamic>>.from(data['sessions']);
        setState(() => _recentSessions = all.take(3).toList());
      }
    } catch (e) { debugPrint('Error: $e'); }
    finally { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isAdab ? Colors.white : const Color(0xFFFAF0DC),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _amber,
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
      ),
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Menu > Attendance',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Generate New Code
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('GENERATE NEW CODE',
                              style: TextStyle(fontSize: 11, color: Colors.black54,
                                  fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _amberDark,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => CreateSession(userID: widget.userID, userName: widget.userName, isAdab: widget.isAdab),
                              )).then((_) => _load()),
                              child: const Text('+ Start New Session',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Recent Sessions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RECENT SESSIONS',
                              style: TextStyle(fontSize: 11, color: Colors.black54,
                                  fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _recentSessions.isEmpty
                                  ? const Text('No sessions yet', style: TextStyle(color: Colors.black54))
                                  : Column(children: _recentSessions.map((s) => _sessionTile(s)).toList()),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // View All Sessions
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => AllSession(userID: widget.userID, isAdab: widget.isAdab),
                      )),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _amberDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('View All Sessions',
                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
                                Text('Full attendance history',
                                    style: TextStyle(color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                            Icon(Icons.arrow_forward, color: Colors.black87),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTile(Map<String, dynamic> s) {
    final present = s['present'] ?? 0;
    final total = s['total'] ?? 0;
    final isActive = s['isActive'] == true || s['isActive'] == 1;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => isActive
            ? ActiveSession(sessionID: s['attSessionID'] as int, userID: widget.userID, isAdab: widget.isAdab)
            : SelectedPreviousSession(sessionID: s['attSessionID'] as int, isAdab: widget.isAdab),
      )).then((_) => _load()),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['subjectName'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                  Text('${s['started_At']?.toString().substring(0, 10) ?? ''} ${s['sessionTitle'] ?? ''}',
                      style: const TextStyle(color: Colors.black54, fontSize: 11)),
                ],
              ),
            ),
            Text('$present / $total',
                style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}










