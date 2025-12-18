import 'package:flutter/material.dart';
import 'package:smartguidance/screens/input_nilai_page.dart';
import '../models/app_user.dart';
import '../models/nilai_item.dart';
import '../services/nilai_service.dart';
import '../widgets/back_button.dart';

class DaftarNilaiPage extends StatefulWidget {
  final AppUser loggedInUser;

  const DaftarNilaiPage({
    super.key,
    required this.loggedInUser,
  });

  @override
  State<DaftarNilaiPage> createState() => _DaftarNilaiPageState();
}

class _DaftarNilaiPageState extends State<DaftarNilaiPage> {
  static const purple = Color(0xFF6667B0);

  late final NilaiService _service;

  bool _isLoading = true;
  String? _error;
  List<NilaiItem> _items = [];

  @override
  void initState() {
    super.initState();

    _service = NilaiService(
      baseUrl: 'http://127.0.0.1:8000', // ganti sesuai server kamu
    );

    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rows =
          await _service.fetchNilaiGuru(guruId: widget.loggedInUser.id);

      if (!mounted) return;
      setState(() {
        _items = rows;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
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
                width: 360,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    Row(
                      children: const [
                        BackButtonRounded(),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(Icons.list_alt,
                              color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Daftar Nilai (Guru Login)',
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
                    if (_isLoading) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 12),
                    ] else if (_error != null) ...[
                      Text(
                        'Gagal memuat: $_error',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _load,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ] else if (_items.isEmpty) ...[
                      const Text(
                        'Belum ada data nilai.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ] else ...[
                      ..._items.map(_nilaiCard),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final saved = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InputNilaiPage(
                                  loggedInUser: widget.loggedInUser),
                            ),
                          );

                          if (saved == true)
                            _load(); // refresh list setelah sukses
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Input Nilai',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _nilaiCard(NilaiItem n) {
    final mapel = (n.mapel?.namaMapel.isNotEmpty == true)
        ? n.mapel!.namaMapel
        : 'Mapel #${n.mapelId}';

    final muridName = (n.murid?.name.isNotEmpty == true)
        ? n.murid!.name
        : 'Murid #${n.muridId}';

    final nisn = (n.murid?.nisnNip != null && n.murid!.nisnNip!.isNotEmpty)
        ? n.murid!.nisnNip!
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
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
                '${n.nilai}',
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
                Text(mapel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  nisn != null ? '$muridName — $nisn' : muridName,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}
