class SchoolLocation {
  final double latitude;
  final double longitude;
  final double radiusMeter;

  const SchoolLocation({
    required this.latitude,
    required this.longitude,
    required this.radiusMeter,
  });

  factory SchoolLocation.fromJson(Map<String, dynamic> json) {
    return SchoolLocation(
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      radiusMeter: double.parse(json['radius_jarak_absen'].toString()),
    );
  }
}
