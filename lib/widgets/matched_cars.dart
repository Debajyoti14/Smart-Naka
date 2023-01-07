import 'package:flutter/material.dart';

class MatchedCars extends StatelessWidget {
  final String? modelNo;
  final String? carColor;
  final String? carNo;
  const MatchedCars({super.key, this.modelNo, this.carColor, this.carNo});

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
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7Xh9PifMRhzJfnv4DVRnhcFv1DsMB0RtcAQ&usqp=CAU',
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
                modelNo!,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                carNo!,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                carColor!,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
