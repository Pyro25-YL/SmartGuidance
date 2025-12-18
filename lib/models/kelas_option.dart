class KelasOption {
  final int id;
  final String namaKelas;

  const KelasOption({
    required this.id,
    required this.namaKelas,
  });

  factory KelasOption.fromJson(Map<String, dynamic> json) {
    return KelasOption(
      id: int.parse(json['id'].toString()),
      namaKelas: json['nama_kelas'].toString(),
    );
  }
}
