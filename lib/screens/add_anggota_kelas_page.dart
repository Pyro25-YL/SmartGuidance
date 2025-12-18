// lib/screens/add_anggota_kelas_page.dart
import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

import '../services/anggota_kelas_service.dart';
import '../models/kelas_option.dart';
import '../models/user_option.dart';

class AddAnggotaKelasPage extends StatefulWidget {
  const AddAnggotaKelasPage({super.key});

  @override
  State<AddAnggotaKelasPage> createState() => _AddAnggotaKelasPageState();
}

class _AddAnggotaKelasPageState extends State<AddAnggotaKelasPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = AnggotaKelasService();

  bool _isSaving = false;
  bool _isLoadingOptions = true;
  String? _loadError;

  List<KelasOption> _kelasList = [];
  List<UserOption> _siswaList = [];
  List<UserOption> _ortuList = [];

  KelasOption? _selectedKelas;
  UserOption? _selectedSiswa;
  UserOption? _selectedOrtu; // opsional

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoadingOptions = true;
      _loadError = null;
    });

    try {
      final kelas = await _service.fetchKelasOptions();
      final siswa = await _service.fetchSiswaOptions(); // role: murid
      final ortu = await _service.fetchOrtuOptions(); // role: wali_murid

      if (!mounted) return;
      setState(() {
        _kelasList = kelas;
        _siswaList = siswa;
        _ortuList = ortu;
        _isLoadingOptions = false;

        if (_kelasList.isNotEmpty) _selectedKelas = _kelasList.first;
        if (_siswaList.isNotEmpty) _selectedSiswa = _siswaList.first;
        // ortu opsional, boleh null
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingOptions = false;
        _loadError = e.toString();
      });
    }
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    if (!formState.validate()) return;

    final kelas = _selectedKelas;
    final siswa = _selectedSiswa;

    if (kelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas wajib dipilih')),
      );
      return;
    }

    if (siswa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Siswa wajib dipilih')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _service.createAnggotaKelas(
        kelasId: kelas.id,
        siswaId: siswa.id,
        ortuId: _selectedOrtu?.id, // boleh null
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anggota kelas berhasil disimpan.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan anggota kelas: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: const [
                          BackButtonRounded(),
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: purple,
                            child: Icon(
                              Icons.group_add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tambah Anggota Kelas',
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

                      if (_isLoadingOptions) ...[
                        const Center(child: LinearProgressIndicator()),
                        const SizedBox(height: 12),
                      ] else if (_loadError != null) ...[
                        Text(
                          'Gagal memuat data pilihan: $_loadError',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ====== KELAS ======
                      _label('Kelas'),
                      _purpleDropdown<KelasOption>(
                        value: _selectedKelas,
                        hint: '-- Pilih Kelas --',
                        items: _kelasList,
                        itemBuilder: (k) => k.namaKelas,
                        onChanged: (val) {
                          setState(() => _selectedKelas = val);
                        },
                        validator: (val) =>
                            val == null ? 'Kelas wajib dipilih' : null,
                      ),

                      const SizedBox(height: 16),

                      // ====== SISWA (role: murid) ======
                      _label('Siswa (Role: Murid)'),
                      _purpleDropdown<UserOption>(
                        value: _selectedSiswa,
                        hint: '-- Pilih Siswa --',
                        items: _siswaList,
                        itemBuilder: (s) =>
                            s.nisnNip != null && s.nisnNip!.isNotEmpty
                                ? '${s.name} — ${s.nisnNip}'
                                : s.name,
                        onChanged: (val) {
                          setState(() => _selectedSiswa = val);
                        },
                        validator: (val) =>
                            val == null ? 'Siswa wajib dipilih' : null,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dropdown ini hanya berisi user dengan role murid.',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),

                      const SizedBox(height: 16),

                      // ====== ORANG TUA / WALI (opsional) ======
                      _label('Orang Tua / Wali (Opsional, Role: Wali Murid)'),
                      _purpleDropdown<UserOption>(
                        value: _selectedOrtu,
                        hint: '-- (Opsional) Pilih Wali Murid --',
                        items: _ortuList,
                        itemBuilder: (o) =>
                            o.nisnNip != null && o.nisnNip!.isNotEmpty
                                ? '${o.name} — ${o.nisnNip}'
                                : o.name,
                        onChanged: (val) {
                          setState(() => _selectedOrtu = val);
                        },
                        // opsional → tidak divalidasi
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Kosongkan jika belum ingin mengaitkan wali murid.',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),

                      const SizedBox(height: 24),

                      // BUTTON SIMPAN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
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

  // Generic dropdown ungu
  Widget _purpleDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) itemBuilder,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    const purple = Color(0xFF6667B0);

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
        hint: Text(
          hint,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  itemBuilder(e),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
