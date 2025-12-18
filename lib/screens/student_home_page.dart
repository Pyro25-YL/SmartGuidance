import 'package:flutter/material.dart';
import 'package:smartguidance/screens/absensi_masuk_page.dart';
import 'package:smartguidance/screens/chatbot_bk_page.dart';
import 'package:smartguidance/screens/jadwal_page.dart';
import 'package:smartguidance/screens/mapel_page.dart';
import 'package:smartguidance/screens/pelanggaran_page.dart';
import 'package:smartguidance/screens/pilih_mapel_materi_page.dart';
import 'package:smartguidance/screens/rekomendasi_jurusan_page.dart';
import 'package:smartguidance/screens/upload_tugas_page.dart';
import 'package:smartguidance/screens/nilai_tugas_page.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Username (Siswa)',
                subtitle: 'Fitur Siswa',
              ),
              FeatureMenuGrid(
                items: [
                  // ===== DAFTAR KELAS =====
                  FeatureItem(
                    label: 'Daftar\nMapel',
                    icon: Icons.class_,
                    iconColor: Colors.pink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PilihMapelMateriPage(),
                        ),
                      );
                    },
                  ),

                  // ===== ABSEN MAPEL =====
                  FeatureItem(
                    label: 'Absen\nMapel',
                    icon: Icons.fact_check,
                    iconColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MapelPage(),
                        ),
                      );
                    },
                  ),

                  // ===== ABSEN MASUK =====
                  FeatureItem(
                    label: 'Absen\nMasuk',
                    icon: Icons.login,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AbsensiMasukPage(),
                        ),
                      );
                    },
                  ),

                  // ===== UPLOAD TUGAS (BARU) =====
                  FeatureItem(
                    label: 'Upload\nTugas',
                    icon: Icons.upload_file,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UploadTugasPage(),
                        ),
                      );
                    },
                  ),

                  // ===== NILAI TUGAS (BARU) =====
                  FeatureItem(
                    label: 'Nilai\nTugas',
                    icon: Icons.grade,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NilaiTugasPage(),
                        ),
                      );
                    },
                  ),

                  // ===== PELANGGARAN =====
                  FeatureItem(
                    label: 'Pelanggaran',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PelanggaranPage(),
                        ),
                      );
                    },
                  ),

                  // ===== JADWAL =====
                  FeatureItem(
                    label: 'Jadwal',
                    icon: Icons.calendar_month,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JadwalPage(),
                        ),
                      );
                    },
                  ),

                  // ===== CHATBOT BK =====
                  FeatureItem(
                    label: 'Chatbot\nBK',
                    icon: Icons.support_agent,
                    iconColor: Colors.deepOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatbotBKPage(),
                        ),
                      );
                    },
                  ),

                  // ===== REKOMENDASI JURUSAN =====
                  FeatureItem(
                    label: 'Rekomendasi\nJurusan',
                    icon: Icons.school,
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RekomendasiJurusanPage(),
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
