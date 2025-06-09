import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification(RemoteMessage message) async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {});
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotification(message);
      showNotifications(message);
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    String? image = message.notification!.android!.imageUrl;
    String uid = message.data['uid'];
    AndroidNotificationChannel android = AndroidNotificationChannel(
        Random.secure().nextInt(10000000).toString(), 'Hey Buddy');

    final bytes = await NetworkAssetBundle(Uri.parse(image!)).load(image);
    final imageBytes = Uint8List.view(bytes.buffer);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      android.id,
      android.name,
      channelDescription: 'Hey Buddy Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      groupKey: uid,

      largeIcon: ByteArrayAndroidBitmap(imageBytes),
    );

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permission granted...');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('Provisional permission granted...');
    } else {
      debugPrint('Permission denied...');
    }
  }

  Future<String> getToken() async {
    final token = await messaging.getToken();
    return token!;
  }
}
