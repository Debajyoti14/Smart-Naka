import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class CustomGreenButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final void Function()? onPressed;

  const CustomGreenButton(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          // textStyle: const TextStyle(color: backgroundDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: backgroundDark,
                ),
              )
            : Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 20,
                  color: backgroundDark,
                ),
              ),
      ),
    );
  }
}
