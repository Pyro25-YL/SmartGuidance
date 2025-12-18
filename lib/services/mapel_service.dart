import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/mapel_summary.dart';
import '../models/kelas_option.dart';
import '../models/guru_option.dart';

class MapelService {
  final String baseUrl = ApiClient.baseUrl;

  // ==== LIST MAPEL ====
  Future<List<MapelSummary>> fetchMapelList() async {
    final uri = Uri.parse('$baseUrl/api/mapel');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengambil data mapel');
      }
      final list = body['data'] as List<dynamic>;
      return list
          .map((e) => MapelSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  // ==== DROPDOWN KELAS ====
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

  // ==== DROPDOWN GURU ====
  Future<List<GuruOption>> fetchGuruOptions() async {
    final uri = Uri.parse('$baseUrl/api/guru-options');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      return list
          .map((e) => GuruOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  // ==== CREATE MAPEL ====
  Future<void> createMapel({
    required String namaMapel,
    required int kelasId,
    required String hari,
    required String jamMulai,
    required String jamAkhir,
    required int guruId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/mapel');
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {
        'nama_mapel': namaMapel,
        'kelas_id': kelasId.toString(),
        'hari': hari,
        'jam_mulai': jamMulai,
        'jam_akhir': jamAkhir,
        'guru_id': guruId.toString(),
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
