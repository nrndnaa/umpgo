import 'package:flutter/material.dart';

/// Shared theme data for each role dashboard
class RoleTheme {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color bg;

  const RoleTheme({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.bg,
  });

  // Blue — Student
  static const student = RoleTheme(
    primary: Color(0xFF1E6FBF),
    primaryDark: Color(0xFF0D47A1),
    primaryLight: Color(0xFFD6E8F8),
    bg: Color(0xFFF4F7FB),
  );

  // Green — Registrar
  static const registrar = RoleTheme(
    primary: Color(0xFF2E7D32),
    primaryDark: Color(0xFF1B5E20),
    primaryLight: Color(0xFFD4EDDA),
    bg: Color(0xFFF3FAF4),
  );

  // Purple — Treasury
  static const treasury = RoleTheme(
    primary: Color(0xFF6A1B9A),
    primaryDark: Color(0xFF4A148C),
    primaryLight: Color(0xFFEDE0F5),
    bg: Color(0xFFF8F3FC),
  );

  // Orange — Lecturer
  static const lecturer = RoleTheme(
    primary: Color(0xFFE65100),
    primaryDark: Color(0xFFBF360C),
    primaryLight: Color(0xFFFFE0CC),
    bg: Color(0xFFFFF8F4),
  );
}

/// Shared dashboard card widget
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final RoleTheme theme;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.primaryLight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: theme.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 28, color: theme.primary),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2B45),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.primary.withOpacity(0.5),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared welcome banner
class WelcomeBanner extends StatelessWidget {
  final String name;
  final String subtitle;
  final String role;
  final IconData roleIcon;
  final RoleTheme theme;

  const WelcomeBanner({
    super.key,
    required this.name,
    required this.subtitle,
    required this.role,
    required this.roleIcon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryDark, theme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.80),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(roleIcon, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }
}

/// Shared header bar
class DashboardHeader extends StatelessWidget {
  final String name;
  final String idLabel;
  final RoleTheme theme;
  final IconData avatarIcon;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.idLabel,
    required this.theme,
    required this.avatarIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(avatarIcon, color: theme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2B45),
                  ),
                ),
                Text(
                  idLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7C93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
