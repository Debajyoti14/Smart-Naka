import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_url.dart';
import '../track_car_display.dart';

class TrackCar extends StatefulWidget {
  const TrackCar({super.key});

  @override
  State<TrackCar> createState() => _TrackCarState();
}

class _TrackCarState extends State<TrackCar> {
  bool _isLoading = false;
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
    final trackDetails = json.decode(response.body);
    if (response.body.isEmpty) {
      if (!mounted) return;
      var snackBar = const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('No Stolen Cars Found with this Car No.'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TrackCarDisplay(
                trackDetails: trackDetails,
              )));
    }
    return response.body;
  }

  final carNumberEditingController = TextEditingController();
  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Track a Car',
              style: TextStyle(fontSize: 20),
            ),
            Center(child: Image.asset("assets/trackCar.png")),
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
              isLoading: _isLoading,
              buttonText: "Search",
              onPressed: () async {
                _isLoading = true;
                setState(() {});
                await _verifyCarWithNumber(carNumberEditingController.text);
                _isLoading = false;
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
