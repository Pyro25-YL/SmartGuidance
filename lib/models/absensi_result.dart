class AbsensiResult {
  final String message;

  AbsensiResult({required this.message});

  factory AbsensiResult.fromJson(Map<String, dynamic> json) {
    return AbsensiResult(message: json['message']);
  }
}
