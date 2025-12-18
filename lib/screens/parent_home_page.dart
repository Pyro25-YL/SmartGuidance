import 'package:flutter/material.dart';
import 'package:smartguidance/screens/mapel_page.dart';
import 'package:smartguidance/screens/nilai_tugas_page.dart';
import 'package:smartguidance/screens/pelanggaran_page.dart';
import 'package:smartguidance/screens/monitor_lokasi_anak_page.dart';
import 'package:smartguidance/screens/riwayat_absen_mapel_page.dart';
import 'package:smartguidance/screens/riwayat_absen_masuk_page.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Orang Tua',
                subtitle: 'Monitoring & Akademik Anak',
              ),
              FeatureMenuGrid(
                items: [
                  // ===== NILAI =====
                  FeatureItem(
                    label: 'Nilai\nTugas',
                    icon: Icons.bar_chart_rounded,
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NilaiTugasPage(),
                        ),
                      );
                    },
                  ),

                  FeatureItem(
                    label: 'Absen\nMasuk',
                    icon: Icons.login_rounded,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiwayatAbsenMasukPage(),
                        ),
                      );
                    },
                  ),

                  FeatureItem(
                    label: 'Absen\nMapel',
                    icon: Icons.menu_book_rounded,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiwayatAbsenMapelPage(),
                        ),
                      );
                    },
                  ),

                  // ===== MONITOR LOKASI =====
                  FeatureItem(
                    label: 'Lokasi\nAnak',
                    icon: Icons.location_on_rounded,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MonitorLokasiAnakPage(),
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

                  // ===== JADWAL / MAPEL =====
                  FeatureItem(
                    label: 'Jadwal\nPelajaran',
                    icon: Icons.schedule_rounded,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
