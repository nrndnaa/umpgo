import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'sessionDetails.dart';

class ActiveSession extends StatefulWidget {
  final int sessionID;
  final int userID;
  final bool isAdab;
  const ActiveSession({Key? key, required this.sessionID, required this.userID, required this.isAdab}) : super(key: key);
  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  Map<String, dynamic>? _session;
  bool _isLoading = true;
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;
  Color get _amber { debugPrint("ADAB CHECK: " + widget.isAdab.toString()); return widget.isAdab ? const Color(0xFFFFF9C4) : const Color(0xFFFFD18E); }
  Color get _amberDark => widget.isAdab ? const Color(0xFFFFD700) : const Color(0xFFE8920A);

  @override
  void initState() {  
    super.initState();
    _loadSession();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadSession());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSession() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.sessionDetail(widget.sessionID)));
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        setState(() { _session = data['session']; _isLoading = false; });
        _startCountdown();
      }
    } catch (e) { if (mounted) setState(() => _isLoading = false); }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    if (_session == null) return;
    final expiry = DateTime.tryParse(_session!['codeExpiry']?.toString() ?? '');
    if (expiry == null) return;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final r = expiry.difference(DateTime.now());
      setState(() => _remaining = r.isNegative ? Duration.zero : r);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final code = _session?['code']?.toString() ?? '------';
    final title = _session?['sessionTitle']?.toString() ?? '';
    final present = _session?['present'] ?? 0;
    final total = _session?['total'] ?? 0;
    final mins = _remaining.inMinutes.toString().padLeft(2, '0');
    final secs = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: widget.isAdab ? Colors.white : const Color(0xFFFAF0DC),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(30)),
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
            color: widget.isAdab ? Colors.white : const Color(0xFFFAF0DC),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(20)),
              child: const Text('Menu > New Session',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inner card - Active session
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text('ACTIVE SESSION',
                              style: TextStyle(fontSize: 11, color: Colors.black54,
                                  fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          // Code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: code.split('').asMap().entries.map<Widget>((e) {
                              return Padding(
                                padding: EdgeInsets.only(right: e.key == 2 ? 16 : 6),
                                child: Text(e.value,
                                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 4),
                          Text('Code expires in $mins:$secs',
                              style: const TextStyle(color: Colors.black54, fontSize: 11)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(title,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
                              ),
                              Text('$present / $total',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total > 0 ? present / total : 0,
                              backgroundColor: Colors.white,
                              color: Colors.green,
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _amberDark,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => SessionDetails(sessionID: widget.sessionID, isAdab: widget.isAdab))),
                              child: const Text('View Session', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
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
}














