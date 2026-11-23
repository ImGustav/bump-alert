import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/report.dart';

/// Card com foto + coordenadas na mesma tela (desafio extra).
class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, this.onTap});

  final Report report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final date = DateFormat(
      "dd/MM/yyyy 'às' HH:mm",
      'pt_BR',
    ).format(report.createdAt);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.file(
              File(report.photoPath),
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 110,
                height: 110,
                child: Icon(Icons.broken_image),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${report.type.emoji} ${report.type.label}',
                      style: text.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${report.latitude.toStringAsFixed(6)}, '
                      '${report.longitude.toStringAsFixed(6)}',
                      style: text.bodySmall,
                    ),
                    Text(date, style: text.bodySmall),
                    if (report.fromBump)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Chip(
                          label: Text('Detectado por solavanco'),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
