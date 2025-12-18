import 'package:flutter/material.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart'; // hanya ini yang dipakai

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _namaC = TextEditingController();
  final _nisnNipC = TextEditingController();
  final _passwordC = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;

  String? _errorMessage;

  @override
  void dispose() {
    _namaC.dispose();
    _nisnNipC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final name = _namaC.text.trim();
    final nisnNip = _nisnNipC.text.trim();
    final password = _passwordC.text.trim();

    if (name.isEmpty || nisnNip.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Nama, NISN/NIP dan password wajib diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = LoginRequest(
        name: name,
        nisnNip: nisnNip,
        password: password,
      );

      final result = await _authService.login(request);

      if (!result.success) {
        setState(() {
          _errorMessage =
              result.message.isNotEmpty ? result.message : 'Login gagal.';
        });
        return;
      }

      // ==== AMBIL ROLE & USER DARI RESULT ====
      final role = result.role; // misal 'guru', 'admin', dst
      final user = result.user; // pastikan LoginResult punya field ini

      // ==== SIMPAN SESSION (role + data user) ====
      await SessionManager.saveSession(
        role,
        userJson: user?.toJson(), // kalau null juga aman
      );

      // ==== Arahkan sesuai role ====
      if (role == 'murid') {
        Navigator.pushReplacementNamed(context, '/student');
      } else if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (role == 'guru') {
        Navigator.pushReplacementNamed(context, '/teacher');
      } else if (role == 'wali_murid') {
        Navigator.pushReplacementNamed(context, '/parent');
      } else {
        setState(() {
          _errorMessage = 'Role pengguna tidak dikenali: $role';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal login: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCBD5FF),
              Color(0xFFFDF4E3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Container(
              width: 260,
              height: 500,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar bulat
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // === Kolom Nama ===
                  _LoginField(
                    controller: _namaC,
                    hint: 'Nama',
                  ),
                  const SizedBox(height: 14),

                  // === Kolom NISN / NIP ===
                  _LoginField(
                    controller: _nisnNipC,
                    hint: 'NISN / NIP',
                  ),
                  const SizedBox(height: 14),

                  // === Kolom Password ===
                  _LoginField(
                    controller: _passwordC,
                    hint: 'Password',
                    obscure: true,
                  ),

                  const SizedBox(height: 6),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // TODO: aksi lupa password
                      },
                      child: const Text(
                        'Lupa Password',
                        style: TextStyle(
                          fontSize: 12,
                          color: purple,
                        ),
                      ),
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget kecil untuk kolom ungu seperti pada desain
class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const _LoginField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: const InputDecoration(
          filled: true,
          fillColor: purple,
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ).copyWith(hintText: hint),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
