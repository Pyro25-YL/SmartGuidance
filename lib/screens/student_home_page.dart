import 'package:flutter/material.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';
import 'placeholder_page.dart';
import 'nav_helper.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Username (Siswa)',
                subtitle: 'Fitur Siswa',
              ),
              FeatureMenuGrid(
                items: [
                  FeatureItem(
                    label: 'Daftar\nKelas',
                    icon: Icons.list_alt,
                    iconColor: Colors.pink,
                    onTap: openPlaceholder(context, 'Daftar Kelas'),
                  ),
                  FeatureItem(
                    label: 'Mata\nPelajaran',
                    icon: Icons.menu_book,
                    iconColor: Colors.deepPurple,
                    onTap: openPlaceholder(context, 'Mata Pelajaran'),
                  ),
                  FeatureItem(
                    label: 'Daftar\nAbsen',
                    icon: Icons.checklist_rtl,
                    iconColor: Colors.orange,
                    onTap: openPlaceholder(context, 'Daftar Absen'),
                  ),
                  FeatureItem(
                    label: 'Pelanggaran',
                    icon: Icons.report_problem,
                    iconColor: Colors.red,
                    onTap: openPlaceholder(context, 'Pelanggaran'),
                  ),
                  FeatureItem(
                    label: 'Jadwal',
                    icon: Icons.schedule,
                    iconColor: Colors.blue,
                    onTap: openPlaceholder(context, 'Jadwal'),
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
