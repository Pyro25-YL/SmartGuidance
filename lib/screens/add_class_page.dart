import 'package:flutter/material.dart';
import '../services/class_service.dart';
import '../models/guru_option.dart';
import '../widgets/back_button.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _namaKelasC = TextEditingController();
  final _jumlahSiswaC = TextEditingController(text: '0');

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final _classService = ClassService();

  List<GuruOption> _guruList = [];
  GuruOption? _selectedGuru;
  bool _isLoadingGuru = true;
  String? _guruError;

  @override
  void initState() {
    super.initState();
    _loadGuruList();
  }

  Future<void> _loadGuruList() async {
    try {
      final list = await _classService.fetchGuruList();
      if (!mounted) return;
      setState(() {
        _guruList = list;
        _isLoadingGuru = false;
        if (_guruList.isNotEmpty) {
          _selectedGuru = _guruList.first;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingGuru = false;
        _guruError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _namaKelasC.dispose();
    _jumlahSiswaC.dispose();
    super.dispose();
  }

  Future<void> _saveClass() async {
    final formState = _formKey.currentState;
    if (formState == null) {
      debugPrint('FormState masih null (Form belum ter-mount?)');
      return;
    }

    if (!formState.validate()) return;

    final guru = _selectedGuru;
    if (guru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wali kelas (guru) wajib dipilih')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final nama = _namaKelasC.text.trim();
      final jumlah = int.tryParse(_jumlahSiswaC.text.trim()) ?? 0;

      await _classService.createClass(
        namaKelas: nama,
        jumlahSiswa: jumlah,
        walikelasId: guru.id, // -> akan masuk ke kolom walikelas_id
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas berhasil disimpan.')),
      );

      Navigator.pop(context); // kembali ke daftar kelas
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan kelas: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: 340,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: const [
                          BackButtonRounded(),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: purple,
                            child: Icon(
                              Icons.meeting_room,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tambah Kelas',
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

                      // NAMA KELAS
                      _label("Nama Kelas"),
                      _purpleInput(
                        controller: _namaKelasC,
                        hint: "Misal: X IPA 1",
                        validator: (v) => v == null || v.isEmpty
                            ? "Nama kelas wajib diisi"
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // JUMLAH SISWA
                      _label("Jumlah Siswa"),
                      _purpleInput(
                        controller: _jumlahSiswaC,
                        hint: "0",
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Jumlah siswa wajib diisi";
                          }
                          final n = int.tryParse(v);
                          if (n == null || n < 0) {
                            return "Jumlah siswa tidak valid";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // WALI KELAS
                      _label("Wali Kelas (Guru)"),
                      if (_isLoadingGuru)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(),
                        )
                      else if (_guruError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Gagal memuat guru: $_guruError',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<GuruOption>(
                              value: _selectedGuru,
                              dropdownColor: purple,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              hint: const Text(
                                '-- Pilih Guru --',
                                style: TextStyle(color: Colors.white70),
                              ),
                              items: _guruList
                                  .map(
                                    (g) => DropdownMenuItem<GuruOption>(
                                      value: g,
                                      child: Text(
                                        g.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _selectedGuru = val);
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      const Text(
                        'Hanya menampilkan user dengan role guru.',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),

                      const SizedBox(height: 24),

                      // TOMBOL SIMPAN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveClass,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  // ================== WIDGET KECIL ==================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _purpleInput({
    required TextEditingController controller,
    required String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF6667B0),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
