import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/auth/login.dart';
import 'package:smart_naka_ethos/screens/navPages/bottomNav.dart';
import 'package:smart_naka_ethos/screens/navPages/profile.dart';
import 'package:smart_naka_ethos/splash.dart';
import 'package:smart_naka_ethos/themes.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    requestPermission();
    _checkLoginPrefs();
    _checkForNotifications();
  }

  _checkForNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print("FirebaseMessaging Background --------------> ${message.data}");
        if (message.data['body'] != null) {
          print(message.data['body']);
          Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
              (route) => false);
        }
      },
    ); // Background message
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FirebaseMessaging Foreground ${message.data}");
        if (message.data['title'] == 'This is a message') {
          print("Working");
          Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
              (route) => false);
        }
      },
    ); // Foreground message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _checkLoginPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      },
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // initInfo() {
  //   var androidInitialize =
  //       const AndroidInitializationSettings('@ipmap/ic_launcher');
  //   // var iOSInitialize = const IOSInitializationSettings();
  //   var initializationsSettings =
  //       InitializationSettings(android: androidInitialize);
  //   flutterLocalNotificationsPlugin.initialize(initializationsSettings,
  //       onSelectNotification: (String? payload) async {
  //     try {
  //       print('Working --------------');
  //       print(payload);
  //       if (payload != null && payload.isNotEmpty) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => NewPage(info: payload.toString()),
  //           ),
  //         );
  //       } else {}
  //     } catch (e) {}
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("..........onMessage ............");
  //     print('onMessage: ${message.notification?.title}/${message.data}');

  //     // BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //     //   message.notification!.body.toString(),
  //     //   htmlFormatBigText: true,
  //     // );
  //     // AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(channelId, channelName)
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Smart Naka',
      theme: darkThemeData,
      home: AnimatedSplashScreen(
        backgroundColor: backgroundDark,
        centered: true,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        splash: const SplashScreen(),
        nextScreen: isLoggedIn ? const BottomNav() : const LoginPage(),
      ),
    );
  }
}
