import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/firebase_options.dart';
import 'package:csm/repository/auth_repository.dart';
import 'package:csm/repository/package_repository.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'src/features/home/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up Firebase Messaging for background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Step 1: Request iOS permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Step 2: Wait for APNs token (iOS only)
    String? apnsToken;
    int retries = 5;

    for (int i = 0; i < retries; i++) {
      apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) break;
      await Future.delayed(Duration(seconds: 2));
    }

    if (apnsToken == null) {
      print('❌ Failed to get APNs token');
      return;
    }

    print('✅ APNs Token: $apnsToken');

    // Step 3: Now get the FCM token
    String? fcmToken = await messaging.getToken();
    print('✅ FCM Token: $fcmToken');
  } else {
    print('❌ Notifications permission not granted');
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background notifications here, you can show a local notification as well
  showNotification(message);
}

final appRouter = AppRouter();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => PackageCubit(PackageRepository(FirebaseFirestore.instance, FirebaseAuth.instance))),
        BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance, AuthRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          ColorTheme.isDark = isDark;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
            theme: ThemeData(fontFamily: 'Comfortaa'),
          );
        },
      ),
    );
  }
}

Future<void> setupLocalNotifications() async {
  // Android specific settings
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS specific settings
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Initialize settings for both Android and iOS
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Initialize the FlutterLocalNotificationsPlugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
    print("Notification clicked: ${response.payload}");
    // You can handle navigation or any action based on notification here
  });
}

// Show notification (Android and iOS)
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: false,
  );
  const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: message.data.toString(), // You can add extra data here if needed
  );
}
