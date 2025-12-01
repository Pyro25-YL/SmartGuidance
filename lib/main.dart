import 'package:flutter/material.dart';
import 'package:smartguidance/screens/class_list_page.dart';
import 'screens/login_page.dart';
import 'screens/student_home_page.dart';
import 'screens/admin_home_page.dart';
import 'screens/teacher_home_page.dart';
import 'screens/parent_home_page.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/student': (context) => const StudentHomePage(),
        '/admin': (context) => const AdminHomePage(),
        '/teacher': (context) => const TeacherHomePage(),
        '/parent': (context) => const ParentHomePage(),
        '/kelas': (context) => const ClassListPage(),
      },
    );
  }
}
