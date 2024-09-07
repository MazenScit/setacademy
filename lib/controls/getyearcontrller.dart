import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class SendCode {
  Future sendCode(String serverUrl) async {
    String myUrl = serverUrl;
    http.Response response = await http.get(Uri.parse(myUrl),);
   print(response.body);
  }
}

