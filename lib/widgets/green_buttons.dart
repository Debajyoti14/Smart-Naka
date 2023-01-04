import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomGreenButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;

  const CustomGreenButton(
      {super.key, required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: accentGreen,
            textStyle: const TextStyle(color: backgroundDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20, color: backgroundDark),
        ),
      ),
    );
  }
}
