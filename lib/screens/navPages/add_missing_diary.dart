import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import '../../utils/api_url.dart';
import '../../utils/constants.dart';
import '../fromNotification/lost_car_notification.dart';

class AddMissingDiary extends StatefulWidget {
  const AddMissingDiary({super.key});

  @override
  State<AddMissingDiary> createState() => _AddMissingDiaryState();
}

class _AddMissingDiaryState extends State<AddMissingDiary> {
  bool isOnDuty = true;
  final apiKey = dotenv.env['API_KEY'];
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

  _uploadMultipleImages() async {
    for (var image in imageFileList) {
      _uploadImages(image);
    }
  }

  Future<http.Response> _uploadImages(image) async {
    final bytes = io.File(image.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('$apiURL/upload-file');

    Map data = {
      'imageBinary': img64,
      'name': image.name,
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey!,
        },
        body: body);
    print(response.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  children: [
                    const Text(
                      'Add Car Photos',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Minimum 1 Image required',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                (imageFileList.length < 3)
                    ? IconButton(
                        color: accentGreen,
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () {
                          selectImages();
                        },
                      )
                    : const Text('Max 3 Images!'),
              ]),
              const SizedBox(
                height: 20,
              ),
              (imageFileList.isNotEmpty)
                  ? GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: imageFileList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, crossAxisSpacing: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          io.File(imageFileList[index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 20),
              const Text(
                'Owner Details',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Owner Name'),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Enter Phone Number'),
              const SizedBox(height: 10),
              CustomTextField(hintText: 'Address'),
              const SizedBox(height: 20),
              CustomGreenButton(
                buttonText: 'Add Missing Diary',
                onPressed: () async {
                  await _uploadMultipleImages();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
