class RapotItem {
  final int id;
  final int muridId;
  final int kelasId;
  final int mapelId;
  final String semester;
  final int nilai;

  final UserMini? murid;
  final KelasMini? kelas;
  final MapelMini? mapel;

  RapotItem({
    required this.id,
    required this.muridId,
    required this.kelasId,
    required this.mapelId,
    required this.semester,
    required this.nilai,
    this.murid,
    this.kelas,
    this.mapel,
  });

  factory RapotItem.fromJson(Map<String, dynamic> json) {
    return RapotItem(
      id: json['id'] ?? 0,
      muridId: json['murid_id'] ?? 0,
      kelasId: json['kelas_id'] ?? 0,
      mapelId: json['mapel_id'] ?? 0,
      semester: (json['semester'] ?? '').toString(),
      nilai: json['nilai'] ?? 0,
      murid: json['murid'] != null ? UserMini.fromJson(json['murid']) : null,
      kelas: json['kelas'] != null ? KelasMini.fromJson(json['kelas']) : null,
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

class KelasMini {
  final int id;
  final String namaKelas;

  KelasMini({required this.id, required this.namaKelas});

  factory KelasMini.fromJson(Map<String, dynamic> json) {
    return KelasMini(
      id: json['id'] ?? 0,
      namaKelas: (json['nama_kelas'] ?? json['namaKelas'] ?? '').toString(),
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
