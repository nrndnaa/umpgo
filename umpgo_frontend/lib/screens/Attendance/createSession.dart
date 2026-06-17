import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'activeSession.dart';

class CreateSession extends StatefulWidget {
  final int userID;
  final String userName;
  final bool isAdab;
  const CreateSession({Key? key, required this.userID, required this.userName, required this.isAdab}) : super(key: key);
  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  List<Map<String, dynamic>> _options = [];
  int? _selectedID;
  String _selectedName = '';
  String _selectedDuration = '15';
  final _titleCtrl = TextEditingController();
  bool _isLoadingOptions = true;
  bool _isGenerating = false;
  String? _error;
  Color get _amber => widget.isAdab ? const Color(0xFFFFF9C4) : const Color(0xFFFFD18E);
  Color get _amberDark => widget.isAdab ? const Color(0xFFFFD700) : const Color(0xFFE8920A);
  final List<String> _durations = ['15', '30', '45', '60'];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() => _isLoadingOptions = true);
    try {
      final url = widget.isAdab ? ApiConfig.adabModules(widget.userID) : ApiConfig.lecturerSections(widget.userID);
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final list = widget.isAdab
            ? List<Map<String, dynamic>>.from(data['modules'])
            : List<Map<String, dynamic>>.from(data['sections']);
        setState(() {
          _options = list;
          if (list.isNotEmpty) {
            _selectedID = widget.isAdab ? list[0]['moduleID'] : list[0]['sectionID'];
            _selectedName = widget.isAdab ? list[0]['name'] : '${list[0]['subjectName']} - Section ${list[0]['sectionNo']}';
          }
        });
      }
    } catch (e) { setState(() => _error = 'Failed to load options'); }
    finally { setState(() => _isLoadingOptions = false); }
  }

  Future<void> _generateCode() async {
    if (_selectedID == null) { setState(() => _error = 'Please select a subject'); return; }
    if (!widget.isAdab && _titleCtrl.text.trim().isEmpty) { setState(() => _error = 'Please enter session title'); return; }
    setState(() { _isGenerating = true; _error = null; });
    try {
      final body = <String, dynamic>{
        'sessionTitle': widget.isAdab ? _selectedName : _titleCtrl.text.trim(),
        'codeDuration': int.parse(_selectedDuration),
        'createdBy': widget.isAdab ? 'Adab' : 'Lecturer',
      };
      if (widget.isAdab) { body['adabID'] = widget.userID; body['moduleID'] = _selectedID; }
      else { body['lecturerID'] = widget.userID; body['sectionID'] = _selectedID; }
      final response = await http.post(
        Uri.parse(ApiConfig.createSession),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ActiveSession(
            sessionID: data['session']['attSessionID'],
            userID: widget.userID,
            isAdab: widget.isAdab,
          ),
        ));
      } else {
        setState(() => _error = data['message'] ?? 'Failed to create session');
      }
    } catch (e) { setState(() => _error = 'Connection error'); }
    finally { setState(() => _isGenerating = false); }
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
            color: widget.isAdab ? Colors.white : const Color(0xFFFAF0DC),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Menu > Create Session',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Expanded(
            child: _isLoadingOptions
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.isAdab ? 'Module' : 'Subject',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                value: _selectedID,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _options.map((o) {
                                  final id = widget.isAdab ? o['moduleID'] : o['sectionID'];
                                  final name = widget.isAdab ? o['name'] : '${o['subjectName']} - Section ${o['sectionNo']}';
                                  return DropdownMenuItem<int>(value: id, child: Text(name, style: const TextStyle(fontSize: 13)));
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedID = val;
                                    final o = _options.firstWhere((o) => (widget.isAdab ? o['moduleID'] : o['sectionID']) == val);
                                    _selectedName = widget.isAdab ? o['name'] : '${o['subjectName']} - Section ${o['sectionNo']}';
                                  });
                                },
                              ),
                            ),
                            if (!widget.isAdab) ...[
                              const SizedBox(height: 16),
                              const Text('Session Title',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _titleCtrl,
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. Week 8 Lecture',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Text('Code Duration',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedDuration,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _durations.map((d) => DropdownMenuItem(
                                  value: d, child: Text('$d minutes'))).toList(),
                                onChanged: (val) => setState(() => _selectedDuration = val!),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (_error != null)
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_error!, style: const TextStyle(color: Colors.red)),
                              ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _amberDark,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _isGenerating ? null : _generateCode,
                                child: _isGenerating
                                    ? const SizedBox(width: 20, height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Text('Generate Code',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Center(
                              child: Text('A 6-digit code will be generated.\nStudents must be on campus to check in',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
