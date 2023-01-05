import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/screens/auth/login.dart';
import 'package:smart_naka_ethos/screens/navPages/homePage.dart';
import 'package:smart_naka_ethos/splash.dart';
import 'package:smart_naka_ethos/themes.dart';

Future main() async {
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
    // _navigateAfterLogin();
  }

  void _checkLoginPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      },
    );
  }

  _navigateAfterLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (!mounted) return;
    isLoggedIn
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()))
        : Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Naka',
      theme: darkThemeData,
      home: AnimatedSplashScreen(
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        splash: const SplashScreen(),
        nextScreen: isLoggedIn ? const HomePage() : const LoginPage(),
      ),
    );
  }
}
