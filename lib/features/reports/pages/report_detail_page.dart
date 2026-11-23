import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../app/dependencies.dart';
import '../../../core/widgets/osm_tile_layer.dart';
import '../domain/report.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key, required this.report});

  final Report report;

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir denúncia?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await deps.reportRepository.remove(report);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final point = LatLng(report.latitude, report.longitude);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('🕳️ Buraco'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (report.hasPhoto)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.file(
                File(report.photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latitude: ${report.latitude.toStringAsFixed(6)}',
                  style: text.titleSmall,
                ),
                Text(
                  'Longitude: ${report.longitude.toStringAsFixed(6)}',
                  style: text.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat(
                    "dd/MM/yyyy 'às' HH:mm",
                    'pt_BR',
                  ).format(report.createdAt),
                ),
                if (report.fromBump)
                  const Text('Origem: solavanco detectado no Modo Trajeto'),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 17,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                osmTileLayer(),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
