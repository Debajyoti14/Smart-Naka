import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/logo.png'),
        const Text(
          'Smart Naka',
          style: TextStyle(color: accentGreen),
        )
      ]),
    );
  }
}
