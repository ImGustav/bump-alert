import 'package:flutter/material.dart';

import '../features/reports/domain/report.dart';
import '../features/reports/pages/new_report_page.dart';

/// Chave global para navegar de fora da árvore de widgets
/// (ex.: callback de toque na notificação).
final navigatorKey = GlobalKey<NavigatorState>();

/// Abre o formulário de denúncia já preenchido com o local de um solavanco.
void openBumpReport(double lat, double lng) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => NewReportPage(
        initialType: ReportType.buraco,
        initialLatitude: lat,
        initialLongitude: lng,
        fromBump: true,
      ),
    ),
  );
}

/// Payload da notificação de solavanco: "lat,lng".
void openReportFromPayload(String? payload) {
  final parts = payload?.split(',');
  if (parts == null || parts.length != 2) return;
  final lat = double.tryParse(parts[0]);
  final lng = double.tryParse(parts[1]);
  if (lat != null && lng != null) openBumpReport(lat, lng);
}
