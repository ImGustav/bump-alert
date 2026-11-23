/// Um solavanco detectado durante o trajeto.
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

  /// Desvio em relação à gravidade, em m/s².
  final double intensity;
}
