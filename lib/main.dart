// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medsos/views/Patient_part/chat/providers/chat_provider.dart';
import 'package:medsos/views/Patient_part/chat/providers/settings_provider.dart';
import 'package:medsos/views/Patient_part/chat/themes/my_theme.dart';
import 'package:medsos/firebase_options.dart';
import 'package:medsos/routes/app_routes.dart';
import 'package:medsos/service/notifi_service.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await initializeDateFormatting(); // charge tous les formats

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.initializeNotification();
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   // appleProvider: AppleProvider.debug,
  // );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // appleProvider: AppleProvider.debug,
  //   // Set androidProvider to `AndroidProvider.debug`
  //   androidProvider: AndroidProvider.debug,
  // );

  await ZegoUIKit().init(
    appID: 161301344,
    appSign: 'd08ec3526554dbc6a6d064ec267f6ad95fe0f67a812fdb16bec528a0e1215e12',
  );

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);
  });

  await ChatProvider.initHive();

  // ✅ PRELOAD user
  final userProvider = UserProvider();
  await userProvider.loadUser(); // <--- This is the missing piece

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => userProvider), // ✅ injected here
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() {
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.getSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MedSOS',
      theme:
          context.watch<SettingsProvider>().isDarkMode ? darkTheme : lightTheme,
      routerConfig: appRouter,
      builder:
          (context, child) =>
              Overlay(initialEntries: [OverlayEntry(builder: (_) => child!)]),
      // 👇 makes sure navigatorKey is used globally
      // 🔁 utilisation de GoRouter ici
    );
  }
}
