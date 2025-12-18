import 'package:flutter/material.dart';
import 'package:smartguidance/screens/absen_mapel_page.dart';

class MapelPage extends StatelessWidget {
  const MapelPage({super.key});

  static const purple = Color(0xFF6667B0);

  final List<Map<String, dynamic>> mapelList = const [
    {
      'nama': 'Matematika',
      'kelas': 'X IPA 1',
      'jam': '07:00 - 08:30',
      'icon': Icons.calculate,
    },
    {
      'nama': 'Bahasa Indonesia',
      'kelas': 'X IPA 1',
      'jam': '08:30 - 10:00',
      'icon': Icons.menu_book,
    },
    {
      'nama': 'Fisika',
      'kelas': 'X IPA 2',
      'jam': '10:15 - 11:45',
      'icon': Icons.science,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Pelajaran'),
        backgroundColor: purple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBD5FF), Color(0xFFFDF4E3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: mapelList.length,
          itemBuilder: (context, index) {
            final m = mapelList[index];
            return _mapelCard(context, m);
          },
        ),
      ),
    );
  }

  Widget _mapelCard(BuildContext context, Map<String, dynamic> m) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AbsenMapelPage(
              namaMapel: m['nama'],
              kelas: m['kelas'],
              jam: m['jam'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(m['icon'], color: purple, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['nama'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    m['kelas'],
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    m['jam'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
