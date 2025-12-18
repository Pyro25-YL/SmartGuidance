import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import 'api_client.dart';

class UserService {
  // Pakai baseUrl dari ApiClient biar konsisten
  final String baseUrl = ApiClient.baseUrl;

  /// Create user baru: name, nisn_nip, password, role, jenis_kelamin, foto (opsional)
  Future<AppUser> createUser({
    required String name,
    required String nisnNip,
    required String password,
    required String role,
    String? jenisKelamin,
    File? fotoFile,
  }) async {
    final uri = Uri.parse('$baseUrl/api/users');

    final request = http.MultipartRequest('POST', uri);

    // Fields biasa
    request.fields['name'] = name;
    request.fields['nisn_nip'] = nisnNip;
    request.fields['password'] = password;
    request.fields['role'] = role;

    if (jenisKelamin != null && jenisKelamin.isNotEmpty) {
      request.fields['jenis_kelamin'] = jenisKelamin;
    }

    // File foto (opsional)
    if (fotoFile != null) {
      final multipartFile = await http.MultipartFile.fromPath(
        'foto',
        fotoFile.path,
      );
      request.files.add(multipartFile);
    }

    // Kirim request
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal membuat user');
      }

      final data = body['data'] as Map<String, dynamic>;
      return AppUser.fromJson(data);
    } else if (response.statusCode == 422) {
      // Validation error
      final Map<String, dynamic> body = jsonDecode(response.body);
      throw Exception('Validasi gagal: ${body['errors'] ?? body}');
    } else {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }

  /// Ambil daftar user (untuk halaman Daftar Akun)
  Future<List<AppUser>> fetchUsers() async {
    final uri = Uri.parse('$baseUrl/api/users');

    final res = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengambil data user');
      }

      final List<dynamic> list = body['data'] as List<dynamic>;

      return list
          .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  /// Update user (tanpa pindah halaman di FE)
  Future<AppUser> updateUser({
    required int id,
    String? name,
    String? nisnNip,
    String? password,
    String? role,
    String? jenisKelamin,
    File? fotoFile,
  }) async {
    // Sesuaikan dengan route kamu:
    // Laravel typical: Route::apiResource('users', UserController::class);
    // => PUT/PATCH /api/users/{id}
    //
    // Karena mau kirim multipart (ada foto), kita pakai POST + _method=PUT
    final uri = Uri.parse('$baseUrl/api/users/$id');

    final request = http.MultipartRequest('POST', uri);

    request.fields['_method'] = 'PUT'; // spoof method utk Laravel

    if (name != null) request.fields['name'] = name;
    if (nisnNip != null) request.fields['nisn_nip'] = nisnNip;
    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }
    if (role != null) request.fields['role'] = role;
    if (jenisKelamin != null && jenisKelamin.isNotEmpty) {
      request.fields['jenis_kelamin'] = jenisKelamin;
    }

    if (fotoFile != null) {
      final multipartFile = await http.MultipartFile.fromPath(
        'foto',
        fotoFile.path,
      );
      request.files.add(multipartFile);
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengubah user');
      }

      final data = body['data'] as Map<String, dynamic>;
      return AppUser.fromJson(data);
    } else if (response.statusCode == 422) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      throw Exception('Validasi gagal: ${body['errors'] ?? body}');
    } else {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}
