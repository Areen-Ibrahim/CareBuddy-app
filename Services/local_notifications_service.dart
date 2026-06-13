import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    await Permission.notification.request();
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(requestAlertPermission: true,requestSoundPermission: true),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      settings
    );
  }

  static Future<void> showImmediatelyNotify({required String body}) async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'Notifications',
      'Carebuddy Notifications',
      importance: Importance.max,
      priority: Priority.high
    );
    DarwinNotificationDetails ios = const DarwinNotificationDetails();
    NotificationDetails details = NotificationDetails(android: android,iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
      0,
      "Carebuddy",
      body,
      details
    );
  }
}

