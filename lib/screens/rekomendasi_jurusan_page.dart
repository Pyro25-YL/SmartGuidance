import 'package:flutter/material.dart';
import '../widgets/simple_header.dart';

class RekomendasiJurusanPage extends StatelessWidget {
  const RekomendasiJurusanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E6),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Rekomendasi Jurusan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SimpleHeader(
              title: 'Rekomendasi Jurusan',
              subtitle: 'Berdasarkan minat & bakat',
            ),
            const SizedBox(height: 20),
            _item('Teknik Informatika', 'Cocok untuk kamu yang suka logika'),
            _item('Sistem Informasi', 'Gabungan IT dan bisnis'),
            _item('Manajemen', 'Cocok untuk leadership'),
            _item('Akuntansi', 'Teliti & rapi'),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String desc) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.pink),
        title: Text(title),
        subtitle: Text(desc),
      ),
    );
  }
}
