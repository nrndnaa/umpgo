import 'package:flutter/material.dart';
import 'package:umpgo_frontend/screens/login.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      elevation: 0,
      centerTitle: true,
      // Profile icon on the left
      leading: const Icon(Icons.person_outline, color: Colors.black, size: 28),
      title: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Logo_UMPSA.png/640px-Logo_UMPSA.png',
        height: 40,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.school),
      ),
      actions: [
        // This is the button from image_651425.png
        PopupMenuButton<String>(
          // Explicitly set the padding and constraints to make sure the tap target is large
          padding: const EdgeInsets.symmetric(horizontal: 10),
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            if (value == 'logout') {
              _showLogoutDialog(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must choose an option
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Confirm logout from UMPSA Go?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back"),
          ),
          TextButton(
            onPressed: () {
              // Navigates back to login.dart
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
