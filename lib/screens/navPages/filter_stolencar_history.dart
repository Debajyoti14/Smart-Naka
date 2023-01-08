import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_naka_ethos/screens/navPages/filter_stolencar_details.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

import '../../dummyDB/police_station.dart';
import '../../utils/api_url.dart';

class FilterStolenCarHistory extends StatefulWidget {
  const FilterStolenCarHistory({super.key});

  @override
  State<FilterStolenCarHistory> createState() => _FilterStolenCarHistoryState();
}

class _FilterStolenCarHistoryState extends State<FilterStolenCarHistory> {
  List<Map<String, dynamic>> filteredCars = [];
  bool isOnDuty = true;
  String filterPoliceStation = 'Patna Police Station';
  final apiKey = dotenv.env['API_KEY'];

  TextEditingController noOfDaysEditingController = TextEditingController();

  _getLostCarDetails() async {
    var url = Uri.parse('$apiURL/lost-cars/filtered-cars');

    Map data = {
      'policeStation': filterPoliceStation,
      'time': noOfDaysEditingController.text,
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
    final filteredCarDetails = json.decode(response.body);
    print(filteredCarDetails);
    if (filteredCarDetails['data'] != []) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              FilterStolenCarDetails(filteredCars: filteredCarDetails['data']),
        ),
      );
    } else {
      var snackBar = const SnackBar(
          backgroundColor: Colors.grey, content: Text('No Records Found'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return filteredCarDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Stolen Car History',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Center(child: Image.asset('assets/filtersearch.png')),
            const SizedBox(height: 30),

            DropdownButton<String>(
              value: filterPoliceStation,
              hint: const Text('Select your Police Station'),
              isExpanded: true,
              items: policeStations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                filterPoliceStation = value ?? '';
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'No of Days.',
              controller: noOfDaysEditingController,
            ),
            const SizedBox(height: 30),
            CustomGreenButton(
              buttonText: 'Search',
              onPressed: () async {
                await _getLostCarDetails();

                // if (filteredCarDetails['data'] != null) {
                //   if (!mounted) return;
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (_) => FilterStolenCarDetails(
                //         filteredCars: filteredCarDetails['data'],
                //       ),
                //     ),
                //   );
                // }
              },
            )

            // ListView.builder(
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: stolenCarsData.length,
            //   itemBuilder: ((context, index) {
            //     final carData = stolenCarsData[index];
            //     return MatchedCars(
            //       modelNo: carData['Model Name'],
            //       carColor: carData['Car Color'],
            //       carNo: carData['Car Number'],
            //     );
            //   }),
            // )
          ],
        ),
      ),
    );
  }
}
