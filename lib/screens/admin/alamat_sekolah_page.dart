import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:smartguidance/models/alamat_sekolah.dart';
import 'package:smartguidance/services/alamat_sekolah_service.dart';
import 'package:smartguidance/widgets/back_button.dart';

class AlamatSekolahPage extends StatefulWidget {
  const AlamatSekolahPage({super.key});

  @override
  State<AlamatSekolahPage> createState() => _AlamatSekolahPageState();
}

class _AlamatSekolahPageState extends State<AlamatSekolahPage> {
  final _searchC = TextEditingController();
  final _alamatC = TextEditingController();
  final _latitudeC = TextEditingController();
  final _longitudeC = TextEditingController();
  final _radiusC = TextEditingController(text: '150');

  List<dynamic> suggestions = [];
  bool isLoadingGPS = false;
  final _alamatService = AlamatSekolahService();
  bool _isLoadingPage = true;
  bool _isSaving = false;
  AlamatSekolah? _currentAlamat;

  @override
  void dispose() {
    _searchC.dispose();
    _alamatC.dispose();
    _latitudeC.dispose();
    _longitudeC.dispose();
    _radiusC.dispose();
    super.dispose();
  }

  // ===================== LOGIC: NOMINATIM SEARCH =====================

  Future<void> _searchAddress(String query) async {
    if (query.trim().length < 3) {
      setState(() => suggestions = []);
      return;
    }

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?format=jsonv2&q=$query&addressdetails=1&limit=8&countrycodes=id',
    );

    final res = await http.get(
      url,
      headers: const {
        'Accept-Language': 'id,en;q=0.8',
        'User-Agent': 'SmartGuidance-App',
      },
    );

    if (res.statusCode == 200) {
      setState(() => suggestions = jsonDecode(res.body));
    }
  }

  Future<void> _useGPS() async {
    setState(() => isLoadingGPS = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS belum aktif di perangkat.')),
        );
        setState(() => isLoadingGPS = false);
        return;
      }

      LocationPermission perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak.')),
        );
        setState(() => isLoadingGPS = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = pos.latitude.toStringAsFixed(7);
      final lon = pos.longitude.toStringAsFixed(7);

      _latitudeC.text = lat;
      _longitudeC.text = lon;

      // Reverse geocode → alamat
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=jsonv2&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final res = await http.get(
        url,
        headers: const {
          'Accept-Language': 'id,en;q=0.8',
          'User-Agent': 'SmartGuidance-App',
        },
      );
      final data = jsonDecode(res.body);
      final display = data['display_name'];

      if (display != null && display is String) {
        _searchC.text = display;
        _alamatC.text = display;
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingGPS = false);
      }
    }
  }

  Future<void> _save() async {
    // Validasi sederhana di sisi Flutter
    if (_latitudeC.text.trim().isEmpty ||
        _longitudeC.text.trim().isEmpty ||
        _radiusC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Latitude, Longitude, dan Radius wajib diisi.')),
      );
      return;
    }

    final double? lat = double.tryParse(_latitudeC.text.trim());
    final double? lon = double.tryParse(_longitudeC.text.trim());
    final int? radius = int.tryParse(_radiusC.text.trim());

    if (lat == null || lon == null || radius == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Format koordinat atau radius tidak valid.')),
      );
      return;
    }

    final alamat = AlamatSekolah(
      id: _currentAlamat?.id, // null kalau create, ada kalau edit
      alamat: _alamatC.text.trim(),
      latitude: lat,
      longitude: lon,
      radiusJarakAbsen: radius,
    );

    setState(() => _isSaving = true);

    try {
      final saved = await _alamatService.save(alamat);
      _currentAlamat = saved;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alamat sekolah berhasil disimpan.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan alamat sekolah: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentAlamat();
  }

  Future<void> _loadCurrentAlamat() async {
    try {
      final alamat = await _alamatService.getCurrent();
      if (alamat != null) {
        _currentAlamat = alamat;
        _alamatC.text = alamat.alamat ?? '';
        _latitudeC.text = alamat.latitude.toString();
        _longitudeC.text = alamat.longitude.toString();
        _radiusC.text = alamat.radiusJarakAbsen.toString();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat alamat sekolah: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPage = false);
      }
    }
  }

  // ============================== UI ==============================

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
                child: _isLoadingPage
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER
                          Row(
                            children: const [
                              BackButtonRounded(),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: purple,
                                child: Icon(Icons.location_on,
                                    color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tambah Alamat Sekolah',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gunakan pencarian atau GPS untuk mengisi koordinat sekolah.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 16),
                          const Divider(height: 1),

                          const SizedBox(height: 16),

                          // CARI ALAMAT
                          const Text(
                            'Cari Alamat (Nominatim OSM)',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          _purpleInput(
                            controller: _searchC,
                            hint: 'Ketik nama sekolah / alamat...',
                            onChanged: _searchAddress,
                          ),

                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: isLoadingGPS ? null : _useGPS,
                              icon: isLoadingGPS
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.my_location, size: 16),
                              label: Text(
                                isLoadingGPS
                                    ? 'Mengambil lokasi...'
                                    : 'Pakai GPS Saya',
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),

                          if (suggestions.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _SuggestionCard(
                              items: suggestions,
                              onSelected: (item) {
                                _latitudeC.text = item['lat'];
                                _longitudeC.text = item['lon'];
                                final name = item['display_name'] as String;
                                _searchC.text = name;
                                _alamatC.text = name;
                                setState(() => suggestions = []);
                              },
                            ),
                          ],

                          const SizedBox(height: 20),

                          // ALAMAT OPSIONAL
                          const Text(
                            'Alamat (opsional)',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          _purpleInput(
                            controller: _alamatC,
                            hint: 'Alamat lengkap sekolah...',
                          ),

                          const SizedBox(height: 18),

                          // LAT LON
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Latitude',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    _purpleInput(
                                      controller: _latitudeC,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Longitude',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    _purpleInput(
                                      controller: _longitudeC,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // RADIUS
                          const Text(
                            'Radius Jarak Absen (meter)',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          _purpleInput(
                            controller: _radiusC,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 22),

                          // PREVIEW
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.map_outlined,
                                    size: 18, color: purple),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    (_latitudeC.text.isEmpty ||
                                            _longitudeC.text.isEmpty)
                                        ? 'Belum ada koordinat.'
                                        : 'Lat: ${_latitudeC.text}, Lon: ${_longitudeC.text}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          // SIMPAN
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                        letterSpacing: 1,
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
    );
  }

  // ===================== REUSABLE INPUT =====================

  Widget _purpleInput({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF6667B0),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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

class _SuggestionCard extends StatelessWidget {
  final List<dynamic> items;
  final void Function(Map<String, dynamic>) onSelected;

  const _SuggestionCard({
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index] as Map<String, dynamic>;
            return ListTile(
              dense: true,
              leading: const Icon(Icons.place_outlined, size: 18),
              title: Text(
                item['display_name'] ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () => onSelected(item),
            );
          },
        ),
      ),
    );
  }
}
