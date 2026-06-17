import 'package:flutter/material.dart';
import 'package:umpgo_frontend/domain/student_model.dart';

class StudNav extends StatelessWidget {
  final StudentModel? student;
  const StudNav({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFD8F1FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
            const Icon(Icons.settings),
            const Icon(Icons.notifications_none),
            const Icon(Icons.person_outline),
          ],
        ),
      ),
    );
  }
}