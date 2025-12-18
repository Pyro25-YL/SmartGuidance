import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

import '../services/mapel_service.dart';
import '../models/mapel_summary.dart';

class MapelListPage extends StatefulWidget {
  const MapelListPage({super.key});

  @override
  State<MapelListPage> createState() => _MapelListPageState();
}

class _MapelListPageState extends State<MapelListPage> {
  final _mapelService = MapelService();

  late Future<List<MapelSummary>> _futureMapel;

  @override
  void initState() {
    super.initState();
    _futureMapel = _mapelService.fetchMapelList();
  }

  Future<void> _reload() async {
    setState(() {
      _futureMapel = _mapelService.fetchMapelList();
    });
  }

  void _goToAddMapel() {
    Navigator.pushNamed(context, '/add-mapel').then((_) {
      _reload();
    });
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
                    // ===== HEADER + BACK + ADD MAPEL =====
                    Row(
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.menu_book,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Daftar Mapel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _goToAddMapel,
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
                            'Add Mapel',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // ===== LIST MAPEL =====
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _reload,
                        child: FutureBuilder<List<MapelSummary>>(
                          future: _futureMapel,
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
                                      'Gagal memuat data mapel: ${snapshot.error}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final list = snapshot.data ?? [];

                            if (list.isEmpty) {
                              return ListView(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Belum ada mapel terdaftar.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.separated(
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final m = list[index];
                                return _MapelCard(item: m);
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

class _MapelCard extends StatelessWidget {
  final MapelSummary item;

  const _MapelCard({required this.item});

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
            child: const Icon(Icons.menu_book, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Mapel
                Text(
                  item.namaMapel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 4),

                // Kelas + Hari
                Text(
                  '${item.kelasNama} • ${item.hari}',
                  style: const TextStyle(fontSize: 12),
                ),

                // Jam + Guru
                Text(
                  '${item.jamMulai} - ${item.jamAkhir} • ${item.guruNama}',
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
  }
}
