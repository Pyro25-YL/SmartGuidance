class NilaiUjianItem {
  final int id;
  final int muridId;
  final int mapelId;
  final String jenisUjian; // PTS / PAS
  final int nilai;

  final UserMini? murid;
  final MapelMini? mapel;

  NilaiUjianItem({
    required this.id,
    required this.muridId,
    required this.mapelId,
    required this.jenisUjian,
    required this.nilai,
    this.murid,
    this.mapel,
  });

  factory NilaiUjianItem.fromJson(Map<String, dynamic> json) {
    return NilaiUjianItem(
      id: json['id'] ?? 0,
      muridId: json['murid_id'] ?? 0,
      mapelId: json['mapel_id'] ?? 0,
      jenisUjian: (json['jenis_ujian'] ?? '').toString(),
      nilai: json['nilai'] ?? 0,
      murid: json['murid'] != null ? UserMini.fromJson(json['murid']) : null,
      mapel: json['mapel'] != null ? MapelMini.fromJson(json['mapel']) : null,
    );
  }
}

class UserMini {
  final int id;
  final String name;
  final String? nisnNip;

  UserMini({required this.id, required this.name, this.nisnNip});

  factory UserMini.fromJson(Map<String, dynamic> json) {
    return UserMini(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      nisnNip: (json['nisn_nip'])?.toString(),
    );
  }
}

class MapelMini {
  final int id;
  final String namaMapel;

  MapelMini({required this.id, required this.namaMapel});

  factory MapelMini.fromJson(Map<String, dynamic> json) {
    return MapelMini(
      id: json['id'] ?? 0,
      namaMapel: (json['nama_mapel'] ?? json['nama'] ?? '').toString(),
    );
  }
}
