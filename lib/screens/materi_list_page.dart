import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

class MateriListPage extends StatelessWidget {
  const MateriListPage({super.key});

  static const purple = Color(0xFF6667B0);

  // ===== DATA MATERI STATIK =====
  static final List<Map<String, String>> materiList = [
    {
      'judul': 'Pengenalan',
      'deskripsi': 'Pendahuluan materi dan tujuan pembelajaran',
    },
    {
      'judul': 'Materi Inti',
      'deskripsi': 'Pembahasan konsep utama',
    },
    {
      'judul': 'Latihan Soal',
      'deskripsi': 'Contoh soal dan pembahasan',
    },
    {
      'judul': 'Rangkuman',
      'deskripsi': 'Ringkasan materi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mapel =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.article,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Materi ${mapel['nama']}',
                            style: const TextStyle(
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

                    // ===== LIST MATERI =====
                    Expanded(
                      child: ListView.separated(
                        itemCount: materiList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final m = materiList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.description, color: purple),
                                const SizedBox(width: 10),

                                // ===== TEXT MATERI =====
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m['judul']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: purple,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        m['deskripsi']!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // ===== TOMBOL DOWNLOAD =====
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Download ${m['judul']}',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: purple,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.download,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Download',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
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
