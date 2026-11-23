import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Recurso 4 — ACELERÔMETRO (+ integração).
///
/// Com o celular parado, o módulo do vetor (x, y, z) ≈ 9,81 m/s² (gravidade).
/// Um solavanco faz esse valor desviar bruscamente. Se o desvio passar do
/// [threshold] e já tiver passado o [cooldown] desde o último, dispara [onBump].
class BumpDetector {
  BumpDetector({required this.onBump, this.onSample});

  final void Function(double intensity) onBump;

  /// Opcional: recebe cada leitura (para exibir X/Y/Z ao vivo).
  final void Function(AccelerometerEvent event, double deviation)? onSample;

  /// Limiar em m/s² (ajustável pelo slider de sensibilidade).
  double threshold = 8.0;
  Duration cooldown = const Duration(seconds: 3);

  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime _lastBump = DateTime.fromMillisecondsSinceEpoch(0);

  bool get isRunning => _sub != null;

  void start() {
    _sub ??= accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onEvent);
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }

  void _onEvent(AccelerometerEvent e) {
    final magnitude = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    final deviation = (magnitude - 9.81).abs();
    onSample?.call(e, deviation);
    final now = DateTime.now();
    if (deviation > threshold && now.difference(_lastBump) > cooldown) {
      _lastBump = now;
      onBump(deviation);
    }
  }
}
