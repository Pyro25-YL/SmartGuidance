// lib/models/user_option.dart
class UserOption {
  final int id;
  final String name;
  final String? nisnNip;

  UserOption({
    required this.id,
    required this.name,
    this.nisnNip,
  });

  factory UserOption.fromJson(Map<String, dynamic> json) {
    return UserOption(
      id: int.parse(json['id'].toString()),
      name: (json['name'] ?? '').toString(),
      nisnNip: json['nisn_nip']?.toString(),
    );
  }
}
