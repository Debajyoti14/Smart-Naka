import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  Future<http.Response> getOTP() async {
    var url = Uri.parse(
        'https://g8ujux4qw4.execute-api.ap-south-1.amazonaws.com/dev-test/send-otp');

    Map data = {'number': '7687979148', 'TTL': '60'};

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<http.Response> verifyOTP(String OTPEntered) async {
    var url = Uri.parse(
        'https://g8ujux4qw4.execute-api.ap-south-1.amazonaws.com/dev-test/verify-otp');

    Map data = {'number': '7687979148', 'otp': OTPEntered};

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
