import 'package:flutter/material.dart';

// Import your dashboards
import 'package:umpgo_frontend/screens/student_dashboard.dart';
import 'package:umpgo_frontend/screens/lecturer_dashboard.dart';
import 'package:umpgo_frontend/screens/registrar_dashboard.dart';
import 'package:umpgo_frontend/screens/treasury_dashboard.dart';
import 'package:umpgo_frontend/screens/adab_dashboard.dart';

// ─── Theme constants ─────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F7FB);
  static const primary = Color(0xFF1E6FBF);
  static const primaryLight = Color(0xFFD6E8F8);
  static const textMain = Color(0xFF1A2B45);
  static const textMuted = Color(0xFF6B7C93);
  static const border = Color(0xFFDDE3EE);
  static const surface = Colors.white;
  static const error = Color(0xFFE53935);
  static const errorLight = Color(0xFFFFEBEE);
}

// ─── Login Controller ────────────────────────────────────────────────────────
class LoginController {
  // Simulated user database
  // Replace this with a real API call later
  static const _mockUsers = {
    "student1": {"password": "pass123", "role": "Student"},
    "lecturer1": {"password": "pass123", "role": "Lecturer"},
    "registrar1": {"password": "pass123", "role": "Faculty Registrar"},
    "treasury1": {"password": "pass123", "role": "Treasury"},
    "adab1": {"password": "pass123", "role": "Pusat Adab"},
  };

  /// Returns an error string if login fails, or null on success.
  /// On success, navigates to the correct dashboard.
  static String? login({
    required BuildContext context,
    required String username,
    required String password,
    required String role,
  }) {
    final trimmedUser = username.trim();
    final trimmedPass = password.trim();

    // Basic validation
    if (trimmedUser.isEmpty) return "Please enter your username.";
    if (trimmedPass.isEmpty) return "Please enter your password.";

    // Check credentials
    final user = _mockUsers[trimmedUser];
    if (user == null || user["password"] != trimmedPass) {
      return "Incorrect username or password.";
    }

    // Check that role matches
    if (user["role"] != role) {
      return "This account is not registered as a $role.";
    }

    // All good — navigate
    _navigateToDashboard(context, role);
    return null;
  }

  static void _navigateToDashboard(BuildContext context, String role) {
    Widget dashboard;

    switch (role) {
      case "Student":
        dashboard = const StudentDashboard();
        break;
      case "Lecturer":
        dashboard = const LecturerDashboard();
        break;
      case "Faculty Registrar":
        dashboard = const RegistrarDashboard();
        break;
      case "Treasury":
        dashboard = const TreasuryDashboard();
        break;
      case "Pusat Adab":
        dashboard = const AdabDashboard();
        break;
      default:
        return;
    }

    // pushReplacement prevents the user from pressing Back to return to Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => dashboard),
    );
  }
}

// ─── Login Screen ────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = "Student";

  final _roles = [
    "Student",
    "Lecturer",
    "Faculty Registrar",
    "Treasury",
    "Pusat Adab",
  ];

  final Map<String, IconData> _roleIcons = {
    "Student": Icons.school_rounded,
    "Lecturer": Icons.person_rounded,
    "Faculty Registrar": Icons.admin_panel_settings_rounded,
    "Treasury": Icons.account_balance_rounded,
    "Pusat Adab": Icons.gamepad_rounded,
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate a short network delay — remove if using a real API
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final error = LoginController.login(
      context: context,
      username: _usernameController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _C.bg,
      body: Stack(
        children: [
          // ── Background image ──────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.42,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/UMP1.jpeg', fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Branding over image ───────────────────────────────────────────
          Positioned(
            top: 52,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: _C.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "UMPGo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Universiti Malaysia Pahang",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                    shadows: const [
                      Shadow(color: Colors.black26, blurRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Login card ────────────────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back 👋",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _C.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Sign in to your UMPGo account",
                      style: TextStyle(
                        fontSize: 14,
                        color: _C.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Role chips
                    const Text(
                      "I am a…",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _C.textMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _roles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final r = _roles[i];
                          final selected = r == _selectedRole;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRole = r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected ? _C.primary : _C.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _roleIcons[r],
                                    size: 15,
                                    color: selected ? Colors.white : _C.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    r,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? Colors.white
                                          : _C.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Username
                    _FieldLabel("Username"),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _usernameController,
                      hint: "e.g. CB23090",
                      prefixIcon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 18),

                    // Password
                    _FieldLabel("Password"),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _passwordController,
                      hint: "Enter your password",
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _C.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 13,
                            color: _C.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Error banner
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _C.errorLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _C.error.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: _C.error,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _C.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        "For IT support, contact helpdesk@ump.edu.my",
                        style: TextStyle(
                          fontSize: 11,
                          color: _C.textMuted.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _C.textMain,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _C.textMain,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _C.textMuted, fontSize: 13),
        prefixIcon: Icon(prefixIcon, color: _C.textMuted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _C.bg,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _C.primary, width: 1.8),
        ),
      ),
    );
  }
}
