import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medsos/firebase_options.dart';

/// ✅ TOP-LEVEL background tap handler — required
@pragma('vm:entry-point')
void onBackgroundNotificationTap(NotificationResponse response) {
  print('🔔 User tapped notification in background: ${response.payload}');
}

/// ✅ TOP-LEVEL FCM background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService._initializeLocalNotification();
  await NotificationService._showFlutterNotification(message);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// ✅ Initializes FCM and Local Notifications
  static Future<void> initializeNotification() async {
    print('🔄 Initializing Firebase Messaging...');

    // Request permission (especially on iOS)
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    print('🔐 Notification permission status: ${settings.authorizationStatus}');

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📨 Foreground message received: ${message.data}');
      await _showFlutterNotification(message);
    });

    // Notification tap while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 App opened from background notification: ${message.data}');
    });

    // Print FCM token
    await _getFcmToken();

    // Init local notifications
    await _initializeLocalNotification();

    // Check for launch via terminated-state notification
    await _getInitialNotification();
  }

  /// ✅ Get and print the FCM token (always)
  static Future<void> _getFcmToken() async {
    try {
      print('📡 Requesting FCM token...');
      String? token = await _firebaseMessaging.getToken();

      if (token == null) {
        print('❌ Failed to get FCM token — null value');
      } else {
        print('✅ FCM Token: $token');
      }
    } catch (e) {
      print('❌ Exception while getting FCM token: $e');
    }
  }

  /// ✅ Show local notification from remote message
  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No title';
    String body = notification?.body ?? data['body'] ?? 'No body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notification channel for basic tests',
      priority: Priority.high,
      importance: Importance.high,
    );

    DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  /// ✅ Local notifications init
  static Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const DarwinInitializationSettings iOSInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
    );
  }

  /// ✅ Handle tap from terminated state
  static Future<void> _getInitialNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print(
        '📦 App launched from terminated state via notification: ${message.data}',
      );
    }
  }
}
