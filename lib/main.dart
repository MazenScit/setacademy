import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:setappstore/auth/log_in.dart';
import 'package:setappstore/screen/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'logale/locale_Cont.dart';
import 'logale/logale.dart';
import 'screen/splash.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
