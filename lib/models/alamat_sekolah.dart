class AlamatSekolah {
  final int? id;
  final String? alamat;
  final double latitude;
  final double longitude;
  final int radiusJarakAbsen;

  const AlamatSekolah({
    this.id,
    this.alamat,
    required this.latitude,
    required this.longitude,
    required this.radiusJarakAbsen,
  });

  factory AlamatSekolah.fromJson(Map<String, dynamic> json) {
    return AlamatSekolah(
      id: json['id'] == null ? null : int.tryParse(json['id'].toString()),

      alamat: json['alamat'] as String?,

      // <- perbaikan utama: selalu parse dari String
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),

      radiusJarakAbsen: int.parse(json['radius_jarak_absen'].toString()),
    );
  }

  Map<String, dynamic> toJsonBody() {
    return {
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'radius_jarak_absen': radiusJarakAbsen,
    };
  }

  bool get isNew => id == null;

  AlamatSekolah copyWith({
    int? id,
    String? alamat,
    double? latitude,
    double? longitude,
    int? radiusJarakAbsen,
  }) {
    return AlamatSekolah(
      id: id ?? this.id,
      alamat: alamat ?? this.alamat,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusJarakAbsen: radiusJarakAbsen ?? this.radiusJarakAbsen,
    );
  }
}
