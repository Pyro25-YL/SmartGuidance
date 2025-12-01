import 'package:flutter/material.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';
import 'placeholder_page.dart';
import 'nav_helper.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Orang Tua',
                subtitle: 'Fitur Orang Tua',
              ),
              FeatureMenuGrid(
                items: [
                  FeatureItem(
                    label: 'Laporan\nNilai',
                    icon: Icons.bar_chart,
                    iconColor: Colors.indigo,
                    onTap: openPlaceholder(context, 'Laporan Nilai'),
                  ),
                  FeatureItem(
                    label: 'Riwayat\nAbsen',
                    icon: Icons.fact_check,
                    iconColor: Colors.green,
                    onTap: openPlaceholder(context, 'Riwayat Absen'),
                  ),
                  FeatureItem(
                    label: 'Pelanggaran',
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onTap: openPlaceholder(context, 'Pelanggaran Anak'),
                  ),
                  FeatureItem(
                    label: 'Jadwal\nPelajaran',
                    icon: Icons.schedule,
                    iconColor: Colors.deepPurple,
                    onTap: openPlaceholder(context, 'Jadwal Pelajaran'),
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
