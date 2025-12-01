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
    final wali = json['wali_kelas'] as Map<String, dynamic>?;

    return ClassSummary(
      id: int.parse(json['id'].toString()),
      namaKelas: json['nama_kelas'] as String,
      jumlahSiswa: int.parse((json['jumlah_siswa'] ?? 0).toString()),
      waliNama: wali != null ? wali['name'] as String? : null,
      waliNisnNip: wali != null ? wali['nisn_nip']?.toString() : null,
    );
  }
}
