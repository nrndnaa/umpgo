import 'package:flutter/material.dart';

class RegNav extends StatelessWidget {
  const RegNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 98, 158, 135),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Pop all routes back to dashboard
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
