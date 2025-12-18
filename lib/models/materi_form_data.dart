import 'mapel_option.dart';

class MateriFormData {
  final List<MapelOption> mapelHariIni;
  final MapelOption? selectedMapel;
  final String? initialMateri;

  const MateriFormData({
    required this.mapelHariIni,
    this.selectedMapel,
    this.initialMateri,
  });
}
