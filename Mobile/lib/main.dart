import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:testing/services/firebasemessage.dart';
import 'package:testing/services/services.dart';
import 'Routing/routing.dart';
import 'Translation/translation.dart';
import 'constant/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initialservices();
  await Firebase.initializeApp();
  await FirebaseApi().inittoken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalController>(
        init: LocalController(),
        builder: (controller) {
          return GetMaterialApp(
            locale: controller.language,
            themeMode: ThemeMode.light,
            theme: light,
            translations: MyTransition(),
            debugShowCheckedModeBanner: false,
            getPages: routes,
          );
        });
  }
}
