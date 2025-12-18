import 'package:flutter/material.dart';
import 'package:smartguidance/screens/absensi_guru_page.dart';
import 'package:smartguidance/screens/daftar_nilai_page.dart';
import 'package:smartguidance/screens/daftar_nilai_ujian_page.dart';
import 'package:smartguidance/screens/daftar_rapot_page.dart';
import 'package:smartguidance/screens/materi_input_page.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';
import '../models/app_user.dart';
import '../services/session_manager.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  AppUser? _currentUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final json = await SessionManager.getUserJson();

    if (!mounted) return;

    if (json != null) {
      setState(() {
        _currentUser = AppUser.fromJson(json);
        _loading = false;
      });
    } else {
      _loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data guru tidak ditemukan, silakan login ulang'),
        ),
      );
      await SessionManager.clearSession();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Terjadi kesalahan sesi')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Guru',
                subtitle: 'Manajemen Akademik',
              ),
              FeatureMenuGrid(
                items: [
                  // ===== MATERI =====
                  FeatureItem(
                    label: 'Upload\nMateri',
                    icon: Icons.upload_file_rounded,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MateriInputPage(
                            loggedInUser: user,
                          ),
                        ),
                      );
                    },
                  ),

                  // ===== NILAI TUGAS =====
                  FeatureItem(
                    label: 'Nilai\nTugas',
                    icon: Icons.assignment_turned_in_rounded,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DaftarNilaiPage(
                            loggedInUser: user,
                          ),
                        ),
                      );
                    },
                  ),

                  // ===== NILAI UJIAN =====
                  FeatureItem(
                    label: 'Nilai\nUjian',
                    icon: Icons.fact_check_rounded,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DaftarNilaiUjianPage(),
                        ),
                      );
                    },
                  ),

                  // ===== RAPOT =====
                  FeatureItem(
                    label: 'Nilai\nRapot',
                    icon: Icons.school_rounded,
                    iconColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DaftarRapotPage(),
                        ),
                      );
                    },
                  ),

                  // ===== ABSENSI GURU =====
                  FeatureItem(
                    label: 'Absensi\nGuru',
                    icon: Icons.how_to_reg_rounded,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AbsensiGuruPage(
                            loggedInUser: user,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
