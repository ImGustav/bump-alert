import 'package:flutter/material.dart';

import '../domain/report.dart';

/// Marcador da denúncia no mapa: círculo branco com borda vermelha e o
/// emoji do tipo. Vermelho = "alerta", para não confundir com o ponto azul
/// da localização atual.
class ReportMarker extends StatelessWidget {
  const ReportMarker({super.key, required this.report, this.onTap});

  final Report report;
  final VoidCallback? onTap;

  static const _alertColor = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _alertColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(report.type.emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
