import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../constant/root.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  Future<MyServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

initialservices() async {
  await Get.putAsync(() => MyServices().init());
}

class LocalController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  getlang() {
    String? languageCode = myServices.sharedPreferences.getString("lang") ??
        Get.deviceLocale!.languageCode;
    language = Locale(languageCode);
    lang = languageCode;
  }

  // void getMode() {
  //   String? devicemode = myServices.sharedPreferences.getString("Mode");
  //   if (devicemode != null) {
  //     themeMode = devicemode == "Mode"
  //         ? ThemeMode.system
  //         : devicemode == "on"
  //             ? ThemeMode.dark
  //             : ThemeMode.light;
  //     mode = devicemode == "Mode"
  //         ? "Mode"
  //         : devicemode == "on"
  //             ? "on"
  //             : "off";
  //   } else {
  //     themeMode = themeMode == ThemeMode.system
  //         ? ThemeMode.system
  //         : Get.isDarkMode
  //             ? ThemeMode.dark
  //             : ThemeMode.light;
  //     mode = themeMode == ThemeMode.system
  //         ? "Mode"
  //         : Get.isDarkMode
  //             ? "on"
  //             : "off";
  //   }
  // }

  @override
  void onInit() {
    getlang();
    // getMode();
    super.onInit();
  }
}
