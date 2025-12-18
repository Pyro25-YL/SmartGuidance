import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/nilai_item.dart';
import '../models/nilai_form_data.dart';

class NilaiService {
  final String baseUrl;

  NilaiService({required this.baseUrl});

  Future<List<NilaiItem>> fetchNilaiGuru({required int guruId}) async {
    final uri = Uri.parse('$baseUrl/api/nilai?guru_id=$guruId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat nilai (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Tidak ok');

    final data = (jsonMap['data'] as List<dynamic>? ?? []);
    return data
        .map((e) => NilaiItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NilaiFormData> fetchNilaiFormData({required int guruId}) async {
    final uri = Uri.parse('$baseUrl/api/nilai/form?guru_id=$guruId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode != 200) {
      throw Exception('Gagal memuat form (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Tidak ok');

    return NilaiFormData.fromJson(jsonMap);
  }

  Future<void> createNilai({
    required int guruId,
    required int mapelId,
    required int muridId,
    required int nilai,
  }) async {
    final uri = Uri.parse('$baseUrl/api/nilai');

    final resp = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'guru_id': guruId,
        'mapel_id': mapelId,
        'murid_id': muridId,
        'nilai': nilai,
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception('Gagal simpan nilai (${resp.statusCode}): ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    if (jsonMap['ok'] != true)
      throw Exception(jsonMap['message'] ?? 'Tidak ok');
  }
}
