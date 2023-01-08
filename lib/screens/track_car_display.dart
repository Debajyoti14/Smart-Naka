import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

import '../utils/api_url.dart';

class TrackCarDisplay extends StatelessWidget {
  final Map<String, dynamic> trackDetails;
  TrackCarDisplay({super.key, required this.trackDetails});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final apiKey = dotenv.env['API_KEY'];

  _subscribeForTrackingDetails() {
    _firebaseMessaging
        .getToken()
        .then((token) => _subscribeDevice(token!, trackDetails['number']));
  }

  _subscribeDevice(String deviceToken, String carNo) async {
    print(deviceToken);
    final url = Uri.parse('$apiURL/subscribe-device');
    final Map<String, dynamic> map = {
      "topicName": carNo,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Car Details',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.center,
                child: Image.network(trackDetails['imgs'][0]),
              ),
              const SizedBox(
                height: 60,
              ),
              StolenCarWidget(
                carColor: trackDetails['color'],
                carNo: trackDetails['number'],
                lastLocation: trackDetails['trackDetails'][0]['location'],
                lastSeen: trackDetails['trackDetails'][0]['timeStamp'],
                modelNo: trackDetails['model'],
              ),
              const SizedBox(height: 20),
              const Text(
                'Tracking History',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: trackDetails['trackDetails'].length,
                itemBuilder: (context, index) {
                  final lastLocation =
                      trackDetails['trackDetails'][index]['location'];
                  final lastSeen =
                      trackDetails['trackDetails'][index]['timeStamp'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Text(
                        'Spotted at $lastLocation ${(DateTime.fromMillisecondsSinceEpoch(lastSeen!)).toString()} 📍',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              CustomGreenButton(
                buttonText: 'Turn on Tracking Notification',
                onPressed: _subscribeForTrackingDetails,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StolenCarWidget extends StatelessWidget {
  final String? modelNo;
  final String? carColor;
  final String? carNo;
  final String? lastLocation;
  final int? lastSeen;

  const StolenCarWidget(
      {super.key,
      this.modelNo,
      this.carColor,
      this.carNo,
      this.lastLocation,
      this.lastSeen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                modelNo!,
                style: const TextStyle(fontSize: 20),
              ),
              const Text(' - '),
              Text(
                carColor!,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          Text(
            carNo!,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Spotted at $lastLocation ${(DateTime.fromMillisecondsSinceEpoch(lastSeen!)).toString()}  📌',
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
