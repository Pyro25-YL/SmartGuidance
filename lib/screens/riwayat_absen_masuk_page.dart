import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

class RiwayatAbsenMasukPage extends StatelessWidget {
  const RiwayatAbsenMasukPage({super.key});

  static const purple = Color(0xFF6667B0);

  static final data = [
    {'tanggal': '01 Okt 2024', 'jam': '06:45', 'status': 'Hadir'},
    {'tanggal': '02 Okt 2024', 'jam': '06:58', 'status': 'Terlambat'},
    {'tanggal': '03 Okt 2024', 'jam': '-', 'status': 'Tidak Hadir'},
  ];

  @override
  Widget build(BuildContext context) {
    return _basePage(
      title: 'Riwayat Absen Masuk',
      icon: Icons.login,
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final d = data[i];
          return _card(
            title: d['tanggal']!,
            subtitle: 'Jam Masuk: ${d['jam']}',
            status: d['status']!,
          );
        },
      ),
    );
  }

  Widget _card(
      {required String title,
      required String subtitle,
      required String status}) {
    Color color = status == 'Hadir'
        ? Colors.green
        : status == 'Terlambat'
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: purple)),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text(status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _basePage(
      {required String title, required IconData icon, required Widget child}) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBD5FF), Color(0xFFFDF4E3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: purple)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
