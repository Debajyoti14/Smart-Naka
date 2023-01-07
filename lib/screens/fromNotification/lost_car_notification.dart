import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

import '../../utils/api_url.dart';
import '../../utils/constants.dart';

class LostCarNotification extends StatefulWidget {
  final String carNo;
  const LostCarNotification({super.key, required this.carNo});

  @override
  State<LostCarNotification> createState() => _LostCarNotificationState();
}

class _LostCarNotificationState extends State<LostCarNotification> {
  final apiKey = dotenv.env['API_KEY'];

  _getLostCarDetails() async {
    var url = Uri.parse('$apiURL/lost-cars/get-a-car');

    Map data = {
      'number': widget.carNo,
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey!,
        },
        body: body);
    final carDetails = json.decode(response.body);
    return carDetails;
  }

  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _getLostCarDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: accentGreen,
          );
        }
        if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                snapshot.error.toString(),
              ),
            ],
          );
        }
        if (snapshot.hasData) {
          final carDetails = snapshot.data! as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: accentGreen,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7Xh9PifMRhzJfnv4DVRnhcFv1DsMB0RtcAQ&usqp=CAU'),
                      ),
                    ),
                    title: Column(
                      children: [
                        const Text('Chingam Pandey'),
                        Text(
                          'Head Belgharia Branch',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    trailing: Switch(
                      activeColor: accentGreen,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      value: isOnDuty,
                      onChanged: (value) {
                        setState(() {
                          isOnDuty = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Car Details',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    carDetails['imgs'][0],
                    width: double.infinity,
                  ),
                  StolenCarWidget(
                    carColor: carDetails['color'],
                    carNo: carDetails['number'],
                    lastLocation: carDetails['foundCarDetails']
                        ?['foundAtpoliceStation'],
                    modelNo: carDetails['model'],
                    lastSeen: carDetails['foundCarDetails']
                        ?['foundAtTimeStamp'],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Lost Diary Details',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carDetails['model'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Filed on:  ${DateTime.fromMillisecondsSinceEpoch(carDetails['lostDiaryDetails']['filedAtTimeStamp'])}',
                        ),
                        Text(
                          'Filed at:  ${carDetails['lostDiaryDetails']['filedPoliceStation']}',
                        ),
                        Text(
                          'Filed by officer:  ${carDetails['lostDiaryDetails']['filedByOfficer']['name']}',
                        ),
                        Text(
                          'Filed by:  ${carDetails['filedBy']}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Car Owner Details',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${carDetails['carOwnerDetails']['name']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Phone No.:  ${carDetails['carOwnerDetails']['phone']}',
                        ),
                        Text(
                          'Address:  ${carDetails['carOwnerDetails']['address']}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CustomGreenButton(buttonText: 'Mark as card found')
                ],
              ),
            ),
          );
        }
        return const Text('Something was wrong!');
      },
    ));
  }
}

class StolenCarWidget extends StatelessWidget {
  final String? modelNo;
  final String? carColor;
  final String? carNo;
  final String? lastLocation;
  final String? lastSeen;

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
          (lastLocation != null)
              ? Text(
                  'Spotted at $lastLocation $lastSeen  📌',
                  style: const TextStyle(fontSize: 14),
                )
              : Container()
        ],
      ),
    );
  }
}
