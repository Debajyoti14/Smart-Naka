import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';

import '../../dummyDB/stolen_cars.dart';
import '../../utils/constants.dart';
import 'homePage.dart';

class AddMissingDiary extends StatefulWidget {
  const AddMissingDiary({super.key});

  @override
  State<AddMissingDiary> createState() => _AddMissingDiaryState();
}

class _AddMissingDiaryState extends State<AddMissingDiary> {
  bool isOnDuty = true;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                'Missing Diary By',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Name'),
              const SizedBox(height: 10),
              const Text(
                'Car Details',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Car Number'),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Car Model'),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Color'),
              const SizedBox(height: 10),
              const Text(
                'Add Car Photos',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Minimum 1 Image required',
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
        // children: [
        // MaterialButton(
        //     color: Colors.blue,
        //     child: const Text(
        //       "Pick Images from Gallery",
        //       style: TextStyle(
        //           color: Colors.white70, fontWeight: FontWeight.bold),
        //     ),
        //     onPressed: () {
        //       selectImages();
        //     }),
        // const SizedBox(
        //   height: 20,
        // ),
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: GridView.builder(
        //       itemCount: imageFileList.length,
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 3),
        //       itemBuilder: (BuildContext context, int index) {
        //         return Image.file(File(imageFileList[index].path),
        //             fit: BoxFit.cover);
        //       },
        //     ),
        //   ),
        // )
        // ],
      ),
    );
  }
}
