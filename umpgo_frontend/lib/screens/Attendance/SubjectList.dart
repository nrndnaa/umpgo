import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umpgo_frontend/config/api.dart';
import 'package:umpgo_frontend/domain/student_model.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/widgets/stud_nav.dart';
import 'checkIn.dart';

class SubjectList extends StatefulWidget {
  final StudentModel student;
  const SubjectList({Key? key, required this.student}) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  List<Map<String, dynamic>> _sections = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.studentSections(widget.student.studentID)),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final List<Map<String, dynamic>> all =
            List<Map<String, dynamic>>.from(data['sections']);
        final seen = <String>{};
        final unique = all.where((s) => seen.add(s['subjectCode'] ?? '')).toList();
        setState(() => _sections = unique);
      } else {
        setState(() => _error = data['message']);
      }
    } catch (e) {
      setState(() => _error = 'Could not connect to server.');
    } finally {
      setState(() => _isLoading = false);
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
            child: const Text('Menu > List of Subject',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_error!, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: _load, child: const Text('Retry')),
                        ],
                      ))
                    : _sections.isEmpty
                        ? const Center(child: Text('No subjects found'))
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('My Courses',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.15,
                                    ),
                                    itemCount: _sections.length,
                                    itemBuilder: (context, i) => _SubjectCard(
                                      section: _sections[i],
                                      onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => CheckIn(
                                          student: widget.student,
                                          sectionID: _sections[i]['sectionID'],
                                          subjectName: _sections[i]['subjectName'] ?? '',
                                          subjectCode: _sections[i]['subjectCode'] ?? '',
                                          isKoko: false,
                                        )),
                                      ),
                                    ),
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
}

class _SubjectCard extends StatelessWidget {
  final Map<String, dynamic> section;
  final VoidCallback onTap;
  const _SubjectCard({required this.section, required this.onTap});

  String _getImageUrl(String code) {
    const images = {
      'BCS2243': 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=200',
      'BCS3123': 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=200',
      'BCS1013': 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=200',
      'BCS2143': 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=200',
      'BCS2043': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=200',
      'BCS3233': 'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=200',
      'BCS2213': 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=200',
      'BCS3013': 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=200',
      'BCN2163': 'https://images.unsplash.com/photo-1520869562399-e772f042f422?w=200',
      'BCI4113': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=200',
    };
    return images[code] ?? 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=200';
  }

  @override
  Widget build(BuildContext context) {
    final code = section['subjectCode'] ?? '';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5B9BD5).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                _getImageUrl(code),
                height: 70,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 70,
                  color: const Color(0xFF5B9BD5).withOpacity(0.2),
                  child: const Center(
                      child: Icon(Icons.book, color: Color(0xFF5B9BD5), size: 32)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(code,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(section['subjectName'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}