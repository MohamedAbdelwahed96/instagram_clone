import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print("Permission status: ${settings.authorizationStatus}");
  }

  Future<void> setupFlutterNotifications() async {
    if (_isInitialized) return;
    const channel = AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      description: "This channel is used for important notifications",
      importance: Importance.high,
    );

    await _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(initializationSettings);
    _isInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "high_importance_channel",
            "High Importance Notifications",
            channelDescription: "This channel is used for important notifications.",
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      /// Handle navigation to chat screen
    }
  }

  Future<void> sendPushNotification({
    required String fcmToken,
    required String senderId,
    required String message,
  }) async {
    try {
      const String serverKey = "API Key";
      const String fcmUrl = "https://fcm.googleapis.com/fcm/send";

      // Notification payload
      Map<String, dynamic> notificationPayload = {
        "to": fcmToken,
        "notification": {
          "title": "New Message",
          "body": message,
        },
        "data": {
          "senderId": senderId,
          "message": message,
        },
      };

      // Send HTTP request to FCM
      await http.post(
        Uri.parse(fcmUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(notificationPayload),
      );
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }
}
