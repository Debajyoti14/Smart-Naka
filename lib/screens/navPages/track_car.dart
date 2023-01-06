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
