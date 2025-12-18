import 'package:flutter/material.dart';
import 'package:smartguidance/widgets/back_button.dart';

import '../services/user_service.dart';
import '../models/app_user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _userService = UserService();

  late Future<List<AppUser>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = _userService.fetchUsers();
  }

  Future<void> _reload() async {
    setState(() {
      _futureUsers = _userService.fetchUsers();
    });
  }

  void _goToAddUser() {
    Navigator.pushNamed(context, '/add-user').then((_) {
      _reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: 380,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child:
                              Icon(Icons.people, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _goToAddUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text(
                            'Add User',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // ===== LIST USER =====
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _reload,
                        child: FutureBuilder<List<AppUser>>(
                          future: _futureUsers,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Gagal memuat data user: ${snapshot.error}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final users = snapshot.data ?? [];

                            if (users.isEmpty) {
                              return ListView(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Belum ada user terdaftar.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.separated(
                              itemCount: users.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final u = users[index];
                                return _UserCard(user: u);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AppUser user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6667B0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: purple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 10),

          // DATA USER
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.role ?? '-'} • ${user.jenisKelamin ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'NISN/NIP: ${user.nisnNip}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ======== TOMBOL DETAIL ========
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/user-detail', // <-- ROUTE DETAIL
                arguments: user, // <-- Kirim data user
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              minimumSize: const Size(60, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.visibility, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  "Detail",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
