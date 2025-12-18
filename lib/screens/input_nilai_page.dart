import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/nilai_form_data.dart';
import '../services/nilai_service.dart';
import '../widgets/back_button.dart';

class InputNilaiPage extends StatefulWidget {
  final AppUser loggedInUser;

  const InputNilaiPage({super.key, required this.loggedInUser});

  @override
  State<InputNilaiPage> createState() => _InputNilaiPageState();
}

class _InputNilaiPageState extends State<InputNilaiPage> {
  static const purple = Color(0xFF6667B0);

  final _formKey = GlobalKey<FormState>();
  late final NilaiService _service;

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<NilaiMapelOption> _mapelList = [];
  List<NilaiUserOption> _muridList = [];

  NilaiMapelOption? _selectedMapel;
  NilaiUserOption? _selectedMurid;

  final _nilaiController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _service = NilaiService(baseUrl: 'http://127.0.0.1:8000'); // samakan

    _loadForm();
  }

  @override
  void dispose() {
    _nilaiController.dispose();
    super.dispose();
  }

  Future<void> _loadForm() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data =
          await _service.fetchNilaiFormData(guruId: widget.loggedInUser.id);

      if (!mounted) return;
      setState(() {
        _mapelList = data.mapel;
        _muridList = data.murid;

        _selectedMapel = _mapelList.isNotEmpty
            ? _mapelList.firstWhere(
                (m) => m.id == data.selectedMapelId,
                orElse: () => _mapelList.first,
              )
            : null;

        _selectedMurid = _muridList.isNotEmpty
            ? _muridList.firstWhere(
                (u) => u.id == data.selectedMuridId,
                orElse: () => _muridList.first,
              )
            : null;

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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedMapel == null || _selectedMurid == null) return;

    final nilai = int.parse(_nilaiController.text.trim());

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _service.createNilai(
        guruId: widget.loggedInUser.id,
        mapelId: _selectedMapel!.id,
        muridId: _selectedMurid!.id,
        nilai: nilai,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nilai berhasil disimpan')),
      );

      Navigator.pop(context, true); // balik ke list + refresh
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
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Input Nilai',
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
                            _label('Mapel'),
                            _purpleDropdown<NilaiMapelOption>(
                              value: _selectedMapel,
                              hint: '-- Pilih Mapel --',
                              items: _mapelList,
                              itemBuilder: (m) => m.namaMapel,
                              onChanged: (v) =>
                                  setState(() => _selectedMapel = v),
                              validator: (v) =>
                                  v == null ? 'Mapel wajib dipilih' : null,
                            ),
                            const SizedBox(height: 16),
                            _label('Murid'),
                            _purpleDropdown<NilaiUserOption>(
                              value: _selectedMurid,
                              hint: '-- Pilih Murid --',
                              items: _muridList,
                              itemBuilder: (u) =>
                                  (u.nisnNip != null && u.nisnNip!.isNotEmpty)
                                      ? '${u.name} — ${u.nisnNip}'
                                      : u.name,
                              onChanged: (v) =>
                                  setState(() => _selectedMurid = v),
                              validator: (v) =>
                                  v == null ? 'Murid wajib dipilih' : null,
                            ),
                            const SizedBox(height: 16),
                            _label('Nilai (0 - 100)'),
                            TextFormField(
                              controller: _nilaiController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'contoh: 90',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _saving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Simpan Nilai',
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

  Widget _label(String t) => Text(
        t,
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
                  child: Text(
                    itemBuilder(e),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
