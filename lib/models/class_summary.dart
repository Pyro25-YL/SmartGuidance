class ClassSummary {
  final int id;
  final String namaKelas;
  final int jumlahSiswa;
  final String? waliNama;
  final String? waliNisnNip;

  const ClassSummary({
    required this.id,
    required this.namaKelas,
    required this.jumlahSiswa,
    this.waliNama,
    this.waliNisnNip,
  });

  factory ClassSummary.fromJson(Map<String, dynamic> json) {
    final wali = json['wali_kelas'];

    return ClassSummary(
      id: _parseInt(json['id']),
      namaKelas: (json['nama_kelas'] ?? 'Tanpa Nama').toString(),
      jumlahSiswa: _parseInt(json['jumlah_siswa'], defaultValue: 0),
      waliNama: wali is Map<String, dynamic> ? wali['name']?.toString() : null,
      waliNisnNip:
          wali is Map<String, dynamic> ? wali['nisn_nip']?.toString() : null,
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? defaultValue;
  }
}
