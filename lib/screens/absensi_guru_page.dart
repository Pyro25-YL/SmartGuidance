import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smartguidance/widgets/back_button.dart';

import '../models/app_user.dart';
import '../models/mapel_option.dart';
import '../models/school_location.dart';
import '../services/absensi_guru_service.dart';

class AbsensiGuruPage extends StatefulWidget {
  final AppUser loggedInUser;

  const AbsensiGuruPage({
    super.key,
    required this.loggedInUser,
  });

  @override
  State<AbsensiGuruPage> createState() => _AbsensiGuruPageState();
}

class _AbsensiGuruPageState extends State<AbsensiGuruPage> {
  static const purple = Color(0xFF6667B0);

  final _formKey = GlobalKey<FormState>();
  final _absensiService = AbsensiGuruService();
  final _imagePicker = ImagePicker();

  bool _loadingForm = true;
  String? _formError;

  AppUser? _currentUser;
  List<MapelOption> _mapelList = [];
  SchoolLocation? _sekolah;

  int? _selectedMapelId;
  String _jamMulai = '';
  String _jamAkhir = '';

  double? _lat;
  double? _lon;
  bool _gettingLocation = false;
  String _lokasiInfo = 'Belum ada koordinat.';
  String _previewJarakText = '';

  File? _fotoFile;
  File? _materiFile;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();

    // 1. load data form
    _loadFormData().then((_) {
      // 2. setelah form selesai dan widget masih mounted, auto ambil GPS
      if (mounted && _lat == null) {
        _pickLocation();
      }
    });
  }

  Future<void> _loadFormData() async {
    setState(() {
      _loadingForm = true;
      _formError = null;
    });

    try {
      final formData = await _absensiService.fetchFormData(
        guruId: widget.loggedInUser.id,
        bearerToken: null, // isi kalau nanti pakai token
      );

      setState(() {
        _currentUser = formData.currentUser;
        _mapelList = formData.mapelList;
        _sekolah = formData.sekolah;

        if (_mapelList.isNotEmpty) {
          final first = _mapelList.first;
          _selectedMapelId = first.id;
          _jamMulai = first.jamMulai;
          _jamAkhir = first.jamAkhir;
        }

        _loadingForm = false;
      });
    } catch (e) {
      setState(() {
        _loadingForm = false;
        _formError = e.toString();
      });
    }
  }

  double _toRad(double deg) => deg * math.pi / 180.0;

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0; // meter
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _updateJamInfoFromSelectedMapel(int? id) async {
    if (id == null || _mapelList.isEmpty) return;
    final m = _mapelList.firstWhere(
      (e) => e.id == id,
      orElse: () => _mapelList.first,
    );
    setState(() {
      _jamMulai = m.jamMulai;
      _jamAkhir = m.jamAkhir;
    });
  }

  Future<void> _pickLocation() async {
    setState(() {
      _gettingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Izin lokasi ditolak permanen. Aktifkan di pengaturan.',
        );
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = double.parse(pos.latitude.toStringAsFixed(7));
      final lon = double.parse(pos.longitude.toStringAsFixed(7));

      String preview = '';
      if (_sekolah != null) {
        final d = _haversine(
          lat,
          lon,
          _sekolah!.latitude,
          _sekolah!.longitude,
        );
        final dist = d.round();
        final inRadius = dist <= _sekolah!.radiusMeter;
        final status = inRadius ? '✅ Dalam radius' : '❌ Di luar radius';
        preview =
            'Jarak ke sekolah ~ $dist m ($status, batas ${_sekolah!.radiusMeter.toStringAsFixed(0)} m)';
      }

      setState(() {
        _lat = lat;
        _lon = lon;
        _lokasiInfo = 'Koordinat: $lat, $lon';
        _previewJarakText = preview;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil lokasi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _gettingLocation = false;
        });
      }
    }
  }

  Future<void> _pickFoto() async {
    final xfile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (xfile != null) {
      setState(() {
        _fotoFile = File(xfile.path);
      });
    }
  }

  Future<void> _pickFileMateri() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'rar'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _materiFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_selectedMapelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih mapel terlebih dahulu')),
      );
      return;
    }
    if (_lat == null || _lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Silakan ambil lokasi GPS terlebih dahulu')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    try {
      await _absensiService.createAbsensiGuru(
        guruId: _currentUser?.id ?? widget.loggedInUser.id,
        mapelId: _selectedMapelId!,
        lat: _lat!,
        lon: _lon!,
        fotoFile: _fotoFile,
        fileMateri: _materiFile,
        bearerToken: null, // isi kalau pakai token auth
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absensi tersimpan')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan absensi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
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
            child: _loadingForm
                ? const CircularProgressIndicator()
                : _formError != null
                    ? _buildErrorState()
                    : _buildFormCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Gagal memuat data absensi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formError ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadFormData,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    final user = _currentUser ?? widget.loggedInUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        width: 380,
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
        child: Form(
          key: _formKey,
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
                      'Absensi Guru - Tambah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('← Kembali'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // GURU
              const Text(
                'Guru',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  user.name,
                  style: const TextStyle(fontSize: 13),
                ),
              ),

              const SizedBox(height: 16),

              // MAPEL
              const Text(
                'Mapel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<int>(
                value: _selectedMapelId,
                items: _mapelList.map((m) {
                  final label = m.namaKelas != null
                      ? '${m.namaMapel} (${m.namaKelas})'
                      : m.namaMapel;
                  return DropdownMenuItem(
                    value: m.id,
                    child: Text(label),
                  );
                }).toList(),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _selectedMapelId = val;
                  });
                  _updateJamInfoFromSelectedMapel(val);
                },
                validator: (val) {
                  if (val == null) {
                    return 'Mapel wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              Text(
                (_jamMulai.isNotEmpty && _jamAkhir.isNotEmpty)
                    ? 'Jam aktif: $_jamMulai–$_jamAkhir WIB'
                    : '',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // LOKASI
              const Text(
                'Lokasi Absen',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _gettingLocation ? null : _pickLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _gettingLocation
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Pakai GPS Saya',
                            style: TextStyle(fontSize: 13),
                          ),
                  ),
                  const SizedBox(width: 8),
                  if (_sekolah != null)
                    Text(
                      'Radius: ${_sekolah!.radiusMeter.toStringAsFixed(0)} m',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  else
                    const Text(
                      'Alamat sekolah belum diset',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _lokasiInfo,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              if (_previewJarakText.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _previewJarakText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // FILE UPLOAD
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foto (opsional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: _pickFoto,
                          child: const Text(
                            'Ambil Foto',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        if (_fotoFile != null)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Foto dipilih',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        const Text(
                          'Maks 3MB.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // File materi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'File Materi (opsional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: _pickFileMateri,
                          child: const Text(
                            'Pilih File',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        if (_materiFile != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _materiFile!.path.split('/').last,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        const Text(
                          'PDF/DOC/PPT/ZIP/RAR, maks 10MB.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // SUBMIT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                          'Simpan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
