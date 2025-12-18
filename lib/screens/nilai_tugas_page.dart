import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

class NilaiTugasPage extends StatelessWidget {
  const NilaiTugasPage({super.key});

  static const purple = Color(0xFF6667B0);

  static final List<Map<String, dynamic>> nilaiTugas = [
    {
      'judul': 'Tugas Persamaan Linear',
      'tanggal': '12 Sep 2024',
      'nilai': 85,
    },
    {
      'judul': 'Tugas Trigonometri',
      'tanggal': '20 Sep 2024',
      'nilai': 90,
    },
    {
      'judul': 'Tugas Limit Fungsi',
      'tanggal': '1 Okt 2024',
      'nilai': 78,
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
                          child:
                              Icon(Icons.grade, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nilai Tugas',
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

                    // ===== LIST NILAI =====
                    Expanded(
                      child: ListView.separated(
                        itemCount: nilaiTugas.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final n = nilaiTugas[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.assignment,
                                      color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n['judul'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: purple,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        n['tanggal'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  n['nilai'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
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
