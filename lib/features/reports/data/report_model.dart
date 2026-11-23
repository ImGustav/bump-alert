import '../domain/report.dart';

extension ReportMapper on Report {
  Map<String, Object?> toMap() => {
    'photo_path': photoPath,
    'latitude': latitude,
    'longitude': longitude,
    'created_at': createdAt.millisecondsSinceEpoch,
    'from_bump': fromBump ? 1 : 0,
  };
}

Report reportFromMap(Map<String, Object?> m) => Report(
  id: m['id'] as int,
  photoPath: m['photo_path'] as String?,
  latitude: m['latitude'] as double,
  longitude: m['longitude'] as double,
  createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
  fromBump: (m['from_bump'] as int) == 1,
);
