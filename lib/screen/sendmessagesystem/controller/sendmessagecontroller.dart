import 'dart:math';

import 'package:get/get.dart';
import 'package:setappstore/screen/sendmessagesystem/controller/syriatelcontroller.dart';
import 'package:url_launcher/url_launcher.dart';

sendmessage(String phonenumber,String mypass) async {

  print(mypass);
  Random rnd;
  int min = 100000;
  int max = 999999;
  rnd = new Random();
  String completephonenumber = "963" + phonenumber.substring(1, 10);
  print(completephonenumber);
  int code = min + rnd.nextInt(max - min);

  print("code");
  print(code);
  print("https://bms.syriatel.sy/API/SendSMS.aspx?user_name=S.E.Tcenter1&password=$mypass&msg=رمز التفعيل الخاص بك هو $code&sender=S.E.Tcenter&to=$completephonenumber");
  // String encrypted=encription(code.toString());
  _launchURL(
      "https://bms.syriatel.sy/API/SendSMS.aspx?user_name=S.E.Tcenter1&password=$mypass&msg=رمز التفعيل الخاص بك هو $code&sender=S.E.Tcenter&to=$completephonenumber");
  return code.toString();
}

_launchURL(String _url) async {
  final Uri url = Uri.parse(_url);

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $_url');
  }
}

// encription(String plainText){
//   final key = Key.fromSecureRandom(32);
//   final iv = IV.fromSecureRandom(16);
//   final encrypter = Encrypter(AES(key));
//   final encrypted = encrypter.encrypt(plainText, iv: iv);
//   final decrypted = encrypter.decrypt(encrypted, iv: iv);
//   print(decrypted);
//   print(encrypted.base16);
//   print(encrypted.base64);
//   return encrypted.base16;
// }