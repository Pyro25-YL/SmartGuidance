import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smartguidance/widgets/back_button.dart';

import '../models/app_user.dart';
import '../services/user_service.dart';

class UserDetailPage extends StatefulWidget {
  final AppUser? user;

  const UserDetailPage({super.key, this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  static const purple = Color(0xFF6667B0);

  final _userService = UserService();
  final _picker = ImagePicker();

  AppUser? _user;
  bool _initialized = false;

  // state untuk form
  bool _isEditing = false;
  bool _isSaving = false;

  String _name = '';
  String _nisnNip = '';
  String _role = '';
  String? _jenisKelamin;

  // state untuk foto baru (belum tersimpan ke server)
  File? _newFotoFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    final AppUser? u = widget.user ?? (args is AppUser ? args : null);

    if (u != null) {
      _user = u;
      _name = u.name;
      _nisnNip = u.nisnNip;
      _role = u.role;
      _jenisKelamin = u.jenisKelamin;
    }

    _initialized = true;
  }

  Future<void> _pickImage() async {
    if (!_isEditing) return;

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _newFotoFile = File(picked.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_user == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await _userService.updateUser(
        id: _user!.id,
        name: _name,
        nisnNip: _nisnNip,
        role: _role,
        jenisKelamin: _jenisKelamin,
        fotoFile: _newFotoFile, // <-- kirim foto baru kalau ada
        // password tidak diubah dari halaman ini (biarkan null)
      );

      setState(() {
        _user = updated;
        _isEditing = false;
        _newFotoFile = null; // reset setelah berhasil
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data user berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Data user tidak ditemukan.'),
        ),
      );
    }

    final u = _user!;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: 340,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: [
                        const BackButtonRounded(),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: purple,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            u.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isSaving)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              _isEditing ? Icons.check : Icons.edit,
                              color: purple,
                            ),
                            tooltip: _isEditing ? 'Simpan' : 'Edit',
                            onPressed: () {
                              if (_isEditing) {
                                _saveChanges();
                              } else {
                                setState(() {
                                  _isEditing = true;
                                });
                              }
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ===== AVATAR / FOTO (EDITABLE) =====
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _isEditing ? _pickImage : null,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: purple,
                                  ),
                                  child: ClipOval(
                                    child: _buildAvatarImage(u),
                                  ),
                                ),
                                if (_isEditing)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: purple,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            u.role,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: purple,
                            ),
                          ),
                          if (_isEditing)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Tap foto untuk mengubah',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== DATA UTAMA =====
                    _sectionTitle('Data Utama'),
                    const SizedBox(height: 8),

                    _editableField(
                      label: 'Nama',
                      initialValue: _name,
                      enabled: _isEditing,
                      onChanged: (v) => _name = v,
                    ),
                    _editableField(
                      label: 'NISN / NIP',
                      initialValue: _nisnNip,
                      enabled: _isEditing,
                      onChanged: (v) => _nisnNip = v,
                    ),

                    // === ROLE DROPDOWN ===
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          IgnorePointer(
                            ignoring: !_isEditing,
                            child: DropdownButtonFormField<String>(
                              value: _role.isNotEmpty ? _role : null,
                              items: const [
                                DropdownMenuItem(
                                  value: 'admin',
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem(
                                  value: 'guru',
                                  child: Text('Guru'),
                                ),
                                DropdownMenuItem(
                                  value: 'wali_murid',
                                  child: Text('Wali Murid'),
                                ),
                                DropdownMenuItem(
                                  value: 'murid',
                                  child: Text('Murid'),
                                ),
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                filled: true,
                                fillColor: _isEditing
                                    ? Colors.white
                                    : Colors.grey.shade100,
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _role = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Jenis Kelamin dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jenis Kelamin',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          IgnorePointer(
                            ignoring: !_isEditing,
                            child: DropdownButtonFormField<String>(
                              value: _jenisKelamin?.isNotEmpty == true
                                  ? _jenisKelamin
                                  : null,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Laki-laki',
                                  child: Text('Laki-laki'),
                                ),
                                DropdownMenuItem(
                                  value: 'Perempuan',
                                  child: Text('Perempuan'),
                                ),
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                filled: true,
                                fillColor: _isEditing
                                    ? Colors.white
                                    : Colors.grey.shade100,
                              ),
                              onChanged: (val) {
                                _jenisKelamin = val;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _sectionTitle('Info Tambahan'),
                    const SizedBox(height: 8),
                    _detailRow('ID User', u.id.toString()),
                    _detailRow('File Foto', u.foto ?? '-'),

                    const SizedBox(height: 24),

                    if (_isEditing && !_isSaving)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.check),
                          label: const Text('Simpan Perubahan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildAvatarImage(AppUser u) {
    // Prioritas:
    // 1. Kalau user baru saja pilih foto -> preview lokal
    // 2. Kalau tidak ada, pakai fotoUrl dari server (kalau ada)
    // 3. Kalau kosong/error, tampilkan icon person
    if (_newFotoFile != null) {
      return Image.file(
        _newFotoFile!,
        fit: BoxFit.cover,
      );
    }

    if (u.fotoUrl != null && u.fotoUrl!.trim().isNotEmpty) {
      return Image.network(
        u.fotoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          );
        },
      );
    }

    return const Icon(
      Icons.person,
      size: 60,
      color: Colors.white,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6667B0),
      ),
    );
  }

  Widget _editableField({
    required String label,
    required String initialValue,
    required bool enabled,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: initialValue,
            enabled: enabled,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
