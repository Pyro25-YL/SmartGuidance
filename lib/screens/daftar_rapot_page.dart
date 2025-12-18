import 'package:flutter/material.dart';
import '../services/rapot_service.dart';
import '../widgets/back_button.dart';
import 'input_rapot_page.dart';

// ===== MODEL ITEM RAPOT (simple) =====
class RapotItem {
  final int id;
  final int muridId;
  final int kelasId;
  final int mapelId;
  final String semester;
  final int nilai;

  final String? muridName;
  final String? muridNisn;
  final String? kelasNama;
  final String? mapelNama;

  RapotItem({
    required this.id,
    required this.muridId,
    required this.kelasId,
    required this.mapelId,
    required this.semester,
    required this.nilai,
    this.muridName,
    this.muridNisn,
    this.kelasNama,
    this.mapelNama,
  });

  factory RapotItem.fromJson(Map<String, dynamic> json) {
    final murid = json['murid'];
    final kelas = json['kelas'];
    final mapel = json['mapel'];

    return RapotItem(
      id: json['id'] ?? 0,
      muridId: json['murid_id'] ?? 0,
      kelasId: json['kelas_id'] ?? 0,
      mapelId: json['mapel_id'] ?? 0,
      semester: (json['semester'] ?? '').toString(),
      nilai: json['nilai'] ?? 0,
      muridName: murid != null ? (murid['name'] ?? '').toString() : null,
      muridNisn: murid != null ? (murid['nisn_nip'])?.toString() : null,
      kelasNama: kelas != null ? (kelas['nama_kelas'] ?? kelas['namaKelas'] ?? '').toString() : null,
      mapelNama: mapel != null ? (mapel['nama_mapel'] ?? mapel['namaMapel'] ?? mapel['nama'] ?? '').toString() : null,
    );
  }
}

// ===== PAGE =====
class DaftarRapotPage extends StatefulWidget {
  const DaftarRapotPage({super.key});

  @override
  State<DaftarRapotPage> createState() => _DaftarRapotPageState();
}

class _DaftarRapotPageState extends State<DaftarRapotPage> {
  static const purple = Color(0xFF6667B0);

  late final RapotService _service;

  bool _loading = true;
  String? _error;
  List<RapotItem> _items = [];

  @override
  void initState() {
    super.initState();
    _service = RapotService('http://127.0.0.1:8000'); // ganti sesuai device
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _service.fetchRapotRaw(); // method raw di service (lihat di bawah)
      if (!mounted) return;

      setState(() {
        _items = rows.map((e) => RapotItem.fromJson(e)).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: 380,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.school, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Daftar Rapot',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final saved = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(builder: (_) => const InputRapotPage()),
                            );
                            if (saved == true) _load();
                          },
                          icon: const Icon(Icons.add_circle, color: purple),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    if (_loading) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 12),
                    ] else if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _load,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ] else if (_items.isEmpty) ...[
                      const Text('Belum ada data rapot.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ] else ...[
                      ..._items.map(_card),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(RapotItem r) {
    final murid = r.muridName?.isNotEmpty == true ? r.muridName! : 'Murid #${r.muridId}';
    final nisn = (r.muridNisn != null && r.muridNisn!.isNotEmpty) ? r.muridNisn : null;
    final mapel = r.mapelNama?.isNotEmpty == true ? r.mapelNama! : 'Mapel #${r.mapelId}';
    final kelas = r.kelasNama?.isNotEmpty == true ? r.kelasNama! : 'Kelas #${r.kelasId}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(14)),
            child: Center(
              child: Text(
                '${r.nilai}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$mapel • ${r.semester}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(nisn != null ? '$murid — $nisn' : murid, style: const TextStyle(fontSize: 12)),
                Text(kelas, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
