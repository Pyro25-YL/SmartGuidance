import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/mapel_option.dart';
import '../models/school_location.dart';
import 'api_client.dart';

class AbsensiGuruFormData {
  final AppUser currentUser;
  final List<MapelOption> mapelList;
  final SchoolLocation? sekolah;

  AbsensiGuruFormData({
    required this.currentUser,
    required this.mapelList,
    required this.sekolah,
  });
}

class AbsensiGuruService {
  final String baseUrl = ApiClient.baseUrl;

  /// GET /api/absensi-guru/form-data?guru_id=...
  Future<AbsensiGuruFormData> fetchFormData({
    required int guruId,
    String? bearerToken,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/absensi-guru/form-data?guru_id=$guruId',
    );

    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        if (bearerToken != null && bearerToken.isNotEmpty)
          'Authorization': 'Bearer $bearerToken',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Gagal mengambil data absensi');
      }

      final data = body['data'] as Map<String, dynamic>;

      // user
      final userJson = data['user'] as Map<String, dynamic>;
      final user = AppUser.fromJson(userJson);

      // mapel list
      final listMapelJson = (data['mapel_list'] as List<dynamic>? ?? []);
      final mapelList = listMapelJson
          .map((e) => MapelOption.fromJson(e as Map<String, dynamic>))
          .toList();

      // alamat sekolah (boleh null)
      SchoolLocation? sekolah;
      if (data['alamat'] != null) {
        sekolah = SchoolLocation.fromJson(
          data['alamat'] as Map<String, dynamic>,
        );
      }

      return AbsensiGuruFormData(
        currentUser: user,
        mapelList: mapelList,
        sekolah: sekolah,
      );
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  /// POST /api/absensi-guru
  Future<void> createAbsensiGuru({
    required int guruId,
    required int mapelId,
    required double lat,
    required double lon,
    File? fotoFile,
    File? fileMateri,
    String? bearerToken,
  }) async {
    final uri = Uri.parse('$baseUrl/api/absensi-guru');

    final request = http.MultipartRequest('POST', uri);

    request.fields['guru_id'] = guruId.toString();
    request.fields['mapel_id'] = mapelId.toString();
    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();

    if (fotoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto', fotoFile.path),
      );
    }

    if (fileMateri != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file_materi', fileMateri.path),
      );
    }

    request.headers['Accept'] = 'application/json';
    if (bearerToken != null && bearerToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body);

      if (body is Map && body['success'] == false) {
        throw Exception(body['message'] ?? 'Gagal menyimpan absensi guru');
      }
      return;
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      throw Exception(
        'Validasi gagal: ${body['detail'] ?? body['errors'] ?? body}',
      );
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
