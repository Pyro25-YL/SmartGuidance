import 'dart:convert';
import '../models/auth_models.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LoginResponse> login(LoginRequest request) async {
    final jsonBody = jsonEncode(request.toJson());

    final responseJson = await _apiClient.post(
      '/api/login', // atau '/login' sesuai route Laravel
      body: jsonBody,
    );

    return LoginResponse.fromJson(responseJson);
  }
}
