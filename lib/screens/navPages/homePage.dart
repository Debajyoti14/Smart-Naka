import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnDuty = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundColor: ACCENT_GREEN,
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
              activeColor: ACCENT_GREEN,
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
          )
        ],
      ),
    );
  }
}
