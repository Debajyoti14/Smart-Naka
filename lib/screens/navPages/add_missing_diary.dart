import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_naka_ethos/widgets/custom_text_field.dart';
import 'package:smart_naka_ethos/widgets/green_buttons.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_url.dart';
import '../../utils/constants.dart';

class AddMissingDiary extends StatefulWidget {
  const AddMissingDiary({super.key});

  @override
  State<AddMissingDiary> createState() => _AddMissingDiaryState();
}

class _AddMissingDiaryState extends State<AddMissingDiary> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController carNoEditingController = TextEditingController();
  final TextEditingController carModelEditingController =
      TextEditingController();
  final TextEditingController carColorEditingController =
      TextEditingController();
  final TextEditingController ownerNameEditingController =
      TextEditingController();
  final TextEditingController phoneNoEditingController =
      TextEditingController();
  final TextEditingController addressEditingController =
      TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();

  bool isOnDuty = true;
  List uploadedImageURL = [];
  final apiKey = dotenv.env['API_KEY'];
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();

  String policeID = '';
  String policeName = '';
  String policeStation = '';
  bool isLoading = false;

  List<XFile> imageFileList = [];

  @override
  void initState() {
    setPoliceDetails();
    super.initState();
  }

  setPoliceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    policeID = prefs.getString('policeID') ?? '';
    policeName = prefs.getString('policeName') ?? '';
    policeStation = prefs.getString('policeStation') ?? '';
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  _uploadMultipleImages() async {
    for (var image in imageFileList) {
      final url = await _uploadImages(image);
      uploadedImageURL.add(url);
    }
  }

  _checkMissingCar() async {
    isLoading = true;
    setState(() {});
    await _uploadMultipleImages();
    var url = Uri.parse('$apiURL/lost-cars/missing-dairy');

    Map data = {
      "missingDairyData": {
        "number": carNoEditingController.text,
        "carOwnerDetails": {
          "address": addressEditingController.text,
          "name": ownerNameEditingController.text,
          "phone": phoneNoEditingController.text
        },
        "color": carColorEditingController.text,
        "isFound": false,
        "lostDiaryDetails": {
          "email": emailEditingController.text,
          "filedAtTimeStamp": DateTime.now().millisecondsSinceEpoch,
          "filedBy": nameEditingController.text,
          "filedByOfficer": {"id": policeID, "name": policeName},
          "filedPoliceStation": policeStation
        },
        "model": carModelEditingController.text,
        "trackDetails": [],
        "imgs": uploadedImageURL,
      }
    };

    var body = json.encode(data);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey!,
      },
      body: body,
    );
    isLoading = false;
    setState(() {});
    uploadedImageURL = [];
    return response.body;
  }

  _uploadImages(image) async {
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
    final urlImg = json.decode(response.body)['url'];
    return urlImg;
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
              CustomTextField(
                hintText: 'Enter Name',
                controller: nameEditingController,
              ),
              const SizedBox(height: 10),
              const Text(
                'Car Details',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Car Number',
                controller: carNoEditingController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Car Model',
                controller: carModelEditingController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Color',
                controller: carColorEditingController,
              ),
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
              CustomTextField(
                hintText: 'Enter Owner Name',
                controller: ownerNameEditingController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Phone Number',
                controller: phoneNoEditingController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Email',
                controller: emailEditingController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Address',
                controller: addressEditingController,
              ),
              const SizedBox(height: 20),
              CustomGreenButton(
                buttonText: 'Add Missing Diary',
                isLoading: isLoading,
                onPressed: () async {
                  await _checkMissingCar();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
