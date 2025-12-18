// lib/services/anggota_kelas_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/kelas_option.dart';
import '../models/user_option.dart';

class AnggotaKelasService {
  final String baseUrl = ApiClient.baseUrl;

  Future<List<KelasOption>> fetchKelasOptions() async {
    final uri = Uri.parse('$baseUrl/api/kelas-options');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      return list
          .map((e) => KelasOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  /// Siswa: user dengan role "murid"
  Future<List<UserOption>> fetchSiswaOptions() async {
    final uri = Uri.parse('$baseUrl/api/siswa-options');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      return list
          .map((e) => UserOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  /// Ortu / wali murid: role "wali_murid"
  Future<List<UserOption>> fetchOrtuOptions() async {
    final uri = Uri.parse('$baseUrl/api/ortu-options');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      return list
          .map((e) => UserOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> createAnggotaKelas({
    required int kelasId,
    required int siswaId,
    int? ortuId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/anggota-kelas');
    final body = {
      'kelas_id': kelasId.toString(),
      'siswa_id': siswaId.toString(),
    };

    if (ortuId != null) {
      body['ortu_id'] = ortuId.toString();
    }

    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
