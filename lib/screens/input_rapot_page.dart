import 'package:flutter/material.dart';
import '../models/rapot_form_data.dart';
import '../services/rapot_service.dart';
import '../widgets/back_button.dart';

class InputRapotPage extends StatefulWidget {
  const InputRapotPage({super.key});

  @override
  State<InputRapotPage> createState() => _InputRapotPageState();
}

class _InputRapotPageState extends State<InputRapotPage> {
  static const purple = Color(0xFF6667B0);

  final _formKey = GlobalKey<FormState>();
  late final RapotService _service;

  bool _loading = true;
  bool _saving = false;
  bool _loadingAvg = false;

  String? _error;
  String? _infoAvg;

  List<RapotUserOption> _murid = [];
  List<RapotKelasOption> _kelas = [];
  List<RapotMapelOption> _mapel = [];
  List<String> _semester = [];

  RapotUserOption? _selectedMurid;
  RapotKelasOption? _selectedKelas;
  RapotMapelOption? _selectedMapel;
  String? _selectedSemester;

  double? _avgGabungan;
  final _nilaiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = RapotService('http://127.0.0.1:8000'); // ganti sesuai device
    _load();
  }

  @override
  void dispose() {
    _nilaiCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _avgGabungan = null;
      _infoAvg = null;
    });

    try {
      final data = await _service.fetchForm();

      if (!mounted) return;
      setState(() {
        _murid = data.murid;
        _kelas = data.kelas;
        _mapel = data.mapel;
        _semester = data.semester;

        _selectedMurid = _murid.isNotEmpty ? _murid.first : null;
        _selectedKelas = _kelas.isNotEmpty ? _kelas.first : null;
        _selectedMapel = _mapel.isNotEmpty ? _mapel.first : null;
        _selectedSemester = _semester.isNotEmpty ? _semester.first : null;

        _loading = false;
      });

      // auto hitung avg saat pertama kali load (kalau ada)
      await _refreshAvg();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refreshAvg() async {
    final murid = _selectedMurid;
    final mapel = _selectedMapel;
    if (murid == null || mapel == null) return;

    setState(() {
      _loadingAvg = true;
      _avgGabungan = null;
      _infoAvg = null;
    });

    try {
      final avg = await _service.fetchAvg(murid.id, mapel.id);
      if (!mounted) return;

      setState(() {
        _avgGabungan = avg;
        _infoAvg = avg == null ? 'Belum ada data nilai/nilai ujian.' : null;
        _loadingAvg = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingAvg = false;
        _infoAvg = 'Gagal hitung rata-rata: $e';
      });
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedMurid == null ||
        _selectedKelas == null ||
        _selectedMapel == null ||
        _selectedSemester == null) return;

    final nilai = int.parse(_nilaiCtrl.text.trim());

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _service.save(
        muridId: _selectedMurid!.id,
        kelasId: _selectedKelas!.id,
        mapelId: _selectedMapel!.id,
        semester: _selectedSemester!,
        nilai: nilai,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rapot berhasil disimpan')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
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
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                        key: _formKey,
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
                                  child: Icon(Icons.edit_note,
                                      color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Input Rapot',
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

                            if (_error != null) ...[
                              Text(_error!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                              const SizedBox(height: 12),
                            ],

                            _label('Murid'),
                            _purpleDropdown<RapotUserOption>(
                              value: _selectedMurid,
                              hint: '-- Pilih Murid --',
                              items: _murid,
                              itemBuilder: (u) =>
                                  (u.nisnNip != null && u.nisnNip!.isNotEmpty)
                                      ? '${u.name} — ${u.nisnNip}'
                                      : u.name,
                              onChanged: (v) async {
                                setState(() => _selectedMurid = v);
                                await _refreshAvg();
                              },
                              validator: (v) =>
                                  v == null ? 'Murid wajib dipilih' : null,
                            ),
                            const SizedBox(height: 14),

                            _label('Kelas'),
                            _purpleDropdown<RapotKelasOption>(
                              value: _selectedKelas,
                              hint: '-- Pilih Kelas --',
                              items: _kelas,
                              itemBuilder: (k) => k.namaKelas,
                              onChanged: (v) =>
                                  setState(() => _selectedKelas = v),
                              validator: (v) =>
                                  v == null ? 'Kelas wajib dipilih' : null,
                            ),
                            const SizedBox(height: 14),

                            _label('Mapel'),
                            _purpleDropdown<RapotMapelOption>(
                              value: _selectedMapel,
                              hint: '-- Pilih Mapel --',
                              items: _mapel,
                              itemBuilder: (m) => m.namaMapel,
                              onChanged: (v) async {
                                setState(() => _selectedMapel = v);
                                await _refreshAvg();
                              },
                              validator: (v) =>
                                  v == null ? 'Mapel wajib dipilih' : null,
                            ),
                            const SizedBox(height: 14),

                            // AVG BOX
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: purple.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: purple.withOpacity(0.25)),
                              ),
                              child: _loadingAvg
                                  ? const Text('Menghitung rata-rata...',
                                      style: TextStyle(fontSize: 12))
                                  : Text(
                                      _avgGabungan != null
                                          ? 'Rata-rata Nilai + Ujian: ${_avgGabungan!.toStringAsFixed(2)}'
                                          : (_infoAvg ??
                                              'Rata-rata Nilai + Ujian: -'),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                            const SizedBox(height: 14),

                            _label('Semester'),
                            _purpleDropdown<String>(
                              value: _selectedSemester,
                              hint: '-- Pilih Semester --',
                              items: _semester,
                              itemBuilder: (s) => s,
                              onChanged: (v) =>
                                  setState(() => _selectedSemester = v),
                              validator: (v) =>
                                  v == null ? 'Semester wajib dipilih' : null,
                            ),
                            const SizedBox(height: 14),

                            _label('Nilai Rapot (0-100)'),
                            TextFormField(
                              controller: _nilaiCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'contoh: 88',
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return 'Nilai wajib diisi';
                                final n = int.tryParse(s);
                                if (n == null) return 'Nilai harus angka';
                                if (n < 0 || n > 100)
                                  return 'Nilai harus 0-100';
                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saving ? null : _save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: purple,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _saving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        'Simpan Rapot',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      );

  Widget _purpleDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) itemBuilder,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return SizedBox(
      height: 46,
      child: DropdownButtonFormField<T>(
        value: value,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: purple,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        dropdownColor: purple,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        hint: Text(hint,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(itemBuilder(e),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
