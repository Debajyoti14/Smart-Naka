import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user_controller.dart';
import '../../dummyDB/stolen_cars.dart';
import '../../utils/api_url.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnDuty = true;
  var policeController = Get.put(UserController());
  late Map<String, dynamic> policeStationNotification;
  final apiKey = dotenv.env['API_KEY'];

  @override
  void initState() {
    super.initState();
  }

  _getPoliceStationNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final policeStation = prefs.getString('policeStation') ?? '';
    final url = Uri.parse('$apiURL/get-police-station-notifications');
    final Map<String, dynamic> map = {
      "policeStation": policeStation,
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
    final details = json.decode(response.body);
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPoliceStationNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: accentGreen,
            ),
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
          print(carDetails);

          return isOnDuty
              ? SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Stolen cars Updates',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: stolenCarsData.length,
                        itemBuilder: (context, index) {
                          final carData = carDetails['trackDetails'][index];
                          print(carData);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            // child: Text('1'),
                            child: StolenCarHomeWidget(
                              modelNo: carData['number'],
                              lastLocation: carData['location'],
                              lastSeen: carData['timeStamp'],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Go on Duty',
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 20),
                      Transform.scale(
                        scale: 3,
                        child: Switch(
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
                    ],
                  ),
                );
        }
        return const Text('Something was wrong!');
      },
    );
  }
}

class StolenCarHomeWidget extends StatelessWidget {
  final String modelNo;
  final String lastLocation;
  final int lastSeen;

  const StolenCarHomeWidget({
    super.key,
    required this.modelNo,
    required this.lastLocation,
    required this.lastSeen,
  });

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
          Text(
            modelNo,
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Spotted at $lastLocation ${(DateTime.fromMillisecondsSinceEpoch(lastSeen)).toString()}  📌',
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
