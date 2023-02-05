import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

import '../../utils/api_url.dart';
import '../../utils/constants.dart';
import '../track_car_display.dart';

class LostCarNotification extends StatefulWidget {
  final String carNo;
  const LostCarNotification({super.key, required this.carNo});

  @override
  State<LostCarNotification> createState() => _LostCarNotificationState();
}

class _LostCarNotificationState extends State<LostCarNotification> {
  final apiKey = dotenv.env['API_KEY'];
  bool _isLoading = false;
  String policeID = '';
  String policeName = '';
  String policeStation = '';
  late final Future myFuture;
  String imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvPasPbrVe2Txcc4aGbZkCddJkVTaj8uyb7A&usqp=CAU';
  late Map<String, dynamic> carDetailsFound;
  final TextEditingController _textFieldAddressController =
      TextEditingController();
  final TextEditingController _textFieldEmailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    setPoliceDetails();
    myFuture = _getLostCarDetails();
  }

  setPoliceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    policeID = prefs.getString('policeID') ?? '';
    policeName = prefs.getString('policeName') ?? '';
    policeStation = prefs.getString('policeStation') ?? '';
    imageURL = prefs.getString('imageURL') ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWeTekI6pbMf77pjGcHI2id9k1U8IdM5WtGg&usqp=CAU';
    setState(() {});
  }

  _getLostCarDetails() async {
    var url = Uri.parse('$apiURL/lost-cars/get-a-car');

    Map data = {
      'number': widget.carNo,
    };

    var body = json.encode(data);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey!,
      },
      body: body,
    );
    final carDetails = json.decode(response.body);
    carDetailsFound = carDetails;

    return carDetails;
  }

  _setCarFound() async {
    var url = Uri.parse('$apiURL/lost-cars/found');

    // final date = DateFormat("yy-MM-dd");
    // final time = DateFormat("Hm");
    // String onlyDate =
    //     date.format(carDetailsFound['trackDetails'][0]['timeStamp']);
    // String onlyTime =
    //     time.format(carDetailsFound['trackDetails'][0]['timeStamp']);
    // print('--------------->');
    // print(onlyDate);
    // print(onlyTime);

    Map data = {
      "number": carDetailsFound['number'],
      "foundCarDetails": {
        "foundAt": "Patna City",
        "foundAtpoliceStation": policeStation,
        "foundAtTimeStamp": 1672816550273,
        "foundByOfficer": {"id": policeID, "name": policeName}
      },
      "emailDetails": {
        "toEmail": _textFieldEmailController.text,
        "carNumber": carDetailsFound['number'],
        "model": carDetailsFound['model'],
        "color": carDetailsFound['color'],
        "foundPlace": carDetailsFound['trackDetails'][0]['location'],
        "foundByPolice": policeName,
        "policeStation": policeStation,
        "time":
            carDetailsFound['foundCarDetails']?['foundAtTimeStamp'].toString(),
        "date":
            carDetailsFound['foundCarDetails']?['foundAtTimeStamp'].toString(),
        "carOwner": carDetailsFound['carOwnerDetails']?['name'],
        "ownerNumber": carDetailsFound['carOwnerDetails']?['phone'],
        "ownerAddress": _textFieldAddressController.text
      }
    };

    var body = json.encode(data);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey!,
      },
      body: body,
    );
    final carDetails = json.decode(response.body);
    return carDetails;
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter additional details'),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextField(
                    controller: _textFieldAddressController,
                    decoration:
                        const InputDecoration(hintText: "Car Found Place"),
                  ),
                  TextField(
                    controller: _textFieldEmailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _textFieldEmailController.clear();
                  _textFieldAddressController.clear();
                },
              )
            ],
          );
        });
  }

  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: myFuture,
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentGreen,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(imageURL),
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(policeName),
                        Text(
                          policeStation,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      carDetails['imgs']?[0] ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvPasPbrVe2Txcc4aGbZkCddJkVTaj8uyb7A&usqp=CAU',
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StolenCarWidget(
                    carColor: carDetails['color'],
                    carNo: carDetails['number'],
                    lastLocation: carDetails['foundCarDetails']
                        ?['foundAtpoliceStation'],
                    modelNo: carDetails['model'],
                    lastSeen: DateTime.fromMillisecondsSinceEpoch(
                            carDetails['trackDetails'][0]?['timeStamp'])
                        .toString(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TrackCarDisplay(
                            trackDetails: carDetails,
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: accentGreen),
                    child: const Text('View Tracking Details'),
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
                  CustomGreenButton(
                    isLoading: _isLoading,
                    buttonText: 'Mark as card found',
                    onPressed: () async {
                      await _displayDialog(context);
                      _isLoading = true;
                      setState(() {});

                      await _setCarFound();
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      var snackBar = const SnackBar(
                        backgroundColor: Colors.grey,
                        content: Text('Car retrieved successfully recorded'),
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      _isLoading = false;
                      setState(() {});
                    },
                  )
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
