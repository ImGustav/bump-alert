import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  void Function(String? payload)? onTap;

  static const _channel = AndroidNotificationDetails(
    'solavancos',
    'Solavancos detectados',
    channelDescription:
        'Avisos quando o Modo Trajeto detecta um possível buraco',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const _hazardChannel = AndroidNotificationDetails(
    'alertas_buraco',
    'Alertas de buraco',
    channelDescription: 'Avisa quando você se aproxima de um buraco registrado',
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

  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

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
    bool hazard = false,
  }) async {
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: hazard ? _hazardChannel : _channel,
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
