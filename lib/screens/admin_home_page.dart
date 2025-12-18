import 'package:flutter/material.dart';
import 'package:smartguidance/screens/add_user_page.dart';
import 'package:smartguidance/screens/mapel_list_page.dart';
import 'package:smartguidance/screens/user_list_page.dart';
import '../widgets/simple_header.dart';
import '../widgets/feature_menu_grid.dart';
import 'placeholder_page.dart';
import 'nav_helper.dart';
import 'admin/alamat_sekolah_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SimpleHeader(
                title: 'Admin',
                subtitle: 'Fitur Admin',
              ),
              FeatureMenuGrid(
                items: [
                  FeatureItem(
                    label: 'Alamat\nSekolah',
                    icon: Icons.location_city,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlamatSekolahPage(),
                        ),
                      );
                    },
                  ),
                  FeatureItem(
                    label: 'Add\nAkun',
                    icon: Icons.person_add,
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UserListPage(),
                        ),
                      );
                    },
                  ),
                  FeatureItem(
                    label: 'Add\nKelas',
                    icon: Icons.class_,
                    iconColor: Colors.deepOrange,
                    onTap: () => Navigator.pushNamed(context, '/kelas'),
                  ),
                  FeatureItem(
                    label: 'Add\nMapel',
                    icon: Icons.menu_book,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MapelListPage(),
                        ),
                      );
                    },
                  ),
                  // === MENU BARU: ADD ANGGOTA KELAS ===
                  FeatureItem(
                    label: 'Add Anggota\nKelas',
                    icon: Icons.group_add,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/anggota-kelas/add');
                    },
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
