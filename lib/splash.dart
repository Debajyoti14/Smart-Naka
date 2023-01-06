import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Transform.scale(scale: 6, child: Image.asset('assets/logo.png')),
      ),
      const SizedBox(height: 30),
      const Text(
        'Smart Naka',
        style: TextStyle(color: accentGreen, fontSize: 26),
      )
    ]);
  }
}
