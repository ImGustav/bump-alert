import 'dart:async';

import '../../../core/viewmodel/view_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import '../../reports/domain/report.dart';
import '../../reports/domain/report_repository.dart';
import '../domain/bump.dart';
import '../domain/bump_detector.dart';

class RideModeViewModel extends ViewModel {
  RideModeViewModel(this._location, this._notifications, this._repository) {
    _detector = BumpDetector(onBump: _handleBump, onSample: _handleSample);
  }

  static const alertRadius = 50.0;

  final LocationService _location;
  final NotificationService _notifications;
  final ReportRepository _repository;
  late final BumpDetector _detector;
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<void>? _reportsSub;
  Position? _lastPosition;

  List<Report> _reports = [];
  final Set<int> _alerted = {};

  bool active = false;
  bool starting = false;
  AccelerometerEvent? sample;
  double deviation = 0;
  final List<Bump> bumps = [];
  String? lastAlert;

  double get threshold => _detector.threshold;
  set threshold(double v) {
    _detector.threshold = v;
    notifyListeners();
  }

  Future<String?> start() async {
    starting = true;
    notifyListeners();
    try {
      await _notifications.requestPermission();
      _lastPosition = await _location.getCurrentPosition();
      _alerted.clear();
      lastAlert = null;
      _reports = await _repository.getAll();
      _reportsSub = _repository.onChanged.listen((_) => _reloadReports());
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 3,
        ),
      ).listen(_handlePosition);
      _detector.start();
      active = true;
      _checkNearby(_lastPosition!);
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
    _reportsSub?.cancel();
    _reportsSub = null;
    active = false;
    notifyListeners();
  }

  void _handlePosition(Position p) {
    _lastPosition = p;
    _checkNearby(p);
  }

  Future<void> _reloadReports() async {
    final known = _reports.map((r) => r.id).toSet();
    _reports = await _repository.getAll();
    final pos = _lastPosition;
    if (pos == null) return;
    for (final r in _reports) {
      if (!known.contains(r.id) && _distanceTo(pos, r) <= alertRadius) {
        _alerted.add(r.id!);
      }
    }
  }

  double _distanceTo(Position p, Report r) => Geolocator.distanceBetween(
    p.latitude,
    p.longitude,
    r.latitude,
    r.longitude,
  );

  void _checkNearby(Position p) {
    for (final r in _reports) {
      if (_alerted.contains(r.id)) continue;
      final distance = _distanceTo(p, r);
      if (distance <= alertRadius) {
        _alerted.add(r.id!);
        _alertHazard(distance);
      }
    }
  }

  Future<void> _alertHazard(double distance) async {
    final meters = distance.round();
    lastAlert =
        'Buraco a $meters m (${DateFormat.Hms().format(DateTime.now())})';
    notifyListeners();
    await _notifications.show(
      title: '⚠️ Buraco a $meters m!',
      body: 'Há um buraco registrado logo adiante. Reduza a velocidade.',
      hazard: true,
    );
  }

  Future<void> simulateBump() async {
    if (!active) return;
    await _handleBump(threshold * 1.5);
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
    _reportsSub?.cancel();
    super.dispose();
  }
}
