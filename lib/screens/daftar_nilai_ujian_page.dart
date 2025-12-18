import 'package:flutter/material.dart';
import 'package:smartguidance/screens/input_nilai_ujian_page.dart';
import '../models/nilai_ujian_item.dart';
import '../services/nilai_ujian_service.dart';
import '../widgets/back_button.dart';

class DaftarNilaiUjianPage extends StatefulWidget {
  const DaftarNilaiUjianPage({super.key});

  @override
  State<DaftarNilaiUjianPage> createState() => _DaftarNilaiUjianPageState();
}

class _DaftarNilaiUjianPageState extends State<DaftarNilaiUjianPage> {
  static const purple = Color(0xFF6667B0);

  late final NilaiUjianService _service;

  bool _loading = true;
  String? _error;
  List<NilaiUjianItem> _items = [];

  @override
  void initState() {
    super.initState();
    _service = NilaiUjianService(baseUrl: 'http://127.0.0.1:8000');
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _service.fetchNilaiUjian();
      if (!mounted) return;
      setState(() {
        _items = rows;
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
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(20),
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
                          child: Icon(Icons.assignment, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Daftar Nilai Ujian',
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
                              MaterialPageRoute(
                                builder: (_) => const InputNilaiUjianPage(),
                              ),
                            );
                            if (saved == true) _load();
                          },
                          icon: const Icon(Icons.add_circle, color: purple),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_loading) ...[
                      const LinearProgressIndicator(),
                    ] else if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ] else if (_items.isEmpty) ...[
                      const Text(
                        'Belum ada data nilai ujian.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
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

  Widget _card(NilaiUjianItem n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                n.nilai.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.mapel?.namaMapel ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  n.murid?.name ?? '-',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  n.jenisUjian,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
