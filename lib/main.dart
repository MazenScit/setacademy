
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:setappstore/auth/log_in.dart';
import 'package:setappstore/screen/welcome.dart';
import 'logale/locale_Cont.dart';
import 'logale/logale.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      translations: MyLocale(),
      theme: ThemeData(
        fontFamily: 'Cobe',
      ),
      debugShowCheckedModeBanner: false,
      home: WalkThroughScreen(),
      routes: {
        'login': ((context) => login()),
      },
    );
  }
}
