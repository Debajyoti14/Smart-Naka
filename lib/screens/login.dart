import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/screens/otp.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DEFAULT_PADDING,
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
                TextFormField(
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 13,
                      ),
                      hintText: 'Enter Police ID'),
                  onSaved: (value) => setState(() {
                    policeID = value!;
                  }),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'ID Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ACCENT_GREEN,
                        textStyle: const TextStyle(color: BACKGROUND_DARK)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const OTPScreen()),
                      );
                    },
                    child: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 20, color: BACKGROUND_DARK),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
