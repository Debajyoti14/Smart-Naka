import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_naka_ethos/models/police.dart';

import '../utils/api_url.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  late Police userDetails;

  TextEditingController policeIDController = TextEditingController();

  Future<Police> getUserDetails() async {
    var url = Uri.parse('$apiURL/police/get');

    Map data = {'id': policeIDController.text};

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey!,
        },
        body: body);
    userDetails = Police.fromJson(json.decode(response.body));
    return userDetails;
  }
}
