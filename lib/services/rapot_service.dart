import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rapot_form_data.dart';

class RapotService {
  final String baseUrl;
  RapotService(this.baseUrl);

  Future<RapotFormData> fetchForm() async {
    final r = await http.get(Uri.parse('$baseUrl/api/rapot/form'));
    return RapotFormData.fromJson(json.decode(r.body));
  }

  Future<double?> fetchAvg(int muridId, int mapelId) async {
    final r = await http.get(
      Uri.parse('$baseUrl/api/rapot/avg?murid_id=$muridId&mapel_id=$mapelId'),
    );
    final j = json.decode(r.body);
    return j['data']['avg'] == null
        ? null
        : double.parse(j['data']['avg'].toString());
  }

  Future<void> save({
    required int muridId,
    required int kelasId,
    required int mapelId,
    required String semester,
    required int nilai,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/api/rapot'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'murid_id': muridId,
        'kelas_id': kelasId,
        'mapel_id': mapelId,
        'semester': semester,
        'nilai': nilai,
      }),
    );
  }

  Future<List<Map<String, dynamic>>> fetchRapotRaw() async {
    final r = await http.get(Uri.parse('$baseUrl/api/rapot'));
    final j = json.decode(r.body);
    return (j['data'] as List).cast<Map<String, dynamic>>();
  }
}
