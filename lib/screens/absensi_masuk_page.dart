import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../services/absensi_service.dart';

class AbsensiMasukPage extends StatefulWidget {
  const AbsensiMasukPage({super.key});

  @override
  State<AbsensiMasukPage> createState() => _AbsensiMasukPageState();
}

class _AbsensiMasukPageState extends State<AbsensiMasukPage> {
  static const primary = Color(0xFF5B5FC7);

  bool _loading = false;
  double? _lat, _lng, _jarak;
  File? _foto;

  String _alamatSekolah = '-';
  double _radius = 0;
  double? _latSekolah, _lngSekolah;

  late AbsensiService service;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    service = AbsensiService(
      'http://127.0.0.1:8000',
      'TOKEN_LOGIN_KAMU',
    );
    _init();
  }

  Future<void> _init() async {
    await _ambilLokasi();
    await _ambilAlamatSekolah();
    _hitungJarak();
  }

  Future<void> _ambilLokasi() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
    });
  }

  Future<void> _ambilAlamatSekolah() async {
    final data = await service.getAlamatSekolah();
    setState(() {
      _alamatSekolah = data['alamat'];
      _latSekolah = double.parse(data['latitude'].toString());
      _lngSekolah = double.parse(data['longitude'].toString());
      _radius = double.parse(data['radius_jarak_absen'].toString());
    });
  }

  void _hitungJarak() {
    if (_lat == null || _latSekolah == null) return;
    _jarak = Geolocator.distanceBetween(
      _lat!,
      _lng!,
      _latSekolah!,
      _lngSekolah!,
    );
    setState(() {});
  }

  Future<void> _ambilFoto() async {
    final x = await picker.pickImage(source: ImageSource.camera);
    if (x != null) setState(() => _foto = File(x.path));
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await service.absenMasuk(
      lat: _lat!,
      lng: _lng!,
      foto: _foto,
    );
    setState(() => _loading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Absensi berhasil')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inRadius = _jarak != null && _jarak! <= _radius;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF1FF), Color(0xFFFDFEFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _content(inRadius)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 16, 20, 20),
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔙 BACK BUTTON
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

          const SizedBox(width: 8),

          // TITLE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Absensi Masuk',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pastikan kamu berada di area sekolah',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(bool inRadius) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _infoCard(inRadius),
          const SizedBox(height: 16),
          _fotoCard(),
          const Spacer(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _infoCard(bool inRadius) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Lokasi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.school, color: primary),
                const SizedBox(width: 10),
                Expanded(child: Text(_alamatSekolah)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.my_location,
                    color: inRadius ? Colors.green : Colors.red),
                const SizedBox(width: 10),
                Text(
                  _jarak == null
                      ? 'Menghitung jarak...'
                      : '${_jarak!.toStringAsFixed(1)} meter',
                  style: TextStyle(
                    color: inRadius ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              inRadius ? 'Di dalam area sekolah' : 'Di luar area sekolah',
              style: TextStyle(
                color: inRadius ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fotoCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Foto (Opsional)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_foto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_foto!, height: 160, fit: BoxFit.cover),
              )
            else
              Container(
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: const Text('Belum ada foto'),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _ambilFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto'),
              style: ElevatedButton.styleFrom(backgroundColor: primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Absen Sekarang',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
