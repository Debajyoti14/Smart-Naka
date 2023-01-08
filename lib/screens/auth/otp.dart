import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/controller/auth_controller.dart';
import 'package:smart_naka_ethos/screens/navPages/bottomNav.dart';
import 'package:smart_naka_ethos/utils/api_url.dart';
import 'package:smart_naka_ethos/utils/constants.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String policeStation;
  final String policeID;
  final String policeName;
  final String imageURL;

  const OTPScreen(
      {super.key,
      required this.phoneNumber,
      required this.policeStation,
      required this.policeID,
      required this.policeName,
      required this.imageURL});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = '';
  bool _isLoading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final apiKey = dotenv.env['API_KEY'];

  _subscribeDevice(String deviceToken, String policeStation) async {
    print(deviceToken);
    final url = Uri.parse('$apiURL/subscribe-device');
    final Map<String, dynamic> map = {
      "topicName": policeStation,
      "deviceToken": deviceToken
    };

    var body = json.encode(map);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey!,
      },
      body: body,
    );
    print(response.statusCode);
    print(response.body);
    return response;
  }

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
                cursorColor: Colors.white,
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
                isLoading: _isLoading,
                buttonText: 'Verify',
                onPressed: () async {
                  try {
                    _isLoading = true;
                    setState(() {});
                    final response = await loginController.verifyOTP(
                      widget.phoneNumber,
                      otp,
                    );
                    final responseData = json.decode(response.body);
                    print(responseData['success']);
                    if (responseData['success'] == true) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      await prefs.setString('policeID', widget.policeID);
                      await prefs.setString('policeName', widget.policeName);
                      await prefs.setString(
                          'policeStation', widget.policeStation);
                      await prefs.setString('imageURL', widget.imageURL);
                      // For subscribe to Topics
                      _firebaseMessaging.getToken().then((token) =>
                          _subscribeDevice(token!, widget.policeStation));
                      // Redirecting to Page acc. to Login Status
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const BottomNav(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                      _isLoading = false;
                      setState(() {});
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
