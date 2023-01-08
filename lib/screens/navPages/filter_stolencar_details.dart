import 'package:flutter/material.dart';

import '../../widgets/matched_cars.dart';

class FilterStolenCarDetails extends StatelessWidget {
  final List filteredCars;
  const FilterStolenCarDetails({super.key, required this.filteredCars});

  @override
  Widget build(BuildContext context) {
    // print(filteredCars);
    // return Text('1');
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Filtered Results',
              style: TextStyle(fontSize: 20),
            ),
            Text('Search Results Found - ${filteredCars.length}'),
            const SizedBox(height: 30),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredCars.length,
              itemBuilder: ((context, index) {
                final carData = filteredCars[index];
                print(carData);
                // return Text('1');

                return MatchedCars(
                  imageURL: carData['imgs'][0] ?? '',
                  modelNo: carData['model'],
                  carColor: carData['color'],
                  carNo: carData['number'],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
