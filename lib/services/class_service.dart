import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/class_summary.dart';
import '../models/guru_option.dart';
import 'api_client.dart';

class ClassService {
  final String baseUrl = ApiClient.baseUrl;

  Future<List<ClassSummary>> fetchClasses() async {
    final uri = Uri.parse('$baseUrl/api/kelas');

    final res = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengambil data kelas');
      }

      final List<dynamic> list = body['data'] as List<dynamic>;
      return list
          .map((e) => ClassSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> createClass({
    required String namaKelas,
    required int jumlahSiswa,
    required int walikelasId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/kelas');

    final res = await http.post(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama_kelas': namaKelas,
        'jumlah_siswa': jumlahSiswa,
        'walikelas_id': walikelasId,
      }),
    );

    final body = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal menyimpan kelas');
      }
      return;
    } else {
      throw Exception('HTTP ${res.statusCode}: ${body['message'] ?? res.body}');
    }
  }

  Future<List<GuruOption>> fetchGuruList() async {
    final uri = Uri.parse('$baseUrl/api/guru');

    final res = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengambil data guru');
      }

      final List<dynamic> list = body['data'] as List<dynamic>;
      return list
          .map((e) => GuruOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
