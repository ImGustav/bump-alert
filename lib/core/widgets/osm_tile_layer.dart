import 'package:flutter_map/flutter_map.dart';

/// Camada de tiles do OpenStreetMap, reutilizada por todos os mapas.
/// O userAgentPackageName é exigido pela política de uso dos tiles OSM.
TileLayer osmTileLayer() => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'br.edu.olhonarua.olho_na_rua',
);
