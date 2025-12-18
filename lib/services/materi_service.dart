import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

// Hanya dipakai ketika platform = web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/materi_form_data.dart';
import '../models/mapel_option.dart';
import 'api_client.dart';

class MateriService {
  final String baseUrl = ApiClient.baseUrl;

  Future<MateriFormData> fetchMateriFormData({
    required int guruId,
    int? mapelId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/materi/form').replace(
      queryParameters: {
        'guru_id': guruId.toString(),
        if (mapelId != null) 'mapel_id': mapelId.toString(),
      },
    );

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    final body = jsonDecode(res.body);

    final list = body['data']['mapel_hari_ini'] as List<dynamic>;
    final mapelHariIni = list
        .map((e) => MapelOption.fromJson(e as Map<String, dynamic>))
        .toList();

    MapelOption? selectedMapel;
    if (body['data']['selected_mapel'] != null) {
      selectedMapel = MapelOption.fromJson(body['data']['selected_mapel']);
    }

    return MateriFormData(
      mapelHariIni: mapelHariIni,
      selectedMapel: selectedMapel,
      initialMateri: null,
    );
  }

  /// Fetch materi last entry (optional)
  Future<String?> fetchMateriForMapel({
    required int guruId,
    required int mapelId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/materi/by-mapel').replace(
      queryParameters: {
        'guru_id': guruId.toString(),
        'mapel_id': mapelId.toString(),
      },
    );

    final res = await http.get(uri);

    final body = jsonDecode(res.body);

    return body['data']['materi'];
  }

  // ===========================
  //  CROSS-PLATFORM UPLOAD
  // ===========================
  Future<void> saveMateri({
    required int guruId,
    required int mapelId,
    required PlatformFile fileMateri,
  }) async {
    if (kIsWeb) {
      // ---------- 🌐 UPLOAD WEB ----------
      await _uploadWeb(guruId, mapelId, fileMateri);
    } else {
      // ---------- 📱 UPLOAD MOBILE ----------
      await _uploadMobile(guruId, mapelId, fileMateri);
    }
  }

  // ----------- WEB VERSION -----------
  Future<void> _uploadWeb(int guruId, int mapelId, PlatformFile file) async {
    if (file.bytes == null) {
      throw Exception("File tidak punya bytes — wajib pakai withData: true");
    }

    final url = '$baseUrl/api/materi';

    final formData = html.FormData();

    formData.append('guru_id', guruId.toString());
    formData.append('mapel_id', mapelId.toString());

    final blob = html.Blob([file.bytes!]);
    formData.appendBlob('file_materi', blob, file.name);

    final req = await html.HttpRequest.request(
      url,
      method: "POST",
      sendData: formData,
    );

    if (req.status! < 200 || req.status! >= 300) {
      throw Exception("Upload gagal: ${req.status} ${req.responseText}");
    }
  }

  // ----------- MOBILE VERSION -----------
  Future<void> _uploadMobile(int guruId, int mapelId, PlatformFile file) async {
    final url = Uri.parse('$baseUrl/api/materi');

    final request = http.MultipartRequest("POST", url);
    request.fields['guru_id'] = guruId.toString();
    request.fields['mapel_id'] = mapelId.toString();

    request.files.add(
      http.MultipartFile.fromBytes(
        'file_materi',
        file.bytes!,
        filename: file.name,
      ),
    );

    final response = await request.send();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final text = await response.stream.bytesToString();
      throw Exception("Upload gagal: ${response.statusCode} $text");
    }
  }
}
