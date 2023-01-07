import 'package:flutter/material.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

import '../../utils/constants.dart';

class TrackCar extends StatefulWidget {
  const TrackCar({super.key});

  @override
  State<TrackCar> createState() => _TrackCarState();
}

class _TrackCarState extends State<TrackCar> {
  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 90),
          Image.asset("assets/car.png"),
          const SizedBox(
            height: 60,
          ),
          const CustomTextField(hintText: "Enter car Number"),
          const SizedBox(
            height: 40,
          ),
          CustomGreenButton(
            buttonText: "Verify",
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
