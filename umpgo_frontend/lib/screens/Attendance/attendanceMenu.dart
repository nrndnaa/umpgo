import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';

class AttendanceSuccess extends StatefulWidget {
  final StudentModel student;
  final String subjectName;
  final String subjectCode;
  final Map<String, dynamic> sessionData;
  final bool isKoko;

  const AttendanceSuccess({
    Key? key,
    required this.student,
    required this.subjectName,
    required this.subjectCode,
    required this.sessionData,
    this.isKoko = false,
  }) : super(key: key);

  @override
  State<AttendanceSuccess> createState() => _AttendanceSuccessState();
}

class _AttendanceSuccessState extends State<AttendanceSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${now.day} ${_month(now.month)} · '
        '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')} AM';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF5B9BD5),
            child: const Text('Menu > Location Verification',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ScaleTransition(
                      scale: _scale,
                      child: const Text('🎉', style: TextStyle(fontSize: 64)),
                    ),
                    const SizedBox(height: 16),
                    const Text('Checked In Successfully!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Your attendance has been recorded and verified',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 24),
                    // Detail card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _detailRow(widget.isKoko ? 'Module' : 'Subject', widget.subjectName),
                          _detailRow('Session', widget.sessionData['sessionTitle'] ?? ''),
                          _detailRow('Date & Time', dateStr),
                          _detailRow('Location', 'GPS Verified'),
                          _detailRow('Status', 'Present', isStatus: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B9BD5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                        child: const Text('Back', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StudNav(student: widget.student),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isStatus = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        isStatus
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Present',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            : Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    ),
  );

  String _month(int m) => ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'][m-1];
}