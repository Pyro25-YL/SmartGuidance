class GuruOption {
  final int id;
  final String name;
  final String? nisnNip;

  const GuruOption({
    required this.id,
    required this.name,
    this.nisnNip,
  });

  factory GuruOption.fromJson(Map<String, dynamic> json) {
    return GuruOption(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? 'Tanpa Nama',
      nisnNip: json['nisn_nip']?.toString(),
    );
  }
}
