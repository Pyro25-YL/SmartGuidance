class NilaiFormData {
  final List<NilaiMapelOption> mapel;
  final List<NilaiUserOption> murid;
  final int? selectedMapelId;
  final int? selectedMuridId;

  NilaiFormData({
    required this.mapel,
    required this.murid,
    this.selectedMapelId,
    this.selectedMuridId,
  });

  factory NilaiFormData.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? {});
    final mapelList = (data['mapel'] as List<dynamic>? ?? [])
        .map((e) => NilaiMapelOption.fromJson(e as Map<String, dynamic>))
        .toList();

    final muridList = (data['murid'] as List<dynamic>? ?? [])
        .map((e) => NilaiUserOption.fromJson(e as Map<String, dynamic>))
        .toList();

    return NilaiFormData(
      mapel: mapelList,
      murid: muridList,
      selectedMapelId: data['selected_mapel_id'],
      selectedMuridId: data['selected_murid_id'],
    );
  }
}

class NilaiMapelOption {
  final int id;
  final String namaMapel;

  NilaiMapelOption({required this.id, required this.namaMapel});

  factory NilaiMapelOption.fromJson(Map<String, dynamic> json) {
    return NilaiMapelOption(
      id: json['id'] ?? 0,
      namaMapel: (json['nama_mapel'] ?? json['nama'] ?? '').toString(),
    );
  }
}

class NilaiUserOption {
  final int id;
  final String name;
  final String? nisnNip;

  NilaiUserOption({required this.id, required this.name, this.nisnNip});

  factory NilaiUserOption.fromJson(Map<String, dynamic> json) {
    return NilaiUserOption(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      nisnNip: (json['nisn_nip'])?.toString(),
    );
  }
}
