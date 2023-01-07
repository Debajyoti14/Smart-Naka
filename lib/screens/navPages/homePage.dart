import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_naka_ethos/models/police.dart';

import '../../controller/user_controller.dart';
import '../../dummyDB/stolen_cars.dart';
import '../../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnDuty = true;
  var policeController = Get.put(UserController());
  late Police policeDetails;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isOnDuty
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Stolen cars Updates',
                  style: TextStyle(fontSize: 20),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: stolenCarsData.length,
                  itemBuilder: (context, index) {
                    final carData = stolenCarsData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StolenCarWidget(
                        carColor: carData['Car Color'],
                        carNo: carData['Car Number'],
                        lastLocation: carData['Last Location'],
                        lastSeen: carData['last Seen'],
                        modelNo: carData['Model Name'],
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
