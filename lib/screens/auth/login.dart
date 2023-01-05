import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_naka_ethos/controller/auth_controller.dart';
import 'package:smart_naka_ethos/controller/user_controller.dart';
import 'package:smart_naka_ethos/screens/auth/otp.dart';
import 'package:smart_naka_ethos/utils/constants.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';

import '../../widgets/green_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // _snsNotification() async {
  //   final url = Uri.parse(
  //       'https://g8ujux4qw4.execute-api.ap-south-1.amazonaws.com/dev-test');
  //   final Map<String, dynamic> map = {
  //     "deviceToken":
  //         "eYKk1OXgRF-m2_2BQOtBMc:APA91bF4xKgqaB_lBGy__RbfS35ezogvOh1TWjvoiREji3kMCeErqAolCLt2xLoakSEDI63Pau0qiEckTn3sFzz19hZl-PopjAgcQH4nSEaf10UawKuZPG4UddduNQFZeXdiW1OFX_V9"
  //   };

  //   var body = json.encode(map);

  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/json"}, body: body);
  //   print("${response.statusCode}");
  //   print("${response.body}");
  //   return response;
  // }
  String policeID = '';
  var loginController = Get.put(AuthController());
  var policeController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Welcome to Naka',
              style:
                  Theme.of(context).textTheme.headline5!.copyWith(fontSize: 32),
            ),
            Column(
              children: [
                CustomTextField(
                  controller: policeController.policeIDController,
                  hintText: 'Enter Police ID',
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'ID Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomGreenButton(
                    buttonText: 'Verify',
                    onPressed: () async {
                      try {
                        final policeDetails =
                            await policeController.getUserDetails();

                        await loginController.getOTP(policeDetails.number).then(
                          (value) {
                            print(value.body);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  phoneNumber: policeDetails.number,
                                ),
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
