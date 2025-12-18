import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AbsensiService {
  final String baseUrl;
  final String token;

  AbsensiService(this.baseUrl, this.token);

  // === AMBIL ALAMAT SEKOLAH ===
  Future<Map<String, dynamic>> getAlamatSekolah() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/alamat-sekolah'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal ambil alamat sekolah');
    }

    return json.decode(res.body);
  }

  // === ABSEN MASUK ===
  Future<void> absenMasuk({
    required double lat,
    required double lng,
    File? foto,
  }) async {
    final uri = Uri.parse('$baseUrl/api/absensi/masuk');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['latitude'] = lat.toString();
    request.fields['longitude'] = lng.toString();

    if (foto != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto', foto.path),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Gagal absensi');
    }
  }
}
