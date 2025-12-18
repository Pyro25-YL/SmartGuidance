import 'package:flutter/material.dart';
import 'package:smartguidance/screens/add_anggota_kelas_page.dart';
import 'package:smartguidance/screens/add_user_page.dart';
import 'package:smartguidance/screens/materi_list_page.dart';
import 'package:smartguidance/screens/pilih_mapel_materi_page.dart';

import 'screens/splash_page.dart';
import 'screens/login_page.dart';
import 'screens/student_home_page.dart';
import 'screens/admin_home_page.dart';
import 'screens/teacher_home_page.dart';
import 'screens/parent_home_page.dart';
import 'screens/class_list_page.dart';
import 'screens/add_class_page.dart';
import 'screens/mapel_list_page.dart';
import 'screens/add_mapel_page.dart';
import 'screens/user_detail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartGuidance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0E4DAE),
        scaffoldBackgroundColor: const Color(0xFFF1F4FA),
        colorSchemeSeed: const Color(0xFF0E4DAE),
        fontFamily: 'Roboto',
      ),
      // Splash sebagai halaman awal
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/student': (context) => const StudentHomePage(),
        '/admin': (context) => const AdminHomePage(),
        '/teacher': (context) => const TeacherHomePage(),
        '/parent': (context) => const ParentHomePage(),
        '/kelas': (context) => const ClassListPage(),
        '/add-class': (context) => const AddClassPage(),
        '/add-user': (context) => const AddUserPage(),
        '/mapel': (context) => const MapelListPage(),
        '/add-mapel': (context) => const AddMapelPage(),
        '/anggota-kelas/add': (context) => const AddAnggotaKelasPage(),
        '/user-detail': (context) => const UserDetailPage(),
        '/pilih-mapel-materi': (_) => const PilihMapelMateriPage(),
        '/materi-list': (_) => const MateriListPage(),
      },
    );
  }
}
