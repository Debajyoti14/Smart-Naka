import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

class TrackCarDisplay extends StatelessWidget {
  const TrackCarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
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
            Image.asset("assets/car.png"),
            const SizedBox(
              height: 60,
            ),
            const StolenCarWidget(
              carColor: 'White',
              carNo: 'WB124DH',
              lastLocation: 'Ruby Crossing',
              lastSeen: '9:00 AM',
              modelNo: 'HYUNDAI',
            ),
            const SizedBox(height: 20),
            const Text(
              'Tracking History',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: const Text(
                'Found at Ruby crossing at 9:06AM 📍',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            CustomGreenButton(
              buttonText: 'Turn on Tracking Notification',
              onPressed: () {},
            )
          ],
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
          Text(
            'Spotted at $lastLocation $lastSeen  📌',
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
