import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/widgets/matched_cars.dart';

import '../../dummyDB/stolen_cars.dart';
import '../../utils/constants.dart';

class RetrivedCars extends StatefulWidget {
  const RetrivedCars({super.key});

  @override
  State<RetrivedCars> createState() => _RetrivedCarsState();
}

class _RetrivedCarsState extends State<RetrivedCars> {
  bool isOnDuty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
              'Possible Matches',
              style: TextStyle(fontSize: 20),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: stolenCarsData.length,
              itemBuilder: ((context, index) {
                final carData = stolenCarsData[index];
                return MatchedCars(
                  modelNo: carData['Model Name'],
                  carColor: carData['Car Color'],
                  carNo: carData['Car Number'],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
