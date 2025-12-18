class User {
  final int id;
  final String name;
  final String role; // 'admin', 'guru', 'murid', 'wali_murid'
  final String? nisn;
  final String? nip;
  final String? gender;

  const User({
    required this.id,
    required this.name,
    required this.role,
    required this.gender,
    this.nisn,
    this.nip,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String,
      nisn: json['nisn'] as String?,
      gender: json['jenis_kelamin'] as String?,
      nip: json['nip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'nisn': nisn,
      'jenis_kelamin': gender,
      'nip': nip,
    };
  }

  bool get isSiswa => role == 'murid';
  bool get isAdmin => role == 'admin';
  bool get isGuru => role == 'guru';
  bool get isOrangTua => role == 'wali_murid';
}
