import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/mapel_option.dart';
import '../models/materi_form_data.dart';
import '../widgets/back_button.dart';
import '../services/materi_service.dart';
import 'package:file_picker/file_picker.dart';

class MateriInputPage extends StatefulWidget {
  final AppUser loggedInUser;

  const MateriInputPage({
    super.key,
    required this.loggedInUser,
  });

  @override
  State<MateriInputPage> createState() => _MateriInputPageState();
}

class _MateriInputPageState extends State<MateriInputPage> {
  static const purple = Color(0xFF6667B0);

  final _materiService = MateriService();

  bool _loading = true;
  bool _submitting = false;
  String? _errorMessage;
  String? _statusMessage;

  List<MapelOption> _mapelHariIni = [];
  MapelOption? _selectedMapel;

  PlatformFile? _materiFile;

  @override
  void initState() {
    super.initState();
    _loadMapelHariIni();
  }

  Future<void> _loadMapelHariIni() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      final MateriFormData data = await _materiService.fetchMateriFormData(
        guruId: widget.loggedInUser.id,
      );

      setState(() {
        _mapelHariIni = data.mapelHariIni;
        _selectedMapel = data.selectedMapel;
        _loading = false;
      });

      // debug
      // ignore: avoid_print
      print('Mapel hari ini FE: ${_mapelHariIni.length}');
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  Future<void> _onSelectMapel(MapelOption m) async {
    setState(() {
      _selectedMapel = m;
      _materiFile = null;
      _statusMessage = null;
      _errorMessage = null;
    });

    // Kalau nanti mau load materi terakhir (misal untuk info),
    // bisa pakai _materiService.fetchMateriForMapel di sini.
    try {
      await _materiService.fetchMateriForMapel(
        guruId: widget.loggedInUser.id,
        mapelId: m.id,
      );
    } catch (_) {
      // abaikan kalau error; tidak wajib
    }
  }

  Future<void> _pickFileMateri() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'rar'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _materiFile = result.files.single;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedMapel == null) {
      setState(() {
        _errorMessage = 'Silakan pilih mapel terlebih dahulu.';
      });
      return;
    }

    if (_materiFile == null) {
      setState(() {
        _errorMessage = 'Silakan pilih file materi terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      await _materiService.saveMateri(
        guruId: widget.loggedInUser.id,
        mapelId: _selectedMapel!.id,
        fileMateri: _materiFile!,
      );

      setState(() {
        _submitting = false;
        _statusMessage = 'Materi berhasil disimpan.';
      });
    } catch (e) {
      setState(() {
        _submitting = false;
        _errorMessage = 'Gagal menyimpan materi: $e';
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
            child:
                _loading ? const CircularProgressIndicator() : _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            width: isWide ? 900 : double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    const BackButtonRounded(),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Input Materi Pembelajaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_statusMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 260,
                            child: _buildLeftMapelPanel(),
                          ),
                          const SizedBox(width: 20),
                          Expanded(child: _buildRightFormPanel()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLeftMapelPanel(),
                          const SizedBox(height: 20),
                          _buildRightFormPanel(),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftMapelPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mapel Hari Ini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (_mapelHariIni.isEmpty)
            const Text(
              'Tidak ada jadwal mapel untuk hari ini.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mapelHariIni.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final m = _mapelHariIni[index];
                final bool selected = _selectedMapel?.id == m.id;

                return InkWell(
                  onTap: () => _onSelectMapel(m),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            selected ? Colors.blue.shade400 : Colors.grey[300]!,
                      ),
                      color:
                          selected ? Colors.blue.shade50 : Colors.grey.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.namaMapel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kelas: ${m.namaKelas ?? '-'}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Jam: ${m.jamMulai} - ${m.jamAkhir}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRightFormPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _selectedMapel != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mata Pelajaran',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: TextEditingController(
                    text: _selectedMapel!.namaMapel,
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Text(
                  'File Materi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                OutlinedButton(
                  onPressed: _pickFileMateri,
                  child: const Text(
                    'Pilih File Materi',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 4),
                if (_materiFile != null)
                  Text(
                    _materiFile!.path!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                    ),
                  )
                else
                  const Text(
                    'Belum ada file dipilih.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 4),
                const Text(
                  'PDF/DOC/PPT/ZIP/RAR, maks 10MB (sesuai validasi backend).',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan Materi',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            )
          : const Text(
              'Silakan pilih mapel di sebelah kiri terlebih dahulu.\n'
              'Jika belum mengisi absensi, Anda akan otomatis diarahkan ke halaman absensi guru (atur di backend/API).',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
    );
  }
}
