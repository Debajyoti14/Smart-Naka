import 'package:flutter/material.dart';

class MatchedCars extends StatelessWidget {
  final String modelNo;
  final String carColor;
  final String carNo;
  final String imageURL;
  const MatchedCars(
      {super.key,
      required this.modelNo,
      required this.carColor,
      required this.carNo,
      required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(children: [
          SizedBox(
            width: 140,
            child: Image.network(
              imageURL,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modelNo,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                carNo,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                carColor,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
