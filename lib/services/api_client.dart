import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  /// Ganti sesuai URL backend Laravel-mu
  /// Untuk emulator Android: http://10.0.2.2:8000
  static const String baseUrl = 'http://127.0.0.1:8000';

  final http.Client _http;

  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  // ============================================================
  // ======================= GET ================================
  // ============================================================

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    final response = await _http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  // ============================================================
  // ======================= POST ===============================
  // ============================================================

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final response = await _http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // ======================= PUT ================================
  // ============================================================

  Future<Map<String, dynamic>> put(
    String path, {
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final response = await _http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // ====================== DELETE ==============================
  // ============================================================

  Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    final response = await _http.delete(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  // ============================================================
  // ================== RESPONSE HANDLER =========================
  // ============================================================

  Map<String, dynamic> _handleResponse(http.Response res) {
    final status = res.statusCode;

    if (res.body.isEmpty) {
      if (status >= 200 && status < 300) return {};
      throw Exception("HTTP $status: (empty body)");
    }

    try {
      final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
      if (status >= 200 && status < 300) {
        return jsonBody;
      } else {
        throw Exception("HTTP $status: ${res.body}");
      }
    } catch (e) {
      throw Exception("Gagal decode response: ${res.body}");
    }
  }
}
