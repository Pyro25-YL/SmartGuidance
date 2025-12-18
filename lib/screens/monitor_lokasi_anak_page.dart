import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smartguidance/widgets/back_button.dart';

class MonitorLokasiAnakPage extends StatelessWidget {
  const MonitorLokasiAnakPage({super.key});

  static const Color purple = Color(0xFF6667B0);

  // ===== LOKASI STATIK =====
  static final LatLng lokasiAnak = LatLng(-6.200000, 106.816666); // Jakarta

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
          child: Column(
            children: [
              // ===== HEADER =====
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const BackButtonRounded(),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: purple,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Monitoring Lokasi Anak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== MAP =====
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: lokasiAnak,
                        initialZoom: 16,
                      ),
                      children: [
                        // ===== OPEN STREET MAP =====
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.smartguidance',
                        ),

                        // ===== MARKER ANAK =====
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: lokasiAnak,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== STATUS =====
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: purple),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Status: Anak terdeteksi berada di lingkungan sekolah',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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
