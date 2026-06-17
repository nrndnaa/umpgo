import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'locationVerify.dart';

class CodeEntry extends StatefulWidget {
  final StudentModel student;
  final String subjectName;
  final String subjectCode;
  final int? sectionID;
  final int? moduleID;
  final bool isKoko;

  const CodeEntry({
    Key? key,
    required this.student,
    required this.subjectName,
    required this.subjectCode,
    this.sectionID,
    this.moduleID,
    this.isKoko = false,
  }) : super(key: key);

  @override
  State<CodeEntry> createState() => _CodeEntryState();
}

class _CodeEntryState extends State<CodeEntry> {
  String _code = '';
  bool _isLoading = false;
  Map<String, dynamic>? _sessionData;

  void _onKey(String digit) {
    if (_code.length < 6) {
      HapticFeedback.lightImpact();
      setState(() => _code += digit);
    }
  }

  void _onDelete() {
    if (_code.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _code = _code.substring(0, _code.length - 1));
    }
  }

  Future<void> _submit() async {
    if (_code.length < 6) return;
    setState(() => _isLoading = true);
    try {
      final body = <String, dynamic>{
        'code': _code,
        'studentID': widget.student.studentID,
      };
      if (widget.sectionID != null) body['sectionID'] = widget.sectionID;
      if (widget.moduleID != null) body['moduleID'] = widget.moduleID;

      final response = await http.post(
        Uri.parse(ApiConfig.validateCode),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _sessionData = data['session'];
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 12),
                Text('Code Accepted !',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => LocationVerify(
            student: widget.student,
            subjectName: widget.subjectName,
            subjectCode: widget.subjectCode,
            code: _code,
            sectionID: widget.sectionID,
            moduleID: widget.moduleID,
            isKoko: widget.isKoko,
            sessionData: _sessionData!,
          ),
        ));
      } else {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.cancel, color: Colors.red, size: 48),
                SizedBox(height: 12),
                Text('Invalid Code. Please Try Again',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        setState(() => _code = '');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text('Menu > Check In',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text('Enter 6-digit code\ndisplayed by your lecturer',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 44, height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF5B9BD5), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          i < _code.length ? _code[i] : '',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  _buildNumpad(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.gps_fixed, size: 14, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('GPS must be enabled Â· On campus check-in only',
                          style: TextStyle(fontSize: 11, color: Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Submit & Verify Location',
                              style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StudNav(student: widget.student),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: ['1','2','3'].map(_numKey).toList()),
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: ['4','5','6'].map(_numKey).toList()),
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: ['7','8','9'].map(_numKey).toList()),
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [_numKey('0'), _deleteKey()]),
    ]);
  }

  Widget _numKey(String val) => GestureDetector(
    onTap: () => _onKey(val),
    child: Container(
      margin: const EdgeInsets.all(6),
      width: 64, height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(child: Text(val,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
    ),
  );

  Widget _deleteKey() => GestureDetector(
    onTap: _onDelete,
    child: Container(
      margin: const EdgeInsets.all(6),
      width: 64, height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(child: Icon(Icons.backspace_outlined)),
    ),
  );
}