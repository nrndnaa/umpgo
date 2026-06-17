import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';

class SessionDetails extends StatefulWidget {
  final int sessionID;
  final bool isAdab;
  const SessionDetails({Key? key, required this.sessionID, required this.isAdab}) : super(key: key);
  @override
  State<SessionDetails> createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  Map<String, dynamic>? _session;
  bool _isLoading = true;
  bool _showEndConfirm = false;
  bool _isEnding = false;
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;
  Color get _amber => widget.isAdab ? const Color(0xFFFFF9C4) : const Color(0xFFFFD18E);
  Color get _amberDark => widget.isAdab ? const Color(0xFFFFCC00) : const Color(0xFFE8920A);

  @override
  void initState() {
    super.initState();
    _load();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _load());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
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

  Future<void> _endSession() async {
    setState(() => _isEnding = true);
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.endSession),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'attSessionID': widget.sessionID}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        setState(() => _showEndConfirm = false);
        Navigator.popUntil(context, (r) => r.isFirst);
      }
    } catch (e) { debugPrint('Error: $e'); }
    finally { if (mounted) setState(() => _isEnding = false); }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final code = _session?['code']?.toString() ?? '------';
    final title = _session?['sessionTitle']?.toString() ?? '';
    final present = _session?['present'] ?? 0;
    final total = _session?['total'] ?? 0;
    final students = List<Map<String, dynamic>>.from(_session?['students'] ?? []);
    final isActive = _session?['isActive'] == true || _session?['isActive'] == 1;
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
      body: Stack(
        children: [
          Column(
            children: [
              const AppHeader(),
              Container(
                width: double.infinity,
                color: const Color(0xFFFAF0DC),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Menu > Active Sessions',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: _amber, borderRadius: BorderRadius.circular(16)),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Title + code
                          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: code.split('').asMap().entries.map<Widget>((e) {
                              return Padding(
                                padding: EdgeInsets.only(right: e.key == 2 ? 16 : 6),
                                child: Text(e.value, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 4),
                          Text('Expires in $mins:$secs - tap to copy',
                              style: const TextStyle(color: Colors.black54, fontSize: 11)),
                          const SizedBox(height: 16),
                          // Stats
                          Row(
                            children: [
                              Expanded(child: _statBox('$present', 'Checked In')),
                              const SizedBox(width: 8),
                              Expanded(child: _statBox('${total - present}', 'Pending')),
                              const SizedBox(width: 8),
                              Expanded(child: _statBox('$total', 'Total')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Live check-ins
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('LIVE CHECK-INS',
                                style: TextStyle(fontSize: 11, color: Colors.black54,
                                    fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: students.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('No check-ins yet', style: TextStyle(color: Colors.black54)))
                                : Column(
                                    children: students.take(5).map<Widget>((s) {
                                      final name = s['name']?.toString() ?? '';
                                      final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : '?';
                                      final rawTime = s['checkedIn_At']?.toString() ?? '';
                                      final time = rawTime.length >= 16 ? rawTime.substring(11, 16) : '';
                                      return ListTile(
                                        dense: true,
                                        leading: CircleAvatar(
                                          backgroundColor: _amberDark,
                                          child: Text(initials, style: const TextStyle(fontSize: 11,
                                              fontWeight: FontWeight.bold, color: Colors.white))),
                                        title: Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                        subtitle: Text(s['matricID']?.toString() ?? '',
                                            style: const TextStyle(fontSize: 10, color: Colors.black54)),
                                        trailing: Text(time, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                      );
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          if (isActive)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _amberDark,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => setState(() => _showEndConfirm = true),
                                child: const Text('End Session',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showEndConfirm)
            Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Are you sure want\nto end this session?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(90, 40)),
                            onPressed: _isEnding ? null : _endSession,
                            child: _isEnding
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('YES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(90, 40)),
                            onPressed: () => setState(() => _showEndConfirm = false),
                            child: const Text('NO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
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

  Widget _statBox(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
    ]),
  );
}


