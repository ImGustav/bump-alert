import 'dart:async';
import 'dart:math';

import '../../../core/viewmodel/view_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/services/notification_service.dart';

class SensorViewModel extends ViewModel {
  SensorViewModel(this._notifications) {
    _sub = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
        .listen(
          (e) {
            event = e;
            notifyListeners();
          },
          onError: (_) {
            error = 'Acelerômetro indisponível neste aparelho.';
            notifyListeners();
          },
        );
  }

  final NotificationService _notifications;
  late final StreamSubscription<AccelerometerEvent> _sub;

  AccelerometerEvent? event;
  String? error;

  double get x => event?.x ?? 0;
  double get y => event?.y ?? 0;
  double get z => event?.z ?? 0;
  double get magnitude => sqrt(x * x + y * y + z * z);

  Future<void> testNotification() async {
    await _notifications.requestPermission();
    await _notifications.show(
      title: 'Olho na Rua 👀',
      body: 'Notificação local funcionando!',
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
