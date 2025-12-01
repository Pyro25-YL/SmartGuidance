class AppUser {
  final int id;
  final String name;
  final String nisnNip;
  final String role;
  final String? jenisKelamin;
  final String? foto; // nama file di server
  final String? fotoUrl; // URL publik (kalau disediakan)

  const AppUser({
    required this.id,
    required this.name,
    required this.nisnNip,
    required this.role,
    this.jenisKelamin,
    this.foto,
    this.fotoUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      nisnNip: json['nisn_nip'].toString(),
      role: json['role'] as String,
      jenisKelamin: json['jenis_kelamin'] as String?,
      foto: json['foto'] as String?,
      fotoUrl: json['foto_url'] as String?,
    );
  }
}
