import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_naka_ethos/utils/api_url.dart';

class AuthController extends GetxController {
  final apiKey = dotenv.env['API_KEY'];

  Future<http.Response> getOTP(String phoneNo) async {
    var url = Uri.parse('$apiURL/otp/send');
    print(phoneNo);
    Map data = {'number': phoneNo, 'TTL': '60'};

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey!,
        },
        body: body);
    print("${response.statusCode}");
    print(response.body);
    return response;
  }

  Future<http.Response> verifyOTP(String phoneNo, String otpEntered) async {
    var url = Uri.parse('$apiURL/otp/verify');

    Map data = {'number': phoneNo, 'otp': otpEntered};

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey!,
        },
        body: body);
    print("${response.statusCode}");
    print(response.body);
    return response;
  }

  // Future<http.Response> getPoliceDetailsWithID() async {}
}
