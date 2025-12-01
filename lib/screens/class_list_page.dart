import 'package:flutter/material.dart';

import '../services/class_service.dart';
import '../models/class_summary.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  final _classService = ClassService();

  late Future<List<ClassSummary>> _futureClasses;

  @override
  void initState() {
    super.initState();
    _futureClasses = _classService.fetchClasses();
  }

  Future<void> _reload() async {
    setState(() {
      _futureClasses = _classService.fetchClasses();
    });
  }

  void _goToAddClass() {
    // nanti bisa diarahkan ke halaman tambah kelas beneran
    // contoh: Navigator.pushNamed(context, '/add-class');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigasi ke halaman tambah kelas (TODO).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

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
                  color: Colors.white.withOpacity(0.95),
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
                    // HEADER + tombol Add
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.class_, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Daftar Kelas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _goToAddClass,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text(
                            'Add Kelas',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),

                    const SizedBox(height: 12),

                    // LIST KELAS
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _reload,
                        child: FutureBuilder<List<ClassSummary>>(
                          future: _futureClasses,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Gagal memuat data kelas: ${snapshot.error}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final classes = snapshot.data ?? [];

                            if (classes.isEmpty) {
                              return ListView(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Belum ada data kelas.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.separated(
                              itemCount: classes.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final c = classes[index];
                                return _ClassCard(item: c);
                              },
                            );
                          },
                        ),
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

class _ClassCard extends StatelessWidget {
  final ClassSummary item;

  const _ClassCard({required this.item});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            child:
                const Icon(Icons.meeting_room, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaKelas,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Walikelas: ${item.waliNama ?? '-'}'
                  '${item.waliNisnNip != null ? " (${item.waliNisnNip})" : ""}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Jumlah siswa: ${item.jumlahSiswa}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
