import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  static const purple = Color(0xFF6667B0);

  // ===== DATA JADWAL STATIK =====
  static final List<Map<String, String>> jadwalList = [
    {
      'mapel': 'Matematika',
      'hari': 'Senin',
      'jam': '07:00 - 08:30',
      'kelas': 'X IPA',
      'guru': 'Pak Andi',
    },
    {
      'mapel': 'Bahasa Indonesia',
      'hari': 'Senin',
      'jam': '08:30 - 10:00',
      'kelas': 'X IPA',
      'guru': 'Bu Rina',
    },
    {
      'mapel': 'Fisika',
      'hari': 'Selasa',
      'jam': '07:00 - 08:30',
      'kelas': 'XI IPA',
      'guru': 'Pak Budi',
    },
    {
      'mapel': 'Kimia',
      'hari': 'Rabu',
      'jam': '10:00 - 11:30',
      'kelas': 'XI IPA',
      'guru': 'Bu Sari',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: 380,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: const [
                        BackButtonRounded(),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.schedule,
                              color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Jadwal Pelajaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // ===== LIST JADWAL =====
                    Expanded(
                      child: ListView.separated(
                        itemCount: jadwalList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final j = jadwalList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                // ICON
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.menu_book,
                                      color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 10),

                                // INFO JADWAL
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        j['mapel']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: purple,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${j['hari']} • ${j['jam']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '${j['kelas']} • ${j['guru']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
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
