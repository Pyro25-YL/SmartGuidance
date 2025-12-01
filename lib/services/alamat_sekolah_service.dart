import 'dart:convert';

import '../models/alamat_sekolah.dart';
import 'api_client.dart';

/// Service untuk berkomunikasi dengan endpoint:
/// GET    /api/alamat-sekolah
/// POST   /api/alamat-sekolah
/// PUT    /api/alamat-sekolah/{id}
/// DELETE /api/alamat-sekolah/{id}
class AlamatSekolahService {
  final ApiClient _client;

  AlamatSekolahService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Ambil alamat sekolah saat ini (singleton).
  /// Jika belum ada, akan me-return null.
  Future<AlamatSekolah?> getCurrent() async {
    final json = await _client.get('/api/alamat-sekolah');

    // Bentuk response dari Laravel:
    // { "success": true, "data": { ... } } atau { "success": true, "data": null }
    final data = json['data'];
    if (data == null) return null;

    return AlamatSekolah.fromJson(data as Map<String, dynamic>);
  }

  /// Buat alamat sekolah baru.
  /// Ini sebaiknya hanya dipanggil jika getCurrent() == null.
  Future<AlamatSekolah> create(AlamatSekolah alamat) async {
    final body = jsonEncode(alamat.toJsonBody());

    final json = await _client.post(
      '/api/alamat-sekolah',
      body: body,
    );

    if (json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal membuat alamat sekolah.');
    }

    return AlamatSekolah.fromJson(json['data'] as Map<String, dynamic>);
  }

  /// Update alamat sekolah yang sudah ada (wajib punya id).
  Future<AlamatSekolah> update(AlamatSekolah alamat) async {
    if (alamat.id == null) {
      throw Exception('ID alamat sekolah tidak boleh null saat update.');
    }

    final body = jsonEncode(alamat.toJsonBody());

    final json = await _client.put(
      '/api/alamat-sekolah/${alamat.id}',
      body: body,
    );

    if (json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal memperbarui alamat sekolah.');
    }

    return AlamatSekolah.fromJson(json['data'] as Map<String, dynamic>);
  }

  /// Helper: kalau id null → create(), kalau ada id → update().
  Future<AlamatSekolah> save(AlamatSekolah alamat) {
    if (alamat.id == null) {
      return create(alamat);
    } else {
      return update(alamat);
    }
  }

  /// Hapus alamat sekolah berdasarkan ID.
  Future<void> delete(int id) async {
    final json = await _client.delete('/api/alamat-sekolah/$id');

    if (json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal menghapus alamat sekolah.');
    }
  }
}
