import 'package:flutter/material.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';
import 'placeholder_page.dart';
import 'nav_helper.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Guru',
                subtitle: 'Fitur Guru',
              ),
              FeatureMenuGrid(
                items: [
                  FeatureItem(
                    label: 'Daftar\nKelas',
                    icon: Icons.list_alt,
                    iconColor: Colors.blue,
                    onTap: openPlaceholder(context, 'Daftar Kelas (Guru)'),
                  ),
                  FeatureItem(
                    label: 'Input\nNilai',
                    icon: Icons.edit_note,
                    iconColor: Colors.green,
                    onTap: openPlaceholder(context, 'Input Nilai'),
                  ),
                  FeatureItem(
                    label: 'Absensi\nSiswa',
                    icon: Icons.checklist,
                    iconColor: Colors.orange,
                    onTap: openPlaceholder(context, 'Absensi Siswa'),
                  ),
                  FeatureItem(
                    label: 'Pelanggaran',
                    icon: Icons.report,
                    iconColor: Colors.red,
                    onTap: openPlaceholder(context, 'Pelanggaran Siswa'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
