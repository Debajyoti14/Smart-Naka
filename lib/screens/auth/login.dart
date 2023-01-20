import 'package:flutter/cupertino.dart';
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
  String policeID = '';
  bool _isLoading = false;
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
                    isLoading: _isLoading,
                    buttonText: 'Verify',
                    onPressed: () async {
                      try {
                        _isLoading = true;
                        setState(() {});
                        final policeDetails =
                            await policeController.getUserDetails();

                        await loginController.getOTP(policeDetails.number).then(
                          (value) {
                            print(value.body);
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => OTPScreen(
                                  imageURL: policeDetails.avatar,
                                  phoneNumber: policeDetails.number,
                                  policeStation: policeDetails.policeStation,
                                  policeID: policeDetails.id,
                                  policeName: policeDetails.name,
                                ),
                              ),
                            );
                            _isLoading = false;
                            setState(() {});
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
