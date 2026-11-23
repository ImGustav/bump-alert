import 'package:geolocator/geolocator.dart';

/// Recurso 2 — GPS.
/// Fluxo: serviço de localização ligado? → permissão concedida? → posição.
class LocationService {
  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationException('Ative a localização (GPS) do celular.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw LocationException('Permissão de localização negada.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Permissão de localização negada permanentemente. '
        'Libere nas configurações do app.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}

class LocationException implements Exception {
  LocationException(this.message);
  final String message;
  @override
  String toString() => message;
}
