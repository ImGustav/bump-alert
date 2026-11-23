import 'package:flutter/material.dart';

import '../features/reports/pages/new_report_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void openBumpReport(double lat, double lng) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => NewReportPage(
        initialLatitude: lat,
        initialLongitude: lng,
        fromBump: true,
      ),
    ),
  );
}

void openReportFromPayload(String? payload) {
  final parts = payload?.split(',');
  if (parts == null || parts.length != 2) return;
  final lat = double.tryParse(parts[0]);
  final lng = double.tryParse(parts[1]);
  if (lat != null && lng != null) openBumpReport(lat, lng);
}
