import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Local notification setup
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // iOS: handle notification while app is in foreground (for older iOS versions)
        print("🔔 iOS Local Notification Received: $title - $body");
      },
    );
    var initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle tap
        print("🔁 Notification tapped: ${details.payload}");
      },
    );

    // Request FCM permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // if (Platform.isIOS) {
    //   final apnsToken = await _fcm.getAPNSToken();
    //   print("📱 APNs Token: $apnsToken");
    // }

    // Register token refresh
    _fcm.onTokenRefresh.listen(_updateTokenToFirestore);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground message: ${message.notification?.title}');
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // Background message handler (must also be registered in main.dart)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📨 Notification opened from background: ${message.notification?.title}");
      // Navigate or show dialog
    });

    // Initial message when app launched from terminated
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 App launched from terminated via notification: ${initialMessage.notification?.title}");
    }

    // Update token initially
    await updateToken();

    // Setup notification channel (for Android 8+)
    const androidChannel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Default notification channel',
      importance: Importance.high,
    );

    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body',
      platformDetails,
    );
  }

  static Future<void> _updateTokenToFirestore(String token) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }

  static Future<void> updateToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      print("📡 FCM Token: $token");
      await _updateTokenToFirestore(token);
    }
  }
}
