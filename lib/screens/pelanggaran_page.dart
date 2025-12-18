import 'package:flutter/material.dart';
import '../widgets/simple_header.dart';

class PelanggaranPage extends StatelessWidget {
  const PelanggaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E6),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Pelanggaran'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Riwayat Pelanggaran',
                subtitle: 'Catatan pelanggaran siswa',
              ),
              const SizedBox(height: 20),
              _item('Terlambat Masuk Sekolah', '12 Agustus 2024', 5),
              _item('Tidak Memakai Seragam Lengkap', '20 Agustus 2024', 3),
              _item('Tidak Hadir Tanpa Keterangan', '2 September 2024', 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String title, String date, int point) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.report, color: Colors.red),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          '$point Poin',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
