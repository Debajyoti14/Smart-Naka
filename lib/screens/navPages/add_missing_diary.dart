import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMissingDiary extends StatefulWidget {
  const AddMissingDiary({super.key});

  @override
  State<AddMissingDiary> createState() => _AddMissingDiaryState();
}

class _AddMissingDiaryState extends State<AddMissingDiary> {
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
        child: Column(
      children: [
        MaterialButton(
            color: Colors.blue,
            child: const Text(
              "Pick Images from Gallery",
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              selectImages();
            }),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: imageFileList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return Image.file(File(imageFileList[index].path),
                  fit: BoxFit.cover);
            },
          ),
        ))
      ],
    ));
  }
}
