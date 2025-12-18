import 'package:flutter/material.dart';
import '../services/session_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final loggedIn = await SessionManager.isLoggedIn();

      String targetRoute = '/login';

      if (loggedIn) {
        final role = await SessionManager.getRole();
        switch (role) {
          case 'admin':
            targetRoute = '/admin';
            break;
          case 'guru':
            targetRoute = '/teacher';
            break;
          case 'murid':
            targetRoute = '/student';
            break;
          case 'wali_murid':
            targetRoute = '/parent';
            break;
          default:
            targetRoute = '/login';
        }
      }

      if (!mounted) return;

      // Ganti halaman, hapus splash dari stack
      Navigator.pushReplacementNamed(context, targetRoute);
    } catch (e) {
      debugPrint('Error cek session: $e');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
