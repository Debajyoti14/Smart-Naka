import 'dart:convert';
// import 'dart:html';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';

import '../../utils/api_url.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

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

  // Future<http.Response> uploadImages() async {
  //   final sampleFile = io.File(imageFileList[0].path);
  //   Blob blob = Blob(await sampleFile.readAsBytes());
  //   var url = Uri.parse('$apiURL/upload-file');

  //   Map data = {
  //     'image': blob,
  //   };

  //   var body = json.encode(data);

  //   var response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "x-api-key": apiKey!,
  //       },
  //       body: body);
  //   print("${response.statusCode}");
  //   return response;
  // }

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
              const SizedBox(height: 20),
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
                  // await uploadImages();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
