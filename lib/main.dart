import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/screens/login.dart';
import 'package:smart_naka_ethos/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Naka',
      theme: darkThemeData,
      home: const LoginPage(),
    );
  }
}
