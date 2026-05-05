import 'package:flutter/material.dart';

class TreasuryNav extends StatelessWidget {
  const TreasuryNav({super.key});

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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home),
            Icon(Icons.settings),
            Icon(Icons.notifications_none),
            Icon(Icons.person_outline),
          ],
        ),
      ),
    );
  }
}
