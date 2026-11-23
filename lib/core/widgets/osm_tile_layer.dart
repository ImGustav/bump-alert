import 'package:flutter_map/flutter_map.dart';

TileLayer osmTileLayer() => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'br.edu.olhonarua.olho_na_rua',
);
