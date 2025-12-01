import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // untuk Uint8List
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:file_picker/file_picker.dart'; // untuk pilih file di web
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/user_service.dart';
import '../models/app_user.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _nameC = TextEditingController();
  final _nisnC = TextEditingController();
  final _passwordC = TextEditingController();
  final _userService = UserService();

  AppUser? _createdUser;
  String? selectedRole;
  String? selectedGender;
  File? selectedImage;
  Uint8List? webImageBytes; // <- buat nyimpan data gambar di Web
  String? selectedImageName; // <- opsional, cuma buat teks "foto dipilih"

  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void dispose() {
    _nameC.dispose();
    _nisnC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> pickPhoto() async {
    // Untuk versi WEB: belum support upload foto dulu (biar ga error)
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Upload foto belum diaktifkan di versi web. Coba di Android nanti.'),
        ),
      );
      return;

      // untuk upload → gunakan MultipartFile.fromBytes
      //  } else {
      // untuk ANDROID / IOS → path file
      //    final file = File(result.files.first.path!);
      //    setState(() {
      //     selectedImage = file;
      //    });
    }
  }

//  Future<void> pickImage() async {
//    final picker = ImagePicker();
//    final img = await picker.pickImage(source: ImageSource.gallery);

  //  if (img != null) {
  //    setState(() => selectedImage = File(img.path));
//    }
//  }

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Role wajib dipilih")));
      return;
    }

    setState(() => isSaving = true);

    try {
      final user = await _userService.createUser(
        name: _nameC.text.trim(),
        nisnNip: _nisnC.text.trim(),
        password: _passwordC.text.trim(),
        role: selectedRole!,
        jenisKelamin: selectedGender,
        fotoFile: selectedImage, // File? dari ImagePicker
      );

      _createdUser = user;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User berhasil dibuat.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membuat user: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: purple,
                            child: Icon(Icons.person_add,
                                color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Add User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: purple,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // NAMA
                      _label("Nama"),
                      _purpleInput(
                        controller: _nameC,
                        hint: "Nama lengkap",
                        validator: (v) =>
                            v!.isEmpty ? "Nama wajib diisi" : null,
                      ),

                      const SizedBox(height: 16),

                      // NISN / NIP
                      _label("NISN / NIP"),
                      _purpleInput(
                        controller: _nisnC,
                        hint: "Masukkan NISN atau NIP",
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? "NISN / NIP wajib diisi" : null,
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      _label("Password"),
                      _purpleInput(
                        controller: _passwordC,
                        hint: "Password",
                        obscure: true,
                        validator: (v) =>
                            v!.isEmpty ? "Password wajib diisi" : null,
                      ),

                      const SizedBox(height: 16),

                      // ROLE
                      _label("Role"),
                      _purpleDropdown(
                        value: selectedRole,
                        items: const ["admin", "guru", "murid", "wali_murid"],
                        hint: "-- Pilih Role --",
                        onChanged: (v) => setState(() => selectedRole = v),
                      ),

                      const SizedBox(height: 16),

                      // JENIS KELAMIN
                      _label("Jenis Kelamin"),
                      _purpleDropdown(
                        value: selectedGender,
                        items: const ["L", "P"],
                        hint: "-- Pilih --",
                        onChanged: (v) => setState(() => selectedGender = v),
                      ),

                      const SizedBox(height: 18),

                      // UPLOAD FOTO
                      _label("Foto (opsional)"),
                      GestureDetector(
                        onTap: pickPhoto,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.upload_file,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedImage == null
                                      ? "Pilih Foto"
                                      : "Foto dipilih",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      if (selectedImage != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedImage!,
                              height: 120, fit: BoxFit.cover),
                        ),
                      ],

                      const SizedBox(height: 26),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : saveUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : const Text(
                                  "Simpan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ======================= WIDGET REUSABLE =======================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _purpleInput({
    required TextEditingController controller,
    required String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF6667B0),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _purpleDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    const purple = Color(0xFF6667B0);

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: purple,
          hint: Text(hint, style: const TextStyle(color: Colors.white70)),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(color: Colors.white)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
