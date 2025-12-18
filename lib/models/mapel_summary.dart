// lib/models/mapel_summary.dart
class MapelSummary {
  final int id;
  final String namaMapel;
  final int kelasId;
  final String? kelasNama;
  final String hari;
  final String jamMulai;
  final String jamAkhir;
  final int guruId;
  final String? guruNama;

  MapelSummary({
    required this.id,
    required this.namaMapel,
    required this.kelasId,
    required this.hari,
    required this.jamMulai,
    required this.jamAkhir,
    required this.guruId,
    this.kelasNama,
    this.guruNama,
  });

  factory MapelSummary.fromJson(Map<String, dynamic> json) {
    // kadang backend kirim "kelas_nama", kadang nested "kelas" => "nama_kelas"
    String? kelasNama;
    if (json['kelas_nama'] != null) {
      kelasNama = json['kelas_nama'].toString();
    } else if (json['kelas'] is Map<String, dynamic>) {
      kelasNama =
          (json['kelas'] as Map<String, dynamic>)['nama_kelas']?.toString();
    }

    // sama untuk guru
    String? guruNama;
    if (json['guru_nama'] != null) {
      guruNama = json['guru_nama'].toString();
    } else if (json['guru'] is Map<String, dynamic>) {
      guruNama = (json['guru'] as Map<String, dynamic>)['name']?.toString();
    }

    int _parseInt(dynamic v, {int defaultValue = 0}) {
      if (v == null) return defaultValue;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? defaultValue;
    }

    return MapelSummary(
      id: _parseInt(json['id']),
      namaMapel: (json['nama_mapel'] ?? 'Tanpa Nama').toString(),
      kelasId: _parseInt(json['kelas_id']),
      kelasNama: kelasNama,
      hari: (json['hari'] ?? '-').toString(),
      jamMulai: (json['jam_mulai'] ?? '-').toString(),
      jamAkhir: (json['jam_akhir'] ?? '-').toString(),
      guruId: _parseInt(json['guru_id']),
      guruNama: guruNama,
    );
  }
}
