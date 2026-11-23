import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Recurso 3 — NOTIFICAÇÃO LOCAL.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  /// Chamado quando o usuário toca na notificação (payload = "lat,lng").
  void Function(String? payload)? onTap;

  static const _channel = AndroidNotificationDetails(
    'solavancos',
    'Solavancos detectados',
    channelDescription:
        'Avisos quando o Modo Trajeto detecta um possível buraco',
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (resp) => onTap?.call(resp.payload),
    );
  }

  /// Se o app foi aberto (estando fechado) tocando numa notificação,
  /// devolve o payload dela.
  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

  /// Android 13+ exige pedir POST_NOTIFICATIONS em tempo de execução.
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? true;
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: _channel,
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
