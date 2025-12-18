import 'mapel_option.dart';

/// Data form materi: mapel hari ini + (opsional) mapel terpilih + status absensi
class MateriFormData {
  final List<MapelOption> mapelHariIni;
  final MapelOption? selectedMapel;
  final bool needAbsensi;
  final String? absensiMessage;

  const MateriFormData({
    required this.mapelHariIni,
    required this.selectedMapel,
    required this.needAbsensi,
    required this.absensiMessage,
  });
}

/// Kalau mau, model untuk record materi yang baru dibuat
class MateriRecord {
  final int id;
  final int mapelId;
  final String materi;

  const MateriRecord({
    required this.id,
    required this.mapelId,
    required this.materi,
  });

  factory MateriRecord.fromJson(Map<String, dynamic> json) {
    return MateriRecord(
      id: int.parse(json['id'].toString()),
      mapelId: int.parse(json['mapel_id'].toString()),
      materi: json['materi'] as String,
    );
  }
}
