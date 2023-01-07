import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/widgets/matched_cars.dart';

import '../../dummyDB/stolen_cars.dart';

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
