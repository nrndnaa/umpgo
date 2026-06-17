import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'attendanceSuccess.dart';

class LocationVerify extends StatefulWidget {
  final StudentModel student;
  final String subjectName;
  final String subjectCode;
  final String code;
  final int? sectionID;
  final int? moduleID;
  final bool isKoko;
  final Map<String, dynamic> sessionData;

  const LocationVerify({
    Key? key,
    required this.student,
    required this.subjectName,
    required this.subjectCode,
    required this.code,
    required this.sessionData,
    this.sectionID,
    this.moduleID,
    this.isKoko = false,
  }) : super(key: key);

  @override
  State<LocationVerify> createState() => _LocationVerifyState();
}

class _LocationVerifyState extends State<LocationVerify> {
  bool? _locationResult;
  bool _isLoading = true;
  bool _isConfirming = false;
  double? _distanceMeters;
  Position? _position;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _error = 'GPS is disabled'; _isLoading = false; _locationResult = false; });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          setState(() { _error = 'Permission denied'; _isLoading = false; _locationResult = false; });
          return;
        }
      }
      _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double venueLat = double.tryParse(widget.sessionData['venueLat']?.toString() ?? '') ?? 3.5480;
      double venueLng = double.tryParse(widget.sessionData['venueLng']?.toString() ?? '') ?? 103.4241;
      _distanceMeters = Geolocator.distanceBetween(_position!.latitude, _position!.longitude, venueLat, venueLng);
      setState(() { _locationResult = _distanceMeters! <= 200; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Location error: $e'; _isLoading = false; _locationResult = false; });
    }
  }

  Future<void> _confirmCheckIn() async {
    setState(() => _isConfirming = true);
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.checkIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': widget.code,
          'studentID': widget.student.studentID,
          if (widget.sectionID != null) 'sectionID': widget.sectionID,
          if (widget.moduleID != null) 'moduleID': widget.moduleID,
          'latitude': _position?.latitude,
          'longitude': _position?.longitude,
          'gpsVerified': true,
        }),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => AttendanceSuccess(
            student: widget.student,
            subjectName: widget.subjectName,
            subjectCode: widget.subjectCode,
            sessionData: widget.sessionData,
            isKoko: widget.isKoko,
          ),
        ));
      } else {
        setState(() => _error = data['message']);
      }
    } catch (e) {
      setState(() => _error = 'Connection error');
    } finally {
      setState(() => _isConfirming = false);
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
            child: const Text('Menu > Location Verification',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locationResult == true ? _buildSuccess() : _buildFailed(),
          ),
          StudNav(student: widget.student),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Container(
          height: 120, width: double.infinity,
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.location_on, color: Colors.green, size: 36),
            SizedBox(height: 4),
            Text('Faculty Of Computing, UMPSA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
          child: Row(children: const [
            Icon(Icons.check_box, color: Colors.green, size: 18),
            SizedBox(width: 8),
            Text('You are on campus\nWithin 200m of Faculty Of Computing', style: TextStyle(color: Colors.green, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 16),
        _infoRow('Subject', widget.subjectName),
        _infoRow('Session', widget.sessionData['sessionTitle'] ?? ''),
        _infoRow('Date', DateTime.now().toString().substring(0, 10)),
        _infoRow('Time', DateTime.now().toString().substring(11, 16)),
        _infoRow('Code', widget.code),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: _isConfirming ? null : _confirmCheckIn,
          child: _isConfirming ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Confirm Check-In', style: TextStyle(color: Colors.white)),
        )),
        const SizedBox(height: 8),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ]),
    );
  }

  Widget _buildFailed() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Container(
          height: 120, width: double.infinity,
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.location_off, color: Colors.red, size: 36),
            SizedBox(height: 4),
            Text('Faculty Of Computing, UMPSA', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red)),
          child: Column(children: [
            const Icon(Icons.block, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            const Text('Outside Campus Range', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(_distanceMeters != null ? 'You are approximately ${(_distanceMeters! / 1000).toStringAsFixed(1)}km away.\nCheck-in requires within 200 metres.' : _error ?? 'Location check failed',
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 16),
        _infoRow('Subject', widget.subjectName),
        _infoRow('Code', widget.code),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: _checkLocation,
          child: const Text('Retry Location Check', style: TextStyle(color: Colors.white)),
        )),
        const SizedBox(height: 8),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ]),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    ]),
  );
}
