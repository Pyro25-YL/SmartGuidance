class NilaiUjianFormData {
  final List<MapelOptionMini> mapel;
  final List<MuridOptionMini> murid;
  final List<String> jenisUjian;

  final int? selectedMapelId;
  final int? selectedMuridId;
  final String? selectedJenisUjian;

  NilaiUjianFormData({
    required this.mapel,
    required this.murid,
    required this.jenisUjian,
    this.selectedMapelId,
    this.selectedMuridId,
    this.selectedJenisUjian,
  });

  factory NilaiUjianFormData.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? {});
    final mapelList = (data['mapel'] as List<dynamic>? ?? [])
        .map((e) => MapelOptionMini.fromJson(e as Map<String, dynamic>))
        .toList();

    final muridList = (data['murid'] as List<dynamic>? ?? [])
        .map((e) => MuridOptionMini.fromJson(e as Map<String, dynamic>))
        .toList();

    final jenis = (data['jenis_ujian'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return NilaiUjianFormData(
      mapel: mapelList,
      murid: muridList,
      jenisUjian: jenis,
      selectedMapelId: data['selected_mapel_id'],
      selectedMuridId: data['selected_murid_id'],
      selectedJenisUjian: data['selected_jenis_ujian']?.toString(),
    );
  }
}

class MapelOptionMini {
  final int id;
  final String namaMapel;

  MapelOptionMini({required this.id, required this.namaMapel});

  factory MapelOptionMini.fromJson(Map<String, dynamic> json) {
    return MapelOptionMini(
      id: json['id'] ?? 0,
      namaMapel: (json['nama_mapel'] ?? json['nama'] ?? '').toString(),
    );
  }
}

class MuridOptionMini {
  final int id;
  final String name;
  final String? nisnNip;

  MuridOptionMini({required this.id, required this.name, this.nisnNip});

  factory MuridOptionMini.fromJson(Map<String, dynamic> json) {
    return MuridOptionMini(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      nisnNip: (json['nisn_nip'])?.toString(),
    );
  }
}
