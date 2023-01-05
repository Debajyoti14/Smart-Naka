import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:smart_naka_ethos/controller/auth_controller.dart';
import 'package:smart_naka_ethos/screens/navPages/bottomNav.dart';
import 'package:smart_naka_ethos/utils/constants.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = '';
  var loginController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
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
                    color: accentGreen,
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
                onSubmit: (String code) {
                  //handle validation or checks here
                  otp = code;
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomGreenButton(
                buttonText: 'Verify',
                onPressed: () async {
                  try {
                    print('Here is the -------> $otp');
                    final response = await loginController.verifyOTP(
                        widget.phoneNumber, otp);
                    print('It is the response body ----> ${response.body}');
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       title: const Text("Verification Code"),
                    //       content: Text('Code entered is $otp'),
                    //     );
                    //   },
                    // );
                    final responseData = json.decode(response.body);
                    print(responseData['success']);
                    if (responseData['success'] == 'true') {
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      var snackBar = const SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text('Wrong OTP'));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
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
