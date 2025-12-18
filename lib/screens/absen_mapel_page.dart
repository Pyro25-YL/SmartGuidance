import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AbsenMapelPage extends StatefulWidget {
  final String namaMapel;
  final String kelas;
  final String jam;

  const AbsenMapelPage({
    super.key,
    required this.namaMapel,
    required this.kelas,
    required this.jam,
  });

  @override
  State<AbsenMapelPage> createState() => _AbsenMapelPageState();
}

class _AbsenMapelPageState extends State<AbsenMapelPage> {
  static const purple = Color(0xFF6667B0);

  double? _lat;
  double? _lng;
  File? _foto;
  bool _loading = false;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _ambilLokasi();
  }

  Future<void> _ambilLokasi() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (_) {}
  }

  Future<void> _ambilFoto() async {
    final xfile = await _picker.pickImage(source: ImageSource.camera);
    if (xfile != null) {
      setState(() => _foto = File(xfile.path));
    }
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Absensi mapel berhasil (dummy)')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Absensi Mapel'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBD5FF), Color(0xFFFDF4E3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.namaMapel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.kelas} • ${widget.jam}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  _lat != null ? 'Lokasi: $_lat, $_lng' : 'Mengambil lokasi...',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _ambilFoto,
                  child: const Text('Ambil Foto (Opsional)'),
                ),
                if (_foto != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Foto siap dikirim',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Absen Mapel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
