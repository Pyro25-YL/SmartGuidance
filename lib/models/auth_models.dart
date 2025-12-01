import 'user.dart';

class LoginRequest {
  final String name;
  final String nisnNip;
  final String password;

  LoginRequest({
    required this.name,
    required this.nisnNip,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nisn_nip': nisnNip,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final String role;
  final User user;

  LoginResponse({
    required this.success,
    required this.message,
    required this.role,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      role: json['role'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
