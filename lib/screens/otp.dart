import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DEFAULT_PADDING,
          vertical: 25,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset('assets/logo.png'),
                const Text(
                  'Smart Naka',
                  style: TextStyle(
                    fontSize: 32,
                    color: ACCENT_GREEN,
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Otp sent to',
              style: Theme.of(context).textTheme.caption,
            ),
            const Text(
              '+91 891XXXXX092',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 150,
              child: OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.grey,
                focusedBorderColor: Colors.white,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ACCENT_GREEN,
                    textStyle: const TextStyle(color: BACKGROUND_DARK)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OTPScreen()),
                  );
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 20, color: BACKGROUND_DARK),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Resend OTP (29s)',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
