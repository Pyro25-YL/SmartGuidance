class MapelOption {
  final int id;
  final String namaMapel;
  final String? namaKelas;

  /// format "HH:MM"
  final String jamMulai;

  /// format "HH:MM"
  final String jamAkhir;
  final String? hari;

  const MapelOption({
    required this.id,
    required this.namaMapel,
    this.namaKelas,
    required this.jamMulai,
    required this.jamAkhir,
    this.hari,
  });

  factory MapelOption.fromJson(Map<String, dynamic> json) {
    String _toHHmm(dynamic v) {
      final s = (v ?? '').toString();
      if (s.length >= 5) return s.substring(0, 5);
      return s;
    }

    return MapelOption(
      id: int.parse(json['id'].toString()),
      namaMapel: json['nama_mapel']?.toString() ?? '',
      namaKelas: json['kelas'] != null
          ? json['kelas']['nama_kelas']?.toString()
          : null,
      jamMulai: _toHHmm(json['jam_mulai']),
      jamAkhir: _toHHmm(json['jam_akhir']),
      hari: json['hari']?.toString(),
    );
  }
}
