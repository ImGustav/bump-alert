import '../domain/report.dart';

/// Conversão entre a entidade [Report] e uma linha da tabela `reports`.
extension ReportMapper on Report {
  Map<String, Object?> toMap() => {
    'type': type.name,
    // Coluna mantida para não quebrar bancos já criados; sem uso no app.
    'description': '',
    'photo_path': photoPath,
    'latitude': latitude,
    'longitude': longitude,
    'created_at': createdAt.millisecondsSinceEpoch,
    'from_bump': fromBump ? 1 : 0,
  };
}

Report reportFromMap(Map<String, Object?> m) => Report(
  id: m['id'] as int,
  type: ReportType.values.byName(m['type'] as String),
  photoPath: m['photo_path'] as String,
  latitude: m['latitude'] as double,
  longitude: m['longitude'] as double,
  createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
  fromBump: (m['from_bump'] as int) == 1,
);
