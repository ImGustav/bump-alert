class Bump {
  const Bump({
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.intensity,
  });

  final DateTime time;
  final double latitude;
  final double longitude;

  final double intensity;
}
