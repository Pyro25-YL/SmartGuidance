class RapotFormData {
  final List<RapotUserOption> murid;
  final List<RapotKelasOption> kelas;
  final List<RapotMapelOption> mapel;
  final List<String> semester;

  RapotFormData({
    required this.murid,
    required this.kelas,
    required this.mapel,
    required this.semester,
  });

  factory RapotFormData.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? {});

    final muridList = (data['murid'] as List<dynamic>? ?? [])
        .map((e) => RapotUserOption.fromJson(e as Map<String, dynamic>))
        .toList();

    final kelasList = (data['kelas'] as List<dynamic>? ?? [])
        .map((e) => RapotKelasOption.fromJson(e as Map<String, dynamic>))
        .toList();

    final mapelList = (data['mapel'] as List<dynamic>? ?? [])
        .map((e) => RapotMapelOption.fromJson(e as Map<String, dynamic>))
        .toList();

    final semList = (data['semester'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return RapotFormData(
      murid: muridList,
      kelas: kelasList,
      mapel: mapelList,
      semester: semList,
    );
  }
}

class RapotUserOption {
  final int id;
  final String name;
  final String? nisnNip;

  RapotUserOption({
    required this.id,
    required this.name,
    this.nisnNip,
  });

  factory RapotUserOption.fromJson(Map<String, dynamic> json) {
    return RapotUserOption(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      nisnNip:
          (json['nisn_nip'] ?? json['nisnNip'] ?? json['nisn'] ?? json['nip'])
              ?.toString(),
    );
  }
}

class RapotKelasOption {
  final int id;
  final String namaKelas;

  RapotKelasOption({
    required this.id,
    required this.namaKelas,
  });

  factory RapotKelasOption.fromJson(Map<String, dynamic> json) {
    return RapotKelasOption(
      id: json['id'] ?? 0,
      namaKelas: (json['nama_kelas'] ?? json['namaKelas'] ?? '').toString(),
    );
  }
}

class RapotMapelOption {
  final int id;
  final String namaMapel;

  RapotMapelOption({
    required this.id,
    required this.namaMapel,
  });

  factory RapotMapelOption.fromJson(Map<String, dynamic> json) {
    return RapotMapelOption(
      id: json['id'] ?? 0,
      namaMapel: (json['nama_mapel'] ?? json['namaMapel'] ?? json['nama'] ?? '')
          .toString(),
    );
  }
}
