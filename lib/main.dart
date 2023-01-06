import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/auth/login.dart';
import 'package:smart_naka_ethos/screens/navPages/bottomNav.dart';
import 'package:smart_naka_ethos/splash.dart';
import 'package:smart_naka_ethos/themes.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    _checkLoginPrefs();
  }

  void _checkLoginPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
