import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/auth/login.dart';
import 'package:smart_naka_ethos/screens/fromNotification/lost_car_notification.dart';
import 'package:smart_naka_ethos/screens/navPages/bottomNav.dart';
import 'package:smart_naka_ethos/splash.dart';
import 'package:smart_naka_ethos/themes.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

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
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.data['body']);
    Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
      builder: (_) => LostCarNotification(
        carNo: message.data['body'],
      ),
    ));
  }

  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    requestPermission();
    _checkLoginPrefs();
    setupInteractedMessage();
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
        duration: 2000,
        splashTransition: SplashTransition.fadeTransition,
        splash: const SplashScreen(),
        nextScreen: isLoggedIn ? const BottomNav() : const LoginPage(),
      ),
    );
  }
}
