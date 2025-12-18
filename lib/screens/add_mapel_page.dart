import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

import '../services/mapel_service.dart';
import '../models/kelas_option.dart';
import '../models/guru_option.dart';

class AddMapelPage extends StatefulWidget {
  const AddMapelPage({super.key});

  @override
  State<AddMapelPage> createState() => _AddMapelPageState();
}

class _AddMapelPageState extends State<AddMapelPage> {
  final _namaMapelC = TextEditingController();
  final _jamMulaiC = TextEditingController();
  final _jamAkhirC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _mapelService = MapelService();

  bool _isSaving = false;

  // dropdown data
  List<KelasOption> _kelasList = [];
  List<GuruOption> _guruList = [];
  bool _isLoadingDropdown = true;
  String? _dropdownError;

  KelasOption? _selectedKelas;
  GuruOption? _selectedGuru;
  String? _selectedHari;

  final List<String> _hariList = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      final kelas = await _mapelService.fetchKelasOptions();
      final guru = await _mapelService.fetchGuruOptions();

      if (!mounted) return;
      setState(() {
        _kelasList = kelas;
        _guruList = guru;
        _isLoadingDropdown = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingDropdown = false;
        _dropdownError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _namaMapelC.dispose();
    _jamMulaiC.dispose();
    _jamAkhirC.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hh:$mm';
    }
  }

  Future<void> _saveMapel() async {
    final formState = _formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    if (_selectedKelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas wajib dipilih')),
      );
      return;
    }

    if (_selectedHari == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hari wajib dipilih')),
      );
      return;
    }

    if (_selectedGuru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guru pengampu wajib dipilih')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _mapelService.createMapel(
        namaMapel: _namaMapelC.text.trim(),
        kelasId: _selectedKelas!.id,
        hari: _selectedHari!,
        jamMulai: _jamMulaiC.text.trim(),
        jamAkhir: _jamAkhirC.text.trim(),
        guruId: _selectedGuru!.id,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mapel berhasil disimpan.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan mapel: $e')),
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
                            child: Icon(Icons.menu_book,
                                color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tambah Mapel',
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

                      // NAMA MAPEL
                      _label("Nama Mapel"),
                      _purpleInput(
                        controller: _namaMapelC,
                        hint: "Nama Matapelajaran",
                        validator: (v) => v == null || v.isEmpty
                            ? "Nama mapel wajib diisi"
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // DROPDOWN DATA STATUS
                      if (_isLoadingDropdown)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(),
                        )
                      else if (_dropdownError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Gagal memuat data dropdown: $_dropdownError',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),

                      // KELAS
                      if (!_isLoadingDropdown && _dropdownError == null) ...[
                        const SizedBox(height: 8),
                        _label("Kelas"),
                        _purpleDropdown<KelasOption>(
                          value: _selectedKelas,
                          items: _kelasList,
                          hint: "-- Pilih Kelas --",
                          getLabel: (k) => k.namaKelas,
                          onChanged: (v) => setState(() => _selectedKelas = v),
                        ),

                        const SizedBox(height: 16),

                        // HARI
                        _label("Hari"),
                        _purpleDropdown<String>(
                          value: _selectedHari,
                          items: _hariList,
                          hint: "-- Pilih Hari --",
                          getLabel: (h) => h,
                          onChanged: (v) => setState(() => _selectedHari = v),
                        ),

                        const SizedBox(height: 16),

                        // JAM MULAI & JAM AKHIR
                        _label("Jam Mulai"),
                        GestureDetector(
                          onTap: () => _pickTime(_jamMulaiC),
                          child: AbsorbPointer(
                            child: _purpleInput(
                              controller: _jamMulaiC,
                              hint: "HH:MM",
                              validator: (v) => v == null || v.isEmpty
                                  ? "Jam mulai wajib diisi"
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _label("Jam Akhir"),
                        GestureDetector(
                          onTap: () => _pickTime(_jamAkhirC),
                          child: AbsorbPointer(
                            child: _purpleInput(
                              controller: _jamAkhirC,
                              hint: "HH:MM",
                              validator: (v) => v == null || v.isEmpty
                                  ? "Jam akhir wajib diisi"
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // GURU
                        _label("Guru Pengampu"),
                        _purpleDropdown<GuruOption>(
                          value: _selectedGuru,
                          items: _guruList,
                          hint: "-- Pilih Guru --",
                          getLabel: (g) => g.name,
                          onChanged: (v) => setState(() => _selectedGuru = v),
                        ),
                      ],

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveMapel,
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

  // ============ WIDGET KECIL ============

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

  Widget _purpleDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    const purple = Color(0xFF6667B0);

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: purple,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    getLabel(e),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
