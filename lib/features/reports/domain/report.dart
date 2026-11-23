class Report {
  const Report({
    this.id,
    this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.fromBump = false,
  });

  final int? id;
  final String? photoPath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final bool fromBump;

  bool get hasPhoto => photoPath != null;
}
