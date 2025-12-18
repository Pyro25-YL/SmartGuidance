import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/nilai_ujian_item.dart';
import '../models/nilai_ujian_form_data.dart';

class NilaiUjianService {
  final String baseUrl;

  NilaiUjianService({required this.baseUrl});

  // ambil list nilai ujian (bisa filter)
  Future<List<NilaiUjianItem>> fetchNilaiUjian({
    int? muridId,
    int? mapelId,
    String? jenisUjian, // PTS/PAS
  }) async {
    final qp = <String, String>{};
    if (muridId != null) qp['murid_id'] = muridId.toString();
    if (mapelId != null) qp['mapel_id'] = mapelId.toString();
    if (jenisUjian != null && jenisUjian.isNotEmpty)
      qp['jenis_ujian'] = jenisUjian;

    final uri =
        Uri.parse('$baseUrl/api/nilai-ujian').replace(queryParameters: qp);

    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Response tidak ok');

    final data = (jsonMap['data'] as List<dynamic>? ?? []);
    return data
        .map((e) => NilaiUjianItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ambil data dropdown input (mapel, murid, jenis)
  Future<NilaiUjianFormData> fetchFormData() async {
    final uri = Uri.parse('$baseUrl/api/nilai-ujian/form');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat form (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Response tidak ok');

    return NilaiUjianFormData.fromJson(jsonMap);
  }

  // simpan nilai ujian (upsert di backend)
  Future<void> createOrUpdateNilaiUjian({
    required int muridId,
    required int mapelId,
    required String jenisUjian, // PTS/PAS
    required int nilai,
  }) async {
    final uri = Uri.parse('$baseUrl/api/nilai-ujian');

    final resp = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'murid_id': muridId,
        'mapel_id': mapelId,
        'jenis_ujian': jenisUjian,
        'nilai': nilai,
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception('Gagal simpan (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Response tidak ok');
  }
}
