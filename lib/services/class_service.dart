import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/class_summary.dart';
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
}
