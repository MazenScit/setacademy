

import 'dart:convert';
import 'package:http/http.dart' as http;

class SyriatelController {
    Future<String?> getmarks() async {
    String myUrl = "https://set-institute.net/api/password-sy";
    print(myUrl);
    http.Response response = await http.get(Uri.parse(myUrl) );
    if (response.statusCode == 200) {
      print(response.body);
      try {
        
        return jsonDecode(response.body)['password'];
      } catch (error) {
        print(error);

        return null;
      }
    } else {
      return null;
      // throw "Error While getting Properties";
    }
  }


}