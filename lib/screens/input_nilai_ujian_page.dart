import 'package:flutter/material.dart';
import '../models/nilai_ujian_form_data.dart';
import '../services/nilai_ujian_service.dart';
import '../widgets/back_button.dart';

class InputNilaiUjianPage extends StatefulWidget {
  const InputNilaiUjianPage({super.key});

  @override
  State<InputNilaiUjianPage> createState() => _InputNilaiUjianPageState();
}

class _InputNilaiUjianPageState extends State<InputNilaiUjianPage> {
  static const purple = Color(0xFF6667B0);

  final _formKey = GlobalKey<FormState>();
  late final NilaiUjianService _service;

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<MapelOptionMini> _mapel = [];
  List<MuridOptionMini> _murid = [];
  List<String> _jenis = [];

  MapelOptionMini? _selectedMapel;
  MuridOptionMini? _selectedMurid;
  String? _selectedJenis;

  final _nilaiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = NilaiUjianService(baseUrl: 'http://127.0.0.1:8000');
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.fetchFormData();
      setState(() {
        _mapel = data.mapel;
        _murid = data.murid;
        _jenis = data.jenisUjian;
        _selectedMapel = _mapel.first;
        _selectedMurid = _murid.first;
        _selectedJenis = _jenis.first;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _service.createOrUpdateNilaiUjian(
        muridId: _selectedMurid!.id,
        mapelId: _selectedMapel!.id,
        jenisUjian: _selectedJenis!,
        nilai: int.parse(_nilaiController.text),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _saving = false;
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
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BackButtonRounded(),
                          const SizedBox(height: 8),
                          const Text(
                            'Input Nilai Ujian',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _dropdown(
                            'Mapel',
                            _selectedMapel,
                            _mapel,
                            (e) => e.namaMapel,
                            (v) => setState(() => _selectedMapel = v),
                          ),
                          _dropdown(
                            'Murid',
                            _selectedMurid,
                            _murid,
                            (e) => e.name,
                            (v) => setState(() => _selectedMurid = v),
                          ),
                          _dropdown(
                            'Jenis Ujian',
                            _selectedJenis,
                            _jenis,
                            (e) => e,
                            (v) => setState(() => _selectedJenis = v),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nilaiController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nilai',
                              filled: true,
                            ),
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n < 0 || n > 100) {
                                return 'Nilai harus 0 - 100';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                              ),
                              child: _saving
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Simpan'),
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

  Widget _dropdown<T>(
    String label,
    T? value,
    List<T> items,
    String Function(T) text,
    ValueChanged<T?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
        ),
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(text(e)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
