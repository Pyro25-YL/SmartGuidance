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
}
