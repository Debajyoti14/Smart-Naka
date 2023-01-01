import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: [
                TextFormField(
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
                    onPressed: () {},
                    child: const Text('Verify'),
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
