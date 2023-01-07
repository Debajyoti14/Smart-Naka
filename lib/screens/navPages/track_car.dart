import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_naka_ethos/screens/navPages/profile.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_url.dart';

class TrackCar extends StatefulWidget {
  const TrackCar({super.key});

  @override
  State<TrackCar> createState() => _TrackCarState();
}

class _TrackCarState extends State<TrackCar> {
  final apiKey = dotenv.env['API_KEY'];

  _verifyCarWithNumber(String carNumber) async {
    final url = Uri.parse('$apiURL/lost-cars/get-a-car');
    final Map<String, dynamic> map = {
      "number": carNumber,
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
    if (response.body != {}) {
      if (!mounted) return;
      var snackBar = const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('No Stolen Cars Found with this Car No.'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
    return response.body;
  }

  final carNumberEditingController = TextEditingController();
  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset("assets/car.png"),
          const SizedBox(
            height: 60,
          ),
          CustomTextField(
            hintText: "Enter car Number",
            controller: carNumberEditingController,
          ),
          const SizedBox(
            height: 40,
          ),
          CustomGreenButton(
            buttonText: "Verify",
            onPressed: () async {
              await _verifyCarWithNumber(carNumberEditingController.text);
            },
          )
        ],
      ),
    );
  }
}
