class NilaiItem {
  final int id;
  final int mapelId;
  final int muridId;
  final int guruId;
  final int nilai;

  final MapelMini? mapel;
  final UserMini? murid;
  final UserMini? guru;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  NilaiItem({
    required this.id,
    required this.mapelId,
    required this.muridId,
    required this.guruId,
    required this.nilai,
    this.mapel,
    this.murid,
    this.guru,
    this.createdAt,
    this.updatedAt,
  });

  factory NilaiItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDT(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return NilaiItem(
      id: json['id'] ?? 0,
      mapelId: json['mapel_id'] ?? 0,
      muridId: json['murid_id'] ?? 0,
      guruId: json['guru_id'] ?? 0,
      nilai: json['nilai'] ?? 0,
      mapel: json['mapel'] != null ? MapelMini.fromJson(json['mapel']) : null,
      murid: json['murid'] != null ? UserMini.fromJson(json['murid']) : null,
      guru: json['guru'] != null ? UserMini.fromJson(json['guru']) : null,
      createdAt: parseDT(json['created_at']),
      updatedAt: parseDT(json['updated_at']),
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

class UserMini {
  final int id;
  final String name;
  final String? nisnNip;

  UserMini({required this.id, required this.name, this.nisnNip});

  factory UserMini.fromJson(Map<String, dynamic> json) {
    return UserMini(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      nisnNip: (json['nisn_nip'] ?? json['nisnNip'])?.toString(),
    );
  }
}
