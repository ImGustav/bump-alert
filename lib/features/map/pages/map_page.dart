import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../app/dependencies.dart';
import '../../../core/widgets/osm_tile_layer.dart';
import '../../reports/pages/new_report_page.dart';
import '../../reports/pages/report_detail_page.dart';
import '../../reports/widgets/report_marker.dart';
import '../viewmodels/map_view_model.dart';

/// Desafio extra: mapa com a localização atual + todas as denúncias.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  late final _vm = MapViewModel(deps.reportRepository, deps.location);

  @override
  void initState() {
    super.initState();
    _locateMe();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _locateMe() async {
    final error = await _vm.locateMe();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      _mapController.move(_vm.myPosition!, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olho na Rua'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ListenableBuilder(
                listenable: _vm,
                builder: (_, __) => Text('${_vm.reports.length} denúncia(s)'),
              ),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(-15.7939, -47.8828), // Brasil até achar o GPS
          initialZoom: 4,
        ),
        children: [
          osmTileLayer(),
          ListenableBuilder(
            listenable: _vm,
            builder: (context, _) => MarkerLayer(
              markers: [
                // Minha posição vem primeiro: assim as denúncias ficam
                // desenhadas por cima e não somem quando estão no mesmo lugar.
                if (_vm.myPosition != null)
                  Marker(
                    point: _vm.myPosition!,
                    width: 22,
                    height: 22,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                for (final r in _vm.reports)
                  Marker(
                    point: LatLng(r.latitude, r.longitude),
                    width: 44,
                    height: 44,
                    child: ReportMarker(
                      report: r,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailPage(report: r),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'locate',
            onPressed: _locateMe,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'new',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewReportPage()),
            ),
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Denunciar'),
          ),
        ],
      ),
    );
  }
}
