import 'dart:async';

import '../../../core/viewmodel/view_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import '../domain/bump.dart';
import '../domain/bump_detector.dart';

/// INTEGRAÇÃO: acelerômetro → GPS → notificação.
class RideModeViewModel extends ViewModel {
  RideModeViewModel(this._location, this._notifications) {
    _detector = BumpDetector(onBump: _handleBump, onSample: _handleSample);
  }

  final LocationService _location;
  final NotificationService _notifications;
  late final BumpDetector _detector;
  StreamSubscription<Position>? _positionSub;
  Position? _lastPosition;

  bool active = false;
  bool starting = false;
  AccelerometerEvent? sample;
  double deviation = 0;
  final List<Bump> bumps = [];

  double get threshold => _detector.threshold;
  set threshold(double v) {
    _detector.threshold = v;
    notifyListeners();
  }

  /// Retorna uma mensagem de erro, ou null se iniciou.
  Future<String?> start() async {
    starting = true;
    notifyListeners();
    try {
      // Pede as permissões logo ao ligar o modo, não no meio do trajeto.
      await _notifications.requestPermission();
      _lastPosition = await _location.getCurrentPosition();
      // Acompanha a posição continuamente: no solavanco já temos o local.
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 3,
        ),
      ).listen((p) => _lastPosition = p);
      _detector.start();
      active = true;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      starting = false;
      notifyListeners();
    }
  }

  void stop() {
    _detector.stop();
    _positionSub?.cancel();
    _positionSub = null;
    active = false;
    notifyListeners();
  }

  void _handleSample(AccelerometerEvent e, double dev) {
    sample = e;
    deviation = dev;
    notifyListeners();
  }

  Future<void> _handleBump(double intensity) async {
    final pos = _lastPosition;
    if (pos == null) return;
    final bump = Bump(
      time: DateTime.now(),
      latitude: pos.latitude,
      longitude: pos.longitude,
      intensity: intensity,
    );
    bumps.insert(0, bump);
    notifyListeners();
    await _notifications.show(
      title: 'Solavanco detectado! 🕳️',
      body: 'Quer registrar um buraco aqui? Toque para tirar a foto.',
      payload: '${bump.latitude},${bump.longitude}',
    );
  }

  @override
  void dispose() {
    _detector.stop();
    _positionSub?.cancel();
    super.dispose();
  }
}
